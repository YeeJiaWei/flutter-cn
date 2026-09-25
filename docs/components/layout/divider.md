---
name: divider
symbols: [FadingDivider]
use_when: A hairline divider that should fade out toward both ends instead of running edge-to-edge.
avoid_when: A plain full-width divider with no fade (use core Flutter's Divider).
related: []
---
# Divider

Hairline divider that fades toward both ends. Named `FadingDivider` to avoid clashing
with Flutter's own `Divider`.

## When to use

`FadingDivider` renders a single hairline whose color fades to transparent at the left and
right edges via a `LinearGradient`. Use it between sections where a hard edge-to-edge line
looks too heavy (e.g. separating an "OR" label, or a subtle break inside a card).

## When not to use

- **A standard full-bleed divider with a flat color** — use core Flutter's `Divider` (or
  `VerticalDivider`); it's cheaper and is what most list separators want.

## Usage

```dart
import 'package:your_app/ui/components/layout/divider.dart';

const FadingDivider()
```

```dart
// Inset from both edges, thicker.
const FadingDivider(
  indent: 24,
  endIndent: 24,
  thickness: 2,
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `indent` | `0` | Empty space before the line starts (left). |
| `endIndent` | `0` | Empty space after the line ends (right). |
| `height` | `1` | Total height of the widget's box. |
| `thickness` | `1` | Thickness of the line itself. |
| `color` | `Color(0xFFCCCCCC)` | Line color; faded to transparent at both ends. |

## Bind to your tokens

Bind `color` to your border/divider token.

```dart
const FadingDivider(color: AppColors.divider)
```
