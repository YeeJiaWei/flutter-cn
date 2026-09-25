import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/badge.dart';

/// "Default" use case for [CountBadge].
Widget countBadgeUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '3');
  final color = context.knobs.color(label: 'Color', initialValue: const Color(0xFFEF4444));
  final withIcon = context.knobs.boolean(label: 'With icon');
  return Center(
    child: CountBadge(
      label: label,
      color: color,
      icon: withIcon ? Icons.notifications : null,
    ),
  );
}

/// The badge component group, mirroring `feedback/badge.dart`.
final badgeComponents = [
  WidgetbookComponent(
    name: 'CountBadge',
    useCases: [WidgetbookUseCase(name: 'Default', builder: countBadgeUseCase)],
  ),
];
