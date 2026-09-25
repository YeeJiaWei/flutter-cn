import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/page_dots.dart';

/// "Default" use case for [PageDots].
Widget pageDotsUseCase(BuildContext context) {
  final count = context.knobs.int.slider(label: 'Count', initialValue: 5, min: 1, max: 10);
  final index = context.knobs.int.slider(
    label: 'Index',
    initialValue: 1,
    min: 0,
    max: count - 1,
  );
  final activeColor = context.knobs.color(label: 'Active color', initialValue: Colors.black);
  return ColoredBox(
    color: const Color(0xFF0B1220),
    child: Center(
      child: PageDots(
        count: count,
        index: index.clamp(0, count - 1),
        activeColor: activeColor,
      ),
    ),
  );
}

/// The page-dots component group, mirroring `layout/page_dots.dart`.
final pageDotsComponents = [
  WidgetbookComponent(
    name: 'PageDots',
    useCases: [WidgetbookUseCase(name: 'Default', builder: pageDotsUseCase)],
  ),
];
