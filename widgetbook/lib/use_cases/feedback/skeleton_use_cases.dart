import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/skeleton.dart';

/// "Default" use case for the base [Skeleton] constructor.
Widget skeletonUseCase(BuildContext context) {
  final width = context.knobs.double.input(label: 'Width', initialValue: 200);
  final height = context.knobs.double.input(label: 'Height', initialValue: 16);
  final radius = context.knobs.double.input(label: 'Radius', initialValue: 8);
  return Center(child: Skeleton(width: width, height: height, radius: radius));
}

/// [Skeleton.line] factory use case: full-width text-line placeholder.
Widget skeletonLineUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(width: 260, child: Skeleton.line()),
  );
}

/// [Skeleton.avatar] factory use case: circular avatar placeholder.
Widget skeletonAvatarUseCase(BuildContext context) {
  return const Center(child: Skeleton.avatar());
}

/// [Skeleton.card] factory use case: block-shaped card placeholder.
Widget skeletonCardUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(width: 280, child: Skeleton.card()),
  );
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
    ],
  ),
];
