import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Shares one shimmer clock, colours and a seeded child-index counter with every skeleton below.
class ShimmerScope extends InheritedWidget {
  /// Provides [animation] (null means reduced motion), [seed] and the colours to descendants.
  const ShimmerScope({
    required this.animation,
    required this.seed,
    required this.takeChildIndex,
    required this.baseColor,
    required this.highlightColor,
    required super.child,
    super.key,
  });

  /// Repaint trigger shared by every block; null means reduced motion (solid base colour).
  final Animation<double>? animation;

  /// Seed every text skeleton below derives its random widths from.
  final int seed;

  /// Hands out the next build-order index; each text skeleton calls it once.
  final int Function() takeChildIndex;

  /// Resting colour of every block.
  final Color baseColor;

  /// Colour at the centre of the moving band.
  final Color highlightColor;

  @override
  bool updateShouldNotify(ShimmerScope oldWidget) =>
      animation != oldWidget.animation ||
      seed != oldWidget.seed ||
      baseColor != oldWidget.baseColor ||
      highlightColor != oldWidget.highlightColor;
}

/// Owns the shared shimmer clock and provides it, with the colours, to every skeleton below.
class Shimmer extends StatefulWidget {
  /// Wraps [child]; set [baseColor]/[highlightColor] to restyle every skeleton inside.
  const Shimmer({
    required this.child,
    this.baseColor = const Color(0xFFECEEF1),
    this.highlightColor = const Color(0xFFF7F8FA),
    this.seed,
    super.key,
  });

  /// Total length of one cycle: the sweep plus the rest.
  static const Duration period = Duration(milliseconds: 1800);

  /// Part of [period] spent sweeping; the remainder is the rest.
  static const Duration sweep = Duration(milliseconds: 1300);

  /// Band width as a fraction of the screen width.
  static const double bandWidthFactor = 0.6;

  static final Stopwatch _sharedClock = Stopwatch()..start();

  /// Subtree that contains the skeletons.
  final Widget child;

  /// Resting colour of every skeleton below.
  final Color baseColor;

  /// Colour at the centre of the moving band.
  final Color highlightColor;

  /// Pins the random widths of text skeletons below; random per mount when null.
  final int? seed;

  /// Whether [context] sits inside a [Shimmer].
  static bool isActive(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ShimmerScope>() != null;

  /// Linear 0..1 sweep progress shared by every skeleton; stays 1 during the rest.
  static double get phase {
    final cycleMicros =
        _sharedClock.elapsedMicroseconds % period.inMicroseconds;
    return (cycleMicros / sweep.inMicroseconds).clamp(0.0, 1.0);
  }

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  late final int _seed;
  int _nextChildIndex = 0;

  int _takeChildIndex() => _nextChildIndex++;

  @override
  void initState() {
    super.initState();
    _seed = widget.seed ?? math.Random().nextInt(0x7fffffff);
    _ticker = AnimationController(vsync: this, duration: Shimmer.period)
      ..repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return ShimmerScope(
      animation: reducedMotion ? null : _ticker,
      seed: _seed,
      takeChildIndex: _takeChildIndex,
      baseColor: widget.baseColor,
      highlightColor: widget.highlightColor,
      child: widget.child,
    );
  }
}
