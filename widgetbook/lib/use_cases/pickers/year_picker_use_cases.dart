import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';
import '../../store/pickers/year_picker.dart';

/// "Default" use case for [showYearPicker], triggered via a button.
Widget yearPickerUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Year');
  final now = DateTime.now().year;
  return Center(
    child: PrimaryButton(
      label: 'Show year picker',
      fullWidth: false,
      onPressed: () => showYearPicker(
        context: context,
        title: title,
        initial: now,
        min: now - 100,
        max: now,
      ),
    ),
  );
}

/// The year-picker component group, mirroring `pickers/year_picker.dart`.
final yearPickerComponents = [
  WidgetbookComponent(
    name: 'showYearPicker',
    useCases: [WidgetbookUseCase(name: 'Default', builder: yearPickerUseCase)],
  ),
];
