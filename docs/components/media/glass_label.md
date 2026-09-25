---
name: glass_label
symbols: [GlassLabel]
use_when: A short frosted-glass pill label overlaid on top of imagery (e.g. a "Profile Photo" marker).
avoid_when: A label that doesn't sit over imagery, or where blur is unwanted/expensive (use feedback/badge or feedback/status_pill on a plain background).
related: [feedback/badge, feedback/status_pill]
---
# Glass Label

Frosted-glass pill label to overlay on top of imagery (e.g. a "Profile Photo" marker).

## When to use

`GlassLabel` clips a `BackdropFilter`-blurred, translucent-white pill around a text
`label`. Use it to overlay a short marker directly on top of a photo or other imagery,
where a flat-colored badge would look out of place.

## When not to use

- **The label isn't over imagery** — use `feedback/badge.dart`'s `CountBadge` or
  `feedback/status_pill.dart`'s `StatusPill` on a plain surface; `BackdropFilter` blur is
  wasted (and costs a render pass) with nothing behind it to blur.

## Usage

```dart
import 'package:your_app/ui/components/media/glass_label.dart';

Stack(
  children: [
    Image.network(photoUrl, fit: BoxFit.cover),
    const Positioned(
      left: 8,
      bottom: 8,
      child: GlassLabel(label: 'Profile Photo'),
    ),
  ],
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Text shown inside the pill. |
| `blurSigma` | `8` | Backdrop blur radius. |
| `radius` | `8` | Corner radius of the pill (and its clip). |

## Bind to your tokens

Bind `radius` to your pill/chip radius token; the translucent white fill and border are
intentionally fixed (they're what makes it read as "glass" over arbitrary imagery), so
they're not meant to be tokenized.

```dart
GlassLabel(label: 'Profile Photo', radius: AppRadius.pill)
```
