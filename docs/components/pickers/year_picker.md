---
name: year_picker
symbols: [showYearPicker]
use_when: Collecting a single year via a single-column wheel bottom sheet, listed newest-first.
avoid_when: A full date is needed (use pickers/dob_picker); a bounded non-year integer is needed (use pickers/height_picker, which lists oldest/smallest-first and has default bounds).
related: [pickers/dob_picker, pickers/height_picker, buttons/button]
---
# Year Picker

Bottom-sheet single-column year wheel picker, newest year first, styled to match
`pickers/dob_picker`.

## When to use

`showYearPicker` opens a **bottom sheet** with a single `CupertinoPicker` wheel of years
from `max` down to `min` (newest first, matching `pickers/dob_picker.dart`'s styling) and a
"Done" button, returning a `Future<int?>` — the picked year, or `null` if dismissed. Use it
for a standalone year field (e.g. "year joined", graduation year).

## When not to use

- **A full date of birth** — use `pickers/dob_picker.dart`'s `showDobPicker`.
- **A non-year bounded value, or oldest-first ordering** — use
  `pickers/height_picker.dart`'s `showHeightPicker`.

## Usage

```dart
import 'package:your_app/ui/components/pickers/year_picker.dart';

final year = await showYearPicker(
  context: context,
  title: 'Graduation year',
  initial: 2020,
  min: 1980,
  max: DateTime.now().year,
);
if (year != null) {
  // use year
}
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `context` | required | Used to open the bottom sheet. |
| `title` | required | Sheet heading text. |
| `initial` | required | Starting wheel value; clamped into `[min, max]`. |
| `min` | required | Lowest selectable year. |
| `max` | required | Highest selectable year (appears first in the wheel). |

## Bind to your tokens

The sheet background reads `Theme.of(context).colorScheme.surface` and the "Done" button
is `buttons/button.dart`'s `PrimaryButton`; bind tokens through your `ColorScheme` and
`PrimaryButton` respectively — `showYearPicker` itself takes no color/token parameters.
