import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/media/glass_label.dart';

/// "Default" use case for [GlassLabel], overlaid on a photo so the frosted
/// blur effect is visible against real imagery.
Widget glassLabelUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Profile photo');
  final blurSigma = context.knobs.double.input(label: 'Blur sigma', initialValue: 8);
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.network(
            'https://picsum.photos/seed/glass/320/220',
            width: 320,
            height: 220,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: GlassLabel(label: label, blurSigma: blurSigma),
          ),
        ],
      ),
    ),
  );
}

/// The glass-label component group, mirroring `media/glass_label.dart`.
final glassLabelComponents = [
  WidgetbookComponent(
    name: 'GlassLabel',
    useCases: [WidgetbookUseCase(name: 'Default', builder: glassLabelUseCase)],
  ),
];
