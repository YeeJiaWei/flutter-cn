---
name: rating_stars
symbols: [RatingStars]
use_when: Displaying or collecting a 5-star rating, read-only or interactive with half-star precision.
avoid_when: A non-star rating scale (numeric, thumbs, slider) — build a project-specific widget instead.
related: []
---
# RatingStars

5-star rating row with half-star precision, read-only by default. Pass `onChanged` to make
it interactive.

## When to use

- Displaying an existing rating (`onChanged` omitted → read-only, no gesture handling).
- Collecting a rating from the user (`onChanged` provided) — tapping the left/right half of
  a star sets the value to `i + 0.5` or `i + 1.0`.

## When not to use

- The scale isn't a 5-star rating (e.g. thumbs up/down, a 1–10 numeric scale, a slider) —
  this widget's rendering and hit-testing are specific to 5 stars with half-star precision.

## Usage

```dart
import 'package:your_app/ui/components/feedback/rating_stars.dart';

const RatingStars(rating: 3.5); // read-only

RatingStars(
  rating: rating,
  onChanged: (value) => setState(() => rating = value),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `rating` | required | Current value, 0.0–5.0 in half-star steps. |
| `onChanged` | `null` | `null` renders read-only; non-null enables tap-to-rate. |
| `size` | `24` | Star icon size. |
| `color` | `Color(0xFFFFB531)` | Star color. |

## Bind to your tokens

Wire `color` to your rating/accent token:

```dart
RatingStars(
  rating: rating,
  onChanged: onChanged,
  color: AppColors.rating,
);
```
