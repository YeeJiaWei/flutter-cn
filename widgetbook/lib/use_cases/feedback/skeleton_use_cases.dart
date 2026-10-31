import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/shimmer.dart';
import '../../store/feedback/skeleton.dart';

Shimmer _shimmer(BuildContext context, Widget child) {
  final seed = context.knobs.int.input(label: 'Seed', initialValue: 1);
  final baseColor = context.knobs.color(
    label: 'Base color',
    initialValue: const Color(0xFFECEEF1),
  );
  final highlightColor = context.knobs.color(
    label: 'Highlight color',
    initialValue: const Color(0xFFF7F8FA),
  );
  return Shimmer(
    seed: seed,
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: child,
  );
}

/// Shows [child] shimmering on a card over a tinted backdrop, so the bars read
/// against a surface the way they would in an app instead of the bare canvas.
Widget _preview(BuildContext context, Widget child) {
  final backdropColor = context.knobs.color(
    label: 'Backdrop color',
    initialValue: const Color(0xFFE4E7EC),
  );
  final cardColor = context.knobs.color(
    label: 'Card color',
    initialValue: const Color(0xFFFFFFFF),
  );
  return ColoredBox(
    color: backdropColor,
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD5DAE1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: _shimmer(context, child),
      ),
    ),
  );
}

/// "Default" use case for the base [Skeleton] constructor.
Widget skeletonUseCase(BuildContext context) {
  final width = context.knobs.double.input(label: 'Width', initialValue: 200);
  final height = context.knobs.double.input(label: 'Height', initialValue: 16);
  final radius = context.knobs.double.input(label: 'Radius', initialValue: 8);
  return _preview(
    context,
    Skeleton(width: width, height: height, radius: radius),
  );
}

/// [Skeleton.line] factory use case: full-width text-line placeholder.
Widget skeletonLineUseCase(BuildContext context) {
  return _preview(context, const SizedBox(width: 260, child: Skeleton.line()));
}

/// [Skeleton.avatar] factory use case: circular avatar placeholder.
Widget skeletonAvatarUseCase(BuildContext context) {
  final size = context.knobs.double.input(label: 'Size', initialValue: 44);
  return _preview(context, Skeleton.avatar(size: size));
}

/// [Skeleton.card] factory use case: block-shaped card placeholder.
Widget skeletonCardUseCase(BuildContext context) {
  final height = context.knobs.double.input(label: 'Height', initialValue: 120);
  return _preview(
    context,
    SizedBox(width: 280, child: Skeleton.card(height: height)),
  );
}

/// [Skeleton.text] use case: text-shaped bars driven by lines and character knobs.
Widget skeletonTextUseCase(BuildContext context) {
  final lines = context.knobs.int.slider(
    label: 'Lines',
    initialValue: 3,
    min: 1,
    max: 8,
  );
  final fontSize = context.knobs.double.slider(
    label: 'Font size',
    initialValue: 16,
    min: 10,
    max: 32,
  );
  final useChars = context.knobs.boolean(
    label: 'Use characters',
    initialValue: true,
  );
  final chars = context.knobs.int.input(
    label: 'Chars (0 = random range)',
    initialValue: 0,
  );
  final minChars = context.knobs.int.input(label: 'Min chars', initialValue: 8);
  final maxChars = context.knobs.int.input(
    label: 'Max chars',
    initialValue: 30,
  );
  final text = !useChars
      ? Skeleton.text(
          style: TextStyle(fontSize: fontSize),
          lines: lines,
        )
      : chars > 0
      ? Skeleton.text(
          style: TextStyle(fontSize: fontSize),
          lines: lines,
          chars: chars,
        )
      : Skeleton.text(
          style: TextStyle(fontSize: fontSize),
          lines: lines,
          minChars: minChars.clamp(1, maxChars),
          maxChars: maxChars,
        );
  return _preview(context, SizedBox(width: 320, child: text));
}

/// The skeleton component group, mirroring `feedback/skeleton.dart`'s named
/// constructors as separate use cases (they can't be expressed via a knob).
final skeletonComponents = [
  WidgetbookComponent(
    name: 'Skeleton',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: skeletonUseCase),
      WidgetbookUseCase(name: 'line', builder: skeletonLineUseCase),
      WidgetbookUseCase(name: 'avatar', builder: skeletonAvatarUseCase),
      WidgetbookUseCase(name: 'card', builder: skeletonCardUseCase),
      WidgetbookUseCase(name: 'text', builder: skeletonTextUseCase),
    ],
  ),
];
