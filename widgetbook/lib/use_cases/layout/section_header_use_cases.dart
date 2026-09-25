import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/section_header.dart';

/// "Default" use case for [SectionHeader].
Widget sectionHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Recent orders');
  final showTrailing = context.knobs.boolean(label: 'Show trailing link', initialValue: true);
  return SectionHeader(
    title: title,
    trailingLabel: showTrailing ? 'See all' : null,
    onTrailingTap: showTrailing ? () {} : null,
  );
}

/// The section-header component group, mirroring `layout/section_header.dart`.
final sectionHeaderComponents = [
  WidgetbookComponent(
    name: 'SectionHeader',
    useCases: [WidgetbookUseCase(name: 'Default', builder: sectionHeaderUseCase)],
  ),
];
