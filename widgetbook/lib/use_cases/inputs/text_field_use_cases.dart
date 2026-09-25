import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/inputs/text_field.dart';

/// "Default" use case for [FormTextField].
Widget formTextFieldUseCase(BuildContext context) {
  final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Email');
  final hint = context.knobs.stringOrNull(label: 'Hint', initialValue: 'you@example.com');
  final errorText = context.knobs.stringOrNull(label: 'Error text', defaultToNull: true);
  final helperText = context.knobs.stringOrNull(label: 'Helper text', defaultToNull: true);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final dense = context.knobs.boolean(label: 'Dense');
  return Center(
    child: SizedBox(
      width: 320,
      child: FormTextField(
        label: label,
        hint: hint,
        errorText: errorText,
        helperText: helperText,
        enabled: enabled,
        dense: dense,
        prefixIcon: const Icon(Icons.mail_outline),
      ),
    ),
  );
}

/// The text-field component group, mirroring `inputs/text_field.dart`.
final textFieldComponents = [
  WidgetbookComponent(
    name: 'FormTextField',
    useCases: [WidgetbookUseCase(name: 'Default', builder: formTextFieldUseCase)],
  ),
];
