---
name: button
symbols: [ButtonSize, PrimaryButton, SecondaryButton, OutlineButton, PlainTextButton]
use_when: Any tappable action — primary CTA, secondary action, outlined action, or an inline text link.
avoid_when: Icon-only toolbar actions (use IconButton); navigation rows (use layout/list_tile).
related: [dialogs/confirm_dialog, feedback/empty_state]
---
# Buttons

Four brand button variants sharing one internal shell, all built on core Flutter button
widgets (`ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`).

## When to use

- **`PrimaryButton`** — the one call-to-action on a screen (submit, save, continue).
- **`SecondaryButton`** — a lower-emphasis action next to a primary one (tinted fill, brand
  text), e.g. "Skip" beside "Continue".
- **`OutlineButton`** — a bordered, transparent-background action, e.g. a secondary action
  on a colored surface where a filled button would compete with the primary one.
- **`PlainTextButton`** — a no-background inline action or link, e.g. "Forgot password?".
- All four accept `danger: true` to switch the brand color to `dangerColor` for destructive
  actions, and `loading: true` to swap the label for a spinner and disable taps.

## When not to use

- Icon-only actions (an app bar action, a small toolbar button) — use core Flutter's
  `IconButton`, not a labeled button with an empty label.
- A tappable row with leading icon/title/trailing content (settings row, list navigation) —
  use `layout/list_tile`'s `InfoListTile` instead.
- A confirm/cancel pair inside a dialog — `dialogs/confirm_dialog`'s `showConfirmDialog`
  already lays out `OutlineButton`/`PrimaryButton` for you; don't hand-roll the pair.

## Usage

```dart
import 'package:your_app/ui/components/buttons/button.dart';

PrimaryButton(
  label: 'Continue',
  onPressed: () {},
  size: ButtonSize.lg,
);

SecondaryButton(
  label: 'Skip for now',
  onPressed: () {},
  fullWidth: false,
);

OutlineButton(
  label: 'Cancel',
  onPressed: () {},
  danger: true,
);

PlainTextButton(
  label: 'Forgot password?',
  onPressed: () {},
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Button text. |
| `onPressed` | required | `null` renders the button disabled. |
| `loading` | `false` | Replaces the label with a spinner and disables taps. |
| `size` | `ButtonSize.md` | `sm` (40px), `md` (48px), `lg` (56px) height. |
| `danger` | `false` (not on `SecondaryButton`) | Swaps `brandColor` for `dangerColor`. |
| `fullWidth` | `true` (`false` on `PlainTextButton`) | Stretches to the parent's width. |
| `icon` / `trailingIcon` | `null` | Leading/trailing glyph (trailing only on `PrimaryButton`). |
| `brandColor` | `Color(0xFF156EFC)` | Base brand color for the variant. |
| `dangerColor` | `Color(0xFFEF4444)` | Color used when `danger` is true. |
| `secondaryBackgroundColor` | `Color(0xFFE9F0FF)` | `SecondaryButton`'s tinted fill. |
| `onColor` | `Colors.white` | Foreground on `PrimaryButton`'s filled background. |
| `borderRadius` | `BorderRadius.circular(12)` | Corner radius of the button shape. |

## Bind to your tokens

Wire `brandColor`, `dangerColor`, `secondaryBackgroundColor`, `onColor` to your palette
tokens, and `borderRadius` to your radius scale:

```dart
PrimaryButton(
  label: 'Continue',
  onPressed: onContinue,
  brandColor: AppColors.brand,
  dangerColor: AppColors.danger,
  onColor: AppColors.onBrand,
  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
);
```
