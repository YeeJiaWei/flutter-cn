---
name: page_dots
symbols: [PageDots]
use_when: Page indicator dots for a carousel/`PageView`, with the active dot animating wider.
avoid_when: A numeric wizard progress bar (use layout/progress_stepper).
related: [layout/progress_stepper]
---
# Page Dots

Row of animated pill dots indicating the current page of a carousel.

## When to use

`PageDots` renders a row of `count` pill dots, animating the selected `index`'s dot to a
wider pill. Use it under a `PageView`/image carousel to show the current page.

## When not to use

- **A step-by-step wizard progress indicator** — use
  `layout/progress_stepper.dart`'s `ProgressStepper`, which shows segment fill and an
  optional "Step X of Y" label instead of dots.

## Usage

```dart
import 'package:your_app/ui/components/layout/page_dots.dart';

PageDots(count: 4, index: currentPage)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `count` | required | Total number of pages/dots. |
| `index` | required | Currently selected page (0-based). |
| `activeColor` | `Colors.white` | Color of the selected (wide) dot. |
| `inactiveColor` | `Colors.white54` | Color of unselected dots. |
| `dotSize` | `6` | Diameter/height of an inactive dot. |
| `activeWidth` | `18` | Width of the selected dot. |

## Bind to your tokens

The white/white54 defaults assume the dots overlay imagery; bind `activeColor` and
`inactiveColor` to your on-image or brand tokens if used over a plain background.

```dart
PageDots(
  count: 4,
  index: currentPage,
  activeColor: AppColors.brand,
  inactiveColor: AppColors.brandMuted,
)
```
