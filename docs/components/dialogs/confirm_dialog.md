---
name: confirm_dialog
symbols: [showConfirmDialog]
use_when: A standard confirm/cancel or single-dismiss alert with a title and optional message.
avoid_when: A dialog needing a custom illustration or layout (use dialogs/base_dialog); a lightweight non-blocking notice (use feedback/snackbar).
related: [dialogs/base_dialog, buttons/button]
---
# ConfirmDialog

Shows a styled confirm dialog (`AlertDialog` under the hood) with a title, optional
message, and confirm/cancel buttons built from `buttons/button`'s `OutlineButton` and
`PrimaryButton`.

## When to use

- Any "are you sure?" confirmation before a destructive or consequential action — pass
  `danger: true` to tint the confirm button with `dangerColor` (e.g. before a delete).
- A single-action notice with nothing to cancel out of — pass `cancelLabel: null` to render
  just one full-width confirm button (e.g. "Got it").

## When not to use

- The dialog needs an icon illustration, custom body layout, or more than a title/message —
  build it on `dialogs/base_dialog`'s `BaseDialog` instead, optionally with
  `dialogs/dialog_icon`'s `DialogIcon`.
- A transient, non-blocking notice that doesn't need a decision — use `feedback/snackbar`'s
  `Toast` instead of a modal dialog.

## Usage

```dart
import 'package:your_app/ui/components/dialogs/confirm_dialog.dart';

final confirmed = await showConfirmDialog(
  context: context,
  title: 'Delete this item?',
  message: 'This cannot be undone.',
  confirmLabel: 'Delete',
  danger: true,
);
if (confirmed == true) {
  // proceed
}

// Single-dismiss notice, no cancel:
await showConfirmDialog(
  context: context,
  title: 'Profile updated',
  cancelLabel: null,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | required | Dialog title text. |
| `message` | `null` | Optional body text below the title. |
| `confirmLabel` | `'Confirm'` | Confirm button label. |
| `cancelLabel` | `'Cancel'` | Cancel button label; pass `null` for a single-button dismiss dialog. |
| `danger` | `false` | Tints the confirm button with `buttons/button`'s `dangerColor`. |
| `barrierDismissible` | `true` | Whether tapping outside dismisses it. |
| `useRootNavigator` | `true` | Pass `false` to show within the nearest `Navigator` instead of the app's root one. |
| `messageColor` | `Color(0xFF5A616D)` | Text color of `message`. |

`showConfirmDialog()` returns a `Future<bool?>`: `true` on confirm, `false` on cancel, and
`null` if dismissed via the barrier without either button.

## Bind to your tokens

The dialog's own knob is `messageColor`; the confirm/cancel buttons pull their colors from
`buttons/button`'s defaults, so binding brand/danger colors there covers this dialog too:

```dart
showConfirmDialog(
  context: context,
  title: 'Delete this item?',
  danger: true,
  messageColor: AppColors.textSecondary,
);
```
