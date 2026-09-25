---
name: height_picker
symbols: [showHeightPicker]
use_when: Collecting a single numeric value (height in centimetres) via a single-column wheel bottom sheet.
avoid_when: A full date is needed (use pickers/dob_picker); a year is needed (use pickers/year_picker, which lists newest-first and has no min/max defaults).
related: [pickers/dob_picker, pickers/year_picker, buttons/button]
---
# Height Picker

Bottom-sheet single-column wheel picker for a bounded integer value, in centimetres by
default.

## When to use

`showHeightPicker` opens a **bottom sheet** with a single `CupertinoPicker` wheel of
integer values from `min` to `max` and a "Done" button, returning a `Future<int?>` — the
picked value in centimetres, or `null` if dismissed. Use it for any single bounded integer
value picked by wheel; the label says "centimetres" but the mechanism is generic.

## When not to use

- **A full date of birth** — use `pickers/dob_picker.dart`'s `showDobPicker`.
- **A year, listed newest-first** — use `pickers/year_picker.dart`'s `showYearPicker`.

## Usage

```dart
import 'package:your_app/ui/components/pickers/height_picker.dart';

final heightCm = await showHeightPicker(
  context: context,
  title: 'Height (cm)',
  initial: 170,
);
if (heightCm != null) {
  // use heightCm
}
```

```dart
// Custom bounds.
final heightCm = await showHeightPicker(
  context: context,
  title: 'Height (cm)',
  initial: 170,
  min: 100,
  max: 250,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `context` | required | Used to open the bottom sheet. |
| `title` | required | Sheet heading text. |
| `initial` | required | Starting wheel value; clamped into `[min, max]`. |
| `min` | `140` | Lowest selectable value. |
| `max` | `220` | Highest selectable value. |

## Bind to your tokens

The sheet background reads `Theme.of(context).colorScheme.surface` and the "Done" button
is `buttons/button.dart`'s `PrimaryButton`; bind tokens through your `ColorScheme` and
`PrimaryButton` respectively — `showHeightPicker` itself takes no color/token parameters.
