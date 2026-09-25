---
name: progress_stepper
symbols: [ProgressStepper]
use_when: A multi-step wizard progress bar shown as connected fill segments, with an optional "Step X of Y" label.
avoid_when: Carousel/page indicator dots (use layout/page_dots); the progress bar is meant to live inside an AppBar (layout/app_bar's TopBar already renders one from currentStep/totalSteps).
related: [layout/page_dots, layout/app_bar]
---
# Progress Stepper

Wizard progress bar rendered as connected fill segments, with an optional
"Step X of Y" label.

## When to use

`ProgressStepper` renders `totalSteps` equal-width segments, filling the first
`currentStep` of them, with an optional "Step X of Y" label above. Use it as a standalone
progress indicator for a multi-step form or wizard body (not inside an `AppBar`).

## When not to use

- **Inside an `AppBar`** — `layout/app_bar.dart`'s `TopBar` already renders an equivalent
  bar under the title when given `currentStep`/`totalSteps`; don't duplicate it.
- **A carousel/page indicator** — use `layout/page_dots.dart`'s `PageDots`.

## Usage

```dart
import 'package:your_app/ui/components/layout/progress_stepper.dart';

ProgressStepper(currentStep: 2, totalSteps: 4)
```

```dart
// Without the "Step X of Y" label.
ProgressStepper(currentStep: 2, totalSteps: 4, showLabel: false)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `currentStep` | required | Number of segments filled (clamped to `[0, totalSteps]`). |
| `totalSteps` | required | Total segment count; must be `> 0` (asserted). |
| `showLabel` | `true` | Shows the "Step X of Y" text above the bar. |
| `activeColor` | `Color(0xFF156EFC)` | Fill color of completed segments. |
| `inactiveColor` | `Color(0xFFF3F5F9)` | Fill color of remaining segments. |

## Bind to your tokens

Bind `activeColor` to your brand token and `inactiveColor` to a neutral surface token; the
label text style comes from `Theme.of(context).textTheme.labelMedium`.

```dart
ProgressStepper(
  currentStep: 2,
  totalSteps: 4,
  activeColor: AppColors.brand,
  inactiveColor: AppColors.surfaceMuted,
)
```
