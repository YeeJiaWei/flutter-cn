import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/status_pill.dart';

/// "Default" use case for [StatusPill].
Widget statusPillUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Active');
  final color = context.knobs.color(label: 'Color', initialValue: const Color(0xFF10B981));
  final variant = context.knobs.object.dropdown<StatusPillVariant>(
    label: 'Variant',
    options: StatusPillVariant.values,
    labelBuilder: (v) => v.name,
  );
  return Center(
    child: StatusPill(label: label, color: color, variant: variant),
  );
}

/// The status-pill component group, mirroring `feedback/status_pill.dart`.
final statusPillComponents = [
  WidgetbookComponent(
    name: 'StatusPill',
    useCases: [WidgetbookUseCase(name: 'Default', builder: statusPillUseCase)],
  ),
];
