import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/inputs/password_field.dart';

/// "Default" use case for [PasswordField].
Widget passwordFieldUseCase(BuildContext context) {
  final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Password');
  final errorText = context.knobs.stringOrNull(label: 'Error text', defaultToNull: true);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Center(
    child: SizedBox(
      width: 320,
      child: PasswordField(label: label, errorText: errorText, enabled: enabled),
    ),
  );
}

/// The password-field component group, mirroring `inputs/password_field.dart`.
final passwordFieldComponents = [
  WidgetbookComponent(
    name: 'PasswordField',
    useCases: [WidgetbookUseCase(name: 'Default', builder: passwordFieldUseCase)],
  ),
];
