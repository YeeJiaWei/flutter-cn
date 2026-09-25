import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/header_title.dart';

/// "Default" use case for [HeaderTitle].
Widget headerTitleUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Text', initialValue: 'Page title');
  final color = context.knobs.color(label: 'Color', initialValue: const Color(0xFF0B1220));
  return Center(child: HeaderTitle(text, color: color));
}

/// The header-title component group, mirroring `layout/header_title.dart`.
final headerTitleComponents = [
  WidgetbookComponent(
    name: 'HeaderTitle',
    useCases: [WidgetbookUseCase(name: 'Default', builder: headerTitleUseCase)],
  ),
];
