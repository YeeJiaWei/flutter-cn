import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';
import '../../store/pickers/height_picker.dart';

/// "Default" use case for [showHeightPicker], triggered via a button.
Widget heightPickerUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Height (cm)');
  final initial = context.knobs.int.slider(label: 'Initial', initialValue: 170, min: 140, max: 220);
  return Center(
    child: PrimaryButton(
      label: 'Show height picker',
      fullWidth: false,
      onPressed: () => showHeightPicker(context: context, title: title, initial: initial),
    ),
  );
}

/// The height-picker component group, mirroring `pickers/height_picker.dart`.
final heightPickerComponents = [
  WidgetbookComponent(
    name: 'showHeightPicker',
    useCases: [WidgetbookUseCase(name: 'Default', builder: heightPickerUseCase)],
  ),
];
