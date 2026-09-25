---
name: dialog_icon
symbols: [DialogIcon]
use_when: The illustration slot at the top of a custom dialog built on dialogs/base_dialog — a glyph or arbitrary widget on a brand-colored circle.
avoid_when: The dialog doesn't need an illustration slot at all (dialogs/confirm_dialog has none, by design).
related: [dialogs/base_dialog, dialogs/confirm_dialog]
---
# DialogIcon

Brand-colored circle icon slot for a dialog's illustration. Pass `icon` for the common
glyph-on-circle case, or `child` for anything else (an image, an SVG, ...). Exactly one of
the two is required — passing both or neither triggers an assertion.

## When to use

- As the first child of `dialogs/base_dialog`'s `BaseDialog` (or `showBaseDialog`), to give
  a custom dialog a consistent illustration slot above its title/body.
- Pass `icon` for a Material icon glyph; pass `child` when the illustration is a custom
  widget (e.g. an `SvgIcon` from `media/svg_icon`, or an `Image`).

## When not to use

- `dialogs/confirm_dialog`'s `showConfirmDialog` is a plain `AlertDialog` with no
  illustration slot by design — don't try to inject `DialogIcon` into it; build a custom
  dialog on `BaseDialog` instead if an icon is needed.

## Usage

```dart
import 'package:your_app/ui/components/dialogs/dialog_icon.dart';
import 'package:your_app/ui/components/dialogs/base_dialog.dart';

showBaseDialog<void>(
  context: context,
  children: [
    const DialogIcon(icon: Icons.warning_amber_rounded),
    const SizedBox(height: 16),
    const Text('Are you sure?'),
  ],
);

// With a custom child instead of a glyph:
DialogIcon(child: Image.asset('assets/celebrate.png'));
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `icon` | `null` | Glyph rendered centered on the circle. Exactly one of `icon`/`child` is required. |
| `child` | `null` | Arbitrary widget rendered centered on the circle instead of `icon`. |
| `size` | `72` | Circle diameter. |
| `iconSize` | `36` | Glyph size when `icon` is used. |
| `backgroundColor` | `Color(0xFF156EFC)` | Circle fill color. |
| `foregroundColor` | `Colors.white` | Glyph color when `icon` is used. |

## Bind to your tokens

Wire `backgroundColor` and `foregroundColor` to your brand/on-brand color tokens:

```dart
DialogIcon(
  icon: Icons.warning_amber_rounded,
  backgroundColor: AppColors.brand,
  foregroundColor: AppColors.onBrand,
);
```
