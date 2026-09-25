import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/page_header.dart';

/// "Default" use case for [PageHeader].
Widget pageHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Home');
  final showActions = context.knobs.boolean(label: 'Show actions', initialValue: true);
  return PageHeader(
    title: title,
    actions: showActions
        ? [IconButton(icon: const Icon(Icons.search), onPressed: () {})]
        : null,
  );
}

/// The page-header component group, mirroring `layout/page_header.dart`.
final pageHeaderComponents = [
  WidgetbookComponent(
    name: 'PageHeader',
    useCases: [WidgetbookUseCase(name: 'Default', builder: pageHeaderUseCase)],
  ),
];
