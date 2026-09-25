import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/empty_state.dart';

/// "Default" use case for [EmptyState].
Widget emptyStateUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Nothing here yet');
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Items you add will show up here.',
  );
  final showAction = context.knobs.boolean(label: 'Show action', initialValue: true);
  return Center(
    child: EmptyState(
      title: title,
      subtitle: subtitle,
      actionLabel: showAction ? 'Add item' : null,
      onAction: showAction ? () {} : null,
    ),
  );
}

/// The empty-state component group, mirroring `feedback/empty_state.dart`.
final emptyStateComponents = [
  WidgetbookComponent(
    name: 'EmptyState',
    useCases: [WidgetbookUseCase(name: 'Default', builder: emptyStateUseCase)],
  ),
];
