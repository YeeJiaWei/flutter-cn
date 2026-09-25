import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/divider.dart';

/// "Default" use case for [FadingDivider].
Widget fadingDividerUseCase(BuildContext context) {
  final thickness = context.knobs.double.input(label: 'Thickness', initialValue: 1);
  final color = context.knobs.color(label: 'Color', initialValue: const Color(0xFFCCCCCC));
  return Center(
    child: SizedBox(
      width: 280,
      child: FadingDivider(thickness: thickness, color: color),
    ),
  );
}

/// The divider component group, mirroring `layout/divider.dart`.
final dividerComponents = [
  WidgetbookComponent(
    name: 'FadingDivider',
    useCases: [WidgetbookUseCase(name: 'Default', builder: fadingDividerUseCase)],
  ),
];
