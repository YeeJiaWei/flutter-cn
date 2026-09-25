import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/media/svg_icon.dart';

/// "Default" use case for [SvgIcon], backed by a small bundled SVG asset.
Widget svgIconUseCase(BuildContext context) {
  final size = context.knobs.double.input(label: 'Size', initialValue: 32);
  final color = context.knobs.colorOrNull(
    label: 'Color',
    initialValue: const Color(0xFF156EFC),
  );
  return Center(
    child: SvgIcon('assets/icons/star.svg', size: size, color: color),
  );
}

/// The svg-icon component group, mirroring `media/svg_icon.dart`.
final svgIconComponents = [
  WidgetbookComponent(
    name: 'SvgIcon',
    useCases: [WidgetbookUseCase(name: 'Default', builder: svgIconUseCase)],
  ),
];
