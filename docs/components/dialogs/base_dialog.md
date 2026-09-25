---
name: base_dialog
symbols: [BaseDialog, showBaseDialog]
use_when: A custom modal that needs its own icon/title/button layout — build it as children on this shell.
avoid_when: A simple title/message/confirm-cancel dialog (use dialogs/confirm_dialog directly instead of rebuilding it on this shell).
related: [dialogs/dialog_icon, dialogs/confirm_dialog]
---
# BaseDialog

Generic modal shell: a rounded, padded `Dialog` wrapping a stretched, top-to-bottom
`Column` of `children`. Carries no icon, title or button layout of its own — those belong
in a project-specific widget built on top of this shell.

## When to use

- Any custom dialog with its own arrangement of icon, title, body and buttons — compose it
  as `children` on `BaseDialog` (e.g. pair with `dialogs/dialog_icon`'s `DialogIcon` for an
  illustrated dialog).
- Use the `BaseDialog` widget directly when you already have a `BuildContext` inside a
  `showDialog` call of your own (e.g. custom transitions); use `showBaseDialog<T>()` for the
  common case of showing it and awaiting the popped result.

## When not to use

- A standard title + message + confirm/cancel dialog — use `dialogs/confirm_dialog`'s
  `showConfirmDialog()` directly; it already lays that out with `AlertDialog` and doesn't
  need `BaseDialog` underneath it.

## Usage

```dart
import 'package:your_app/ui/components/dialogs/base_dialog.dart';

final result = await showBaseDialog<bool>(
  context: context,
  children: [
    const Text('Delete this item?'),
    const SizedBox(height: 16),
    ElevatedButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('Delete'),
    ),
  ],
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `children` | required | Content stacked in the dialog's `Column`. |
| `backgroundColor` | `Colors.white` | Dialog surface color. |
| `borderRadius` | `BorderRadius.circular(20)` | Corner radius. |
| `borderSide` | `null` | Optional border stroke on the dialog shape. |
| `insetPadding` | `EdgeInsets.symmetric(horizontal: 24, vertical: 24)` | Space between the dialog and the screen edges. |
| `contentPadding` | `EdgeInsets.all(24)` | Inner padding around `children`. |
| `barrierDismissible` (show-function only) | `true` | Whether tapping outside dismisses it. |
| `useRootNavigator` (show-function only) | `true` | Pass `false` to show within the nearest `Navigator` instead of the app's root one. |

`showBaseDialog<T>()` returns a `Future<T?>` that resolves with whatever value the caller
passes to `Navigator.of(ctx).pop(value)`, or `null` if dismissed without popping a value.

## Bind to your tokens

Wire `backgroundColor` and `borderRadius` to your surface and radius tokens; `insetPadding`
and `contentPadding` to your spacing scale:

```dart
showBaseDialog<void>(
  context: context,
  backgroundColor: AppColors.surface,
  borderRadius: BorderRadius.circular(AppRadius.lg),
  contentPadding: EdgeInsets.all(AppSpacing.lg),
  children: children,
);
```
