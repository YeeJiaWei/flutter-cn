import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/inputs/phone_field.dart';

/// "Default" use case for [PhoneField].
Widget phoneFieldUseCase(BuildContext context) {
  final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Phone number');
  final dialCode = context.knobs.string(label: 'Dial code', initialValue: '+60');
  final errorText = context.knobs.stringOrNull(label: 'Error text', defaultToNull: true);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  return Center(
    child: SizedBox(
      width: 320,
      child: PhoneField(
        label: label,
        errorText: errorText,
        enabled: enabled,
        country: CountryCode(iso: 'MY', dialCode: dialCode),
      ),
    ),
  );
}

/// The phone-field component group, mirroring `inputs/phone_field.dart`.
final phoneFieldComponents = [
  WidgetbookComponent(
    name: 'PhoneField',
    useCases: [WidgetbookUseCase(name: 'Default', builder: phoneFieldUseCase)],
  ),
];
