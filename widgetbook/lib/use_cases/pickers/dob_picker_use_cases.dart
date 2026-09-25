import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';
import '../../store/pickers/dob_picker.dart';

/// "Default" use case for [showDobPicker], triggered via a button since it
/// is a bottom-sheet show function.
Widget dobPickerUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Date of birth');
  return Center(
    child: PrimaryButton(
      label: 'Show date of birth picker',
      fullWidth: false,
      onPressed: () => showDobPicker(
        context: context,
        title: title,
        initial: DateTime(2000, 1, 1),
        min: DateTime(1920, 1, 1),
        max: DateTime.now(),
      ),
    ),
  );
}

/// The DOB-picker component group, mirroring `pickers/dob_picker.dart`.
final dobPickerComponents = [
  WidgetbookComponent(
    name: 'showDobPicker',
    useCases: [WidgetbookUseCase(name: 'Default', builder: dobPickerUseCase)],
  ),
];
