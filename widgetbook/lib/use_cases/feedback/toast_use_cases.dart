import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';
import '../../store/feedback/snackbar.dart';

/// "Default" use case for [Toast]: buttons trigger each variant since it is
/// an overlay-based show function, not a returned widget.
Widget toastUseCase(BuildContext context) {
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Changes saved successfully.',
  );
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          label: 'Show success toast',
          fullWidth: false,
          onPressed: () => Toast.success(context, message, useRootOverlay: false),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Show error toast',
          fullWidth: false,
          danger: true,
          onPressed: () => Toast.error(context, message, useRootOverlay: false),
        ),
        const SizedBox(height: 12),
        OutlineButton(
          label: 'Show info toast',
          fullWidth: false,
          onPressed: () => Toast.info(context, message, useRootOverlay: false),
        ),
      ],
    ),
  );
}

/// The toast component group, mirroring `feedback/snackbar.dart`.
final toastComponents = [
  WidgetbookComponent(
    name: 'Toast',
    useCases: [WidgetbookUseCase(name: 'Default', builder: toastUseCase)],
  ),
];
