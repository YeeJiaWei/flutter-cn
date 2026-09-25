import 'package:flutter/material.dart';

import '../buttons/button.dart';

/// Show a styled confirm dialog. Resolves to `true` on confirm, `false` on
/// cancel. Pass `cancelLabel: null` for a single dismiss action — a plain
/// "Got it" notice with nothing to cancel out of. Pass `useRootNavigator:
/// false` to show it within the nearest [Navigator] instead of the app's
/// root one.
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String? cancelLabel = 'Cancel',
  bool danger = false,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  Color messageColor = const Color(0xFF5A616D),
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (ctx) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      actionsPadding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
      title: Text(title),
      content: message == null
          ? null
          : Text(
              message,
              style:
                  Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: messageColor),
            ),
      actions: [
        if (cancelLabel == null)
          PrimaryButton(
            label: confirmLabel,
            onPressed: () => Navigator.of(ctx).pop(true),
            danger: danger,
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: confirmLabel,
                  onPressed: () => Navigator.of(ctx).pop(true),
                  danger: danger,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
