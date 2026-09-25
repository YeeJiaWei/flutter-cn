---
name: card
symbols: [SurfaceCard]
use_when: A rounded, padded surface grouping related content, optionally tappable.
avoid_when: A tappable row with leading/trailing slots and fixed height (use layout/list_tile); a plain divider between sections (use layout/divider).
related: [layout/list_tile]
---
# Card

A neutral surface wrapper with rounded corners, either a soft elevation shadow or a thin
outline, and an optional tap ripple. Named `SurfaceCard` rather than `Card` to avoid
clashing with Flutter's own `Card` widget.

## When to use

- Any block of content that needs visual grouping — a list item, a summary panel, a
  settings section — with `elevated: true` (default) for a floating look or `elevated:
  false` for a bordered, flat look on a colored background.
- Pass `onTap` to make the whole card tappable (ripple on `InkWell`); omit it for a static
  container.

## When not to use

- A fixed-height row with a leading icon, title, subtitle and trailing widget — use
  `layout/list_tile`'s `InfoListTile`, which already lays that structure out.
- Just needing rounded corners and padding with no shadow/border/tap semantics — a plain
  `Container` with `BoxDecoration` is simpler and avoids the unused `Material`/`InkWell`
  tree.

## Usage

```dart
import 'package:your_app/ui/components/cards/card.dart';

SurfaceCard(
  child: const Text('Elevated content'),
);

SurfaceCard(
  elevated: false,
  onTap: () {},
  child: const Text('Bordered, tappable content'),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `child` | required | Content inside the padded surface. |
| `padding` | `EdgeInsets.all(18)` | Inner padding around `child`. |
| `margin` | `null` | Outer spacing around the card. |
| `onTap` | `null` | `null` renders a static card; non-null adds an `InkWell` ripple. |
| `elevated` | `true` | `true` draws `shadow`; `false` draws a `outlineColor` border instead. |
| `backgroundColor` | `Theme.of(context).colorScheme.surface` | Surface fill color. |
| `radius` | `BorderRadius.circular(16)` | Corner radius. |
| `outlineColor` | `Color(0xFFA9A9A9)` | Border color when `elevated: false`. |
| `shadow` | one soft `BoxShadow` | Shadow list used when `elevated: true`. |

## Bind to your tokens

Wire `backgroundColor`, `radius`, `outlineColor` and `shadow` to your surface, radius and
elevation tokens:

```dart
SurfaceCard(
  backgroundColor: AppColors.surface,
  radius: BorderRadius.circular(AppRadius.lg),
  outlineColor: AppColors.outline,
  shadow: AppShadows.card,
  child: content,
);
```
