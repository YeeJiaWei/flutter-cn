import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/loading.dart';

/// "Default" use case for [LoadingIndicator].
Widget loadingIndicatorUseCase(BuildContext context) {
  final message = context.knobs.stringOrNull(label: 'Message', initialValue: 'Loading...');
  final size = context.knobs.double.input(label: 'Size', initialValue: 28);
  final color = context.knobs.color(label: 'Color', initialValue: const Color(0xFF156EFC));
  return Center(
    child: LoadingIndicator(message: message, size: size, color: color),
  );
}

/// The loading component group, mirroring `feedback/loading.dart`.
final loadingComponents = [
  WidgetbookComponent(
    name: 'LoadingIndicator',
    useCases: [WidgetbookUseCase(name: 'Default', builder: loadingIndicatorUseCase)],
  ),
];
