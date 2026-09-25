import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/buttons/button.dart';
import '../../store/dialogs/base_dialog.dart';
import '../../store/dialogs/confirm_dialog.dart';
import '../../store/dialogs/dialog_icon.dart';

/// "Default" use case for [BaseDialog], triggered via [showBaseDialog].
Widget baseDialogUseCase(BuildContext context) {
  return Center(
    child: PrimaryButton(
      label: 'Show base dialog',
      fullWidth: false,
      onPressed: () => showBaseDialog<void>(
        context: context,
        useRootNavigator: false,
        children: const [
          DialogIcon(icon: Icons.rocket_launch_outlined),
          SizedBox(height: 16),
          Text(
            'Custom dialog content',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'BaseDialog only supplies the shell; children are arbitrary widgets.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// "Inline" use case: renders [BaseDialog] statically on a scrim so it can
/// be designed without tapping through the trigger button.
Widget baseDialogInlineUseCase(BuildContext context) {
  return ColoredBox(
    color: Colors.black.withValues(alpha: 0.5),
    child: const Center(
      child: BaseDialog(
        children: [
          DialogIcon(icon: Icons.rocket_launch_outlined),
          SizedBox(height: 16),
          Text(
            'Custom dialog content',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'BaseDialog only supplies the shell; children are arbitrary widgets.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// "Default" use case for [showConfirmDialog], with a knob for the cancel
/// label since passing `null` removes the cancel button entirely.
Widget confirmDialogUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Delete item?');
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'This action cannot be undone.',
  );
  final danger = context.knobs.boolean(label: 'Danger', initialValue: true);
  final showCancel = context.knobs.boolean(label: 'Show cancel', initialValue: true);
  return Center(
    child: PrimaryButton(
      label: 'Show confirm dialog',
      fullWidth: false,
      danger: danger,
      onPressed: () => showConfirmDialog(
        context: context,
        title: title,
        message: message,
        danger: danger,
        cancelLabel: showCancel ? 'Cancel' : null,
        useRootNavigator: false,
      ),
    ),
  );
}

/// "Inline" use case: renders the same content [showConfirmDialog] would
/// show, statically on a scrim, for design review without tapping through.
Widget confirmDialogInlineUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Delete item?');
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'This action cannot be undone.',
  );
  final danger = context.knobs.boolean(label: 'Danger', initialValue: true);
  final showCancel = context.knobs.boolean(label: 'Show cancel', initialValue: true);
  return ColoredBox(
    color: Colors.black.withValues(alpha: 0.5),
    child: Center(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          if (!showCancel)
            PrimaryButton(label: 'Confirm', onPressed: () {}, danger: danger)
          else
            Row(
              children: [
                Expanded(child: OutlineButton(label: 'Cancel', onPressed: () {})),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(label: 'Confirm', onPressed: () {}, danger: danger),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

/// "Default" use case for [DialogIcon].
Widget dialogIconUseCase(BuildContext context) {
  final size = context.knobs.double.input(label: 'Size', initialValue: 72);
  final backgroundColor = context.knobs.color(
    label: 'Background',
    initialValue: const Color(0xFF156EFC),
  );
  return Center(
    child: DialogIcon(
      icon: Icons.favorite_outline,
      size: size,
      backgroundColor: backgroundColor,
    ),
  );
}

/// The dialogs component group, mirroring `dialogs/`.
final dialogComponents = [
  WidgetbookComponent(
    name: 'BaseDialog',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: baseDialogUseCase),
      WidgetbookUseCase(name: 'Inline', builder: baseDialogInlineUseCase),
    ],
  ),
  WidgetbookComponent(
    name: 'showConfirmDialog',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: confirmDialogUseCase),
      WidgetbookUseCase(name: 'Inline', builder: confirmDialogInlineUseCase),
    ],
  ),
  WidgetbookComponent(
    name: 'DialogIcon',
    useCases: [WidgetbookUseCase(name: 'Default', builder: dialogIconUseCase)],
  ),
];
