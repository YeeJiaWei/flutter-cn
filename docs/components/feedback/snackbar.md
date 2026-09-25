---
name: snackbar
symbols: [Toast]
use_when: A transient, top-anchored notification for success/error/info feedback that doesn't block interaction.
avoid_when: The user must make a decision before continuing (use dialogs/confirm_dialog or dialogs/base_dialog).
related: [dialogs/confirm_dialog]
---
# Toast

Top-anchored, overlay-based toast notification with slide/fade in-out and
swipe-to-dismiss. Call the static `Toast.success` / `Toast.error` / `Toast.info` methods
with a `BuildContext`; only one toast is shown at a time (a new call removes the active
one).

## When to use

- Transient feedback after an action that doesn't need the user to decide anything — a save
  confirmation (`success`), a failed request (`error`), or a neutral notice (`info`).
- Pass `useRootOverlay: false` to anchor the toast within the nearest `Overlay` instead of
  the app's root one (e.g. inside a nested navigator or a Widgetbook frame).

## When not to use

- The user needs to confirm or choose before continuing — use `dialogs/confirm_dialog`'s
  `showConfirmDialog` or a custom dialog on `dialogs/base_dialog` instead; a toast
  auto-dismisses and isn't awaited.

## Usage

```dart
import 'package:your_app/ui/components/feedback/snackbar.dart';

Toast.success(context, 'Profile updated');
Toast.error(context, 'Something went wrong');
Toast.info(context, 'Syncing your changes…');
```

## Key parameters

`Toast.success`/`.error`/`.info` share the same signature:

| Parameter | Default | Purpose |
|---|---|---|
| `context` | required | `BuildContext` used to find the `Overlay`. |
| `message` | required | Toast body text. |
| `useRootOverlay` | `true` | Pass `false` to anchor within the nearest `Overlay` instead of the app's root one. |

`Toast.defaultDuration` is a static `Duration(seconds: 5)` constant — how long a toast
stays on screen before auto-dismissing; it isn't a per-call parameter.

## Bind to your tokens

The toast's per-variant color (`success`/`error`/`info`) and its surface/text colors are
hardcoded inside `_show`/`_Toast`, not exposed as constructor parameters — there's nothing
to bind here without editing the copied file directly. If your tokens differ from the
literal defaults (`Color(0xFF10B981)` success, `Color(0xFFEF4444)` error, `Color(0xFF3B82F6)`
info), edit those literals after copying.
