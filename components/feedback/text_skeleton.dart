import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import 'shimmer.dart';
import 'skeleton_block.dart';

/// Text-shaped shimmer bars whose random widths are seeded once and stay stable.
class TextSkeleton extends StatefulWidget {
  /// Renders [lines] bars sized to [style]; widths come from factors, or from character counts when any of [chars]/[minChars]/[maxChars] is set.
  const TextSkeleton({
    this.style,
    this.lines = 1,
    this.minFactor = 0.5,
    this.maxFactor = 0.9,
    this.chars,
    this.minChars,
    this.maxChars,
    this.widthFactor,
    this.barRadius = 8,
    this.seed,
    super.key,
  }) : assert(lines >= 1),
       assert(minFactor >= 0 && minFactor <= 1),
       assert(maxFactor >= 0 && maxFactor <= 1),
       assert(minFactor <= maxFactor),
       assert(chars == null || (minChars == null && maxChars == null)),
       assert(
         widthFactor == null ||
             (chars == null && minChars == null && maxChars == null),
       ),
       assert(chars == null || chars >= 1),
       assert(minChars == null || minChars >= 1),
       assert(maxChars == null || maxChars >= 1),
       assert(minChars == null || maxChars == null || minChars <= maxChars);

  /// Text style the bars are sized to; defaults to the ambient [DefaultTextStyle].
  final TextStyle? style;

  /// Number of bars.
  final int lines;

  /// Lower bound of the random width factor (share of available width).
  final double minFactor;

  /// Upper bound of the random width factor (share of available width).
  final double maxFactor;

  /// Fixed width in characters; the last line of a paragraph is shorter.
  final int? chars;

  /// Lower bound of the random character count per line.
  final int? minChars;

  /// Upper bound of the random character count per line.
  final int? maxChars;

  /// Fixed width as a share of available width, for every line.
  final double? widthFactor;

  /// Upper bound of the bar corner radius; the bar never exceeds half its height.
  final double barRadius;

  /// Overrides the container-derived seed and bypasses the child counter.
  final int? seed;

  @override
  State<TextSkeleton> createState() => _TextSkeletonState();
}

class _TextSkeletonState extends State<TextSkeleton> {
  static const double _barHeightFactor = 0.75;
  static const double _defaultFontSize = 14;
  static const double _defaultLineHeightFactor = 1.2;
  static const double _lastLineCharsFactor = 0.6;

  int? _derivedSeed;
  List<double>? _randoms;
  int _randomsLineCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_derivedSeed != null) return;
    final explicitSeed = widget.seed;
    if (explicitSeed != null) {
      _derivedSeed = explicitSeed;
      return;
    }
    final scope = context.dependOnInheritedWidgetOfExactType<ShimmerScope>();
    if (scope == null) return;
    _derivedSeed = scope.seed * 31 + scope.takeChildIndex();
  }

  List<double> _randomsFor(int seed, int lines) {
    final cached = _randoms;
    if (cached != null && _randomsLineCount == lines) return cached;
    final random = math.Random(seed);
    _randomsLineCount = lines;
    return _randoms = List.generate(lines, (_) => random.nextDouble());
  }

  double _factorForLine(int index, double randomValue) {
    final fixedFactor = widget.widthFactor;
    if (fixedFactor != null) return fixedFactor;
    final isLastLine = index == widget.lines - 1;
    final lower = isLastLine || widget.lines == 1 ? widget.minFactor : 0.85;
    final upper = isLastLine || widget.lines == 1 ? widget.maxFactor : 1.0;
    return lerpDouble(lower, upper, randomValue)!;
  }

  int _charsForLine(int index, double randomValue) {
    final isLastLine = index == widget.lines - 1;
    final fixedChars = widget.chars;
    if (fixedChars != null) {
      if (isLastLine && widget.lines > 1) {
        return math.max(1, (fixedChars * _lastLineCharsFactor).round());
      }
      return fixedChars;
    }
    final lowest = widget.minChars ?? 1;
    final highest = widget.maxChars ?? lowest * 2;
    final span = highest - lowest;
    final spansFullRange = isLastLine || widget.lines == 1;
    final position = spansFullRange
        ? randomValue
        : lerpDouble(0.85, 1.0, randomValue)!;
    return lowest + (position * (span + 1)).floor().clamp(0, span);
  }

  @override
  Widget build(BuildContext context) {
    final seed = _derivedSeed;
    if (seed == null) return Shimmer(child: widget);
    final scope = context.dependOnInheritedWidgetOfExactType<ShimmerScope>();
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final fontSize = style.fontSize ?? _defaultFontSize;
    final lineHeight = fontSize * (style.height ?? _defaultLineHeightFactor);
    final barHeight = fontSize * _barHeightFactor;
    final barRadius = math.min(barHeight / 2, widget.barRadius);
    final randoms = _randomsFor(seed, widget.lines);
    final usesChars =
        widget.chars != null ||
        widget.minChars != null ||
        widget.maxChars != null;
    final charWidth = usesChars
        ? _CharWidth.of(style, MediaQuery.textScalerOf(context))
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.lines; i++)
          SizedBox(
            height: lineHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SkeletonBlock(
                width: usesChars
                    ? _charsForLine(i, randoms[i]) * charWidth
                    : null,
                height: barHeight,
                radius: barRadius,
                animation: scope?.animation,
                baseColor: scope?.baseColor ?? const Color(0xFFECEEF1),
                highlightColor:
                    scope?.highlightColor ?? const Color(0xFFF7F8FA),
                widthFactor: usesChars ? null : _factorForLine(i, randoms[i]),
              ),
            ),
          ),
      ],
    );
  }
}

/// Measures and caches the average glyph width per text style and scaler.
class _CharWidth {
  const _CharWidth._();

  static const String _sample = 'The quick brown fox jumps over the lazy dog';
  static final Map<(TextStyle, TextScaler), double> _cache = {};

  static double of(TextStyle style, TextScaler textScaler) {
    return _cache.putIfAbsent((style, textScaler), () {
      final painter = TextPainter(
        text: TextSpan(text: _sample, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      final width = painter.width / _sample.length;
      painter.dispose();
      return width;
    });
  }
}
