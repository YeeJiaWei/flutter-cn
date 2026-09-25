---
name: dob_picker
symbols: [showDobPicker]
use_when: Collecting a full date of birth (day, month, year) via a three-column wheel bottom sheet.
avoid_when: Only a year is needed (use pickers/year_picker); only a height/other single numeric value is needed (use pickers/height_picker).
related: [pickers/year_picker, pickers/height_picker, buttons/button]
---
# Dob Picker

Bottom-sheet day/month/year wheel picker with column headers.

## When to use

`showDobPicker` opens a **bottom sheet** with month/day/year `CupertinoPicker` wheels and
a "Done" button, and returns a `Future<DateTime?>` — the picked date, or `null` if the
sheet was dismissed without confirming. Use it for full date-of-birth entry.

Constrains the year wheel to `[min.year, max.year]` and clamps the resolved date into
`[min, max]`.

## When not to use

- **Only a year is needed** (e.g. graduation year) — use `pickers/year_picker.dart`'s
  `showYearPicker`, a single-column picker.
- **Only a numeric measurement is needed** (e.g. height) — use
  `pickers/height_picker.dart`'s `showHeightPicker`.

## Usage

```dart
import 'package:your_app/ui/components/pickers/dob_picker.dart';

final dob = await showDobPicker(
  context: context,
  title: 'Date of birth',
  initial: DateTime(2000, 1, 1),
  min: DateTime(1920, 1, 1),
  max: DateTime.now(),
);
if (dob != null) {
  // use dob
}
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `context` | required | Used to open the bottom sheet. |
| `title` | required | Sheet heading text. |
| `initial` | required | Starting date for all three wheels. |
| `min` | required | Earliest selectable date; bounds the year wheel and clamps the result. |
| `max` | required | Latest selectable date; bounds the year wheel and clamps the result. |

## Bind to your tokens

The sheet background reads `Theme.of(context).colorScheme.surface` and the "Done" button
is `buttons/button.dart`'s `PrimaryButton`, so bind tokens through your `ColorScheme` and
`PrimaryButton`'s own params respectively — `showDobPicker` itself takes no color/token
parameters.
