import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/cards/card.dart';

/// "Default" use case for [SurfaceCard].
Widget surfaceCardUseCase(BuildContext context) {
  final elevated = context.knobs.boolean(label: 'Elevated', initialValue: true);
  final tappable = context.knobs.boolean(label: 'Tappable');
  final padding = context.knobs.double.input(label: 'Padding', initialValue: 18);
  return Center(
    child: SizedBox(
      width: 320,
      child: SurfaceCard(
        padding: EdgeInsets.all(padding),
        elevated: elevated,
        onTap: tappable ? () {} : null,
        child: const Text('Surface card content goes here.'),
      ),
    ),
  );
}

/// The cards component group, mirroring `cards/card.dart`.
final cardComponents = [
  WidgetbookComponent(
    name: 'SurfaceCard',
    useCases: [WidgetbookUseCase(name: 'Default', builder: surfaceCardUseCase)],
  ),
];
