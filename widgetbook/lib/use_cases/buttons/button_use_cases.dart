import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';

/// Knobs shared by every button variant's default use case.
class _ButtonKnobs {
  _ButtonKnobs(BuildContext context)
      : label = context.knobs.string(label: 'Label', initialValue: 'Continue'),
        size = context.knobs.object.dropdown<ButtonSize>(
          label: 'Size',
          options: ButtonSize.values,
          labelBuilder: (v) => v.name,
        ),
        loading = context.knobs.boolean(label: 'Loading'),
        disabled = context.knobs.boolean(label: 'Disabled'),
        fullWidth = context.knobs.boolean(label: 'Full width', initialValue: true),
        brandColor = context.knobs.color(
          label: 'Brand color',
          initialValue: const Color(0xFF156EFC),
        );

  final String label;
  final ButtonSize size;
  final bool loading;
  final bool disabled;
  final bool fullWidth;
  final Color brandColor;
}

/// "Default" use case for [PrimaryButton], with a danger toggle.
Widget primaryButtonUseCase(BuildContext context) {
  final k = _ButtonKnobs(context);
  final danger = context.knobs.boolean(label: 'Danger');
  return Center(
    child: PrimaryButton(
      label: k.label,
      onPressed: k.disabled ? null : () {},
      loading: k.loading,
      fullWidth: k.fullWidth,
      size: k.size,
      danger: danger,
      brandColor: k.brandColor,
    ),
  );
}

/// "Default" use case for [SecondaryButton].
Widget secondaryButtonUseCase(BuildContext context) {
  final k = _ButtonKnobs(context);
  return Center(
    child: SecondaryButton(
      label: k.label,
      onPressed: k.disabled ? null : () {},
      loading: k.loading,
      fullWidth: k.fullWidth,
      size: k.size,
      brandColor: k.brandColor,
    ),
  );
}

/// "Default" use case for [OutlineButton], with a danger toggle.
Widget outlineButtonUseCase(BuildContext context) {
  final k = _ButtonKnobs(context);
  final danger = context.knobs.boolean(label: 'Danger');
  return Center(
    child: OutlineButton(
      label: k.label,
      onPressed: k.disabled ? null : () {},
      loading: k.loading,
      fullWidth: k.fullWidth,
      size: k.size,
      danger: danger,
      brandColor: k.brandColor,
    ),
  );
}

/// "Default" use case for [PlainTextButton], with a danger toggle.
Widget plainTextButtonUseCase(BuildContext context) {
  final k = _ButtonKnobs(context);
  final danger = context.knobs.boolean(label: 'Danger');
  return Center(
    child: PlainTextButton(
      label: k.label,
      onPressed: k.disabled ? null : () {},
      loading: k.loading,
      fullWidth: false,
      size: k.size,
      danger: danger,
      brandColor: k.brandColor,
    ),
  );
}

/// The buttons component group, mirroring `buttons/button.dart`.
final buttonComponents = [
  WidgetbookComponent(
    name: 'PrimaryButton',
    useCases: [WidgetbookUseCase(name: 'Default', builder: primaryButtonUseCase)],
  ),
  WidgetbookComponent(
    name: 'SecondaryButton',
    useCases: [WidgetbookUseCase(name: 'Default', builder: secondaryButtonUseCase)],
  ),
  WidgetbookComponent(
    name: 'OutlineButton',
    useCases: [WidgetbookUseCase(name: 'Default', builder: outlineButtonUseCase)],
  ),
  WidgetbookComponent(
    name: 'PlainTextButton',
    useCases: [WidgetbookUseCase(name: 'Default', builder: plainTextButtonUseCase)],
  ),
];
