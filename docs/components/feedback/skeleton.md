---
name: skeleton
symbols: [Skeleton]
use_when: A shimmer placeholder matching the eventual content's shape (block, line, avatar, card) while data loads.
avoid_when: A centered, content-agnostic loading state (use feedback/loading).
related: [feedback/shimmer, feedback/text_skeleton, feedback/skeleton_block, feedback/loading]
---
# Skeleton

Shimmer placeholder used while data is loading, with named constructors for common shapes.
Colours and timing come from the enclosing `Shimmer`; a `Skeleton` outside any `Shimmer`
wraps itself in one.

## When to use

- The eventual content's shape is known ahead of time — a line, an avatar circle, a card
  block — so the placeholder can match it and avoid layout jump.
- `Skeleton.line` (full-width, 12 tall), `Skeleton.avatar` (circle, default 44),
  `Skeleton.card` (full-width, default 120 tall, radius 16), `Skeleton()` for anything else
  via `width`/`height`/`radius`, and `Skeleton.text(...)` for text-shaped bars (see
  `feedback/text_skeleton`).
- Wrap a whole loading screen in one `Shimmer` so every block sweeps in phase.

## When not to use

- The content's shape is unknown, or the wait is a full-panel blocking one — use
  `feedback/loading`'s `LoadingIndicator`.

## Usage

```dart
import 'package:your_app/ui/components/feedback/shimmer.dart';
import 'package:your_app/ui/components/feedback/skeleton.dart';

const Shimmer(
  child: Column(
    children: [
      Skeleton.avatar(),
      Skeleton.line(),
      Skeleton(width: 120, height: 20, radius: 6),
      Skeleton.card(),
    ],
  ),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `width` | `null` (fills available width) | Block width. |
| `height` | `16` (base); `12` (`.line`); `size` (`.avatar`); `120` (`.card`) | Block height. |
| `radius` | `8` (base/`.line`); `999` (`.avatar`); `16` (`.card`) | Corner radius. |

`Skeleton.avatar` and `Skeleton.card` also take a constructor-only `size`/`height` argument.
`Skeleton.text` forwards `style`, `lines`, `minFactor`, `maxFactor`, `chars`, `minChars`,
`maxChars`, `widthFactor`, `seed` to `TextSkeleton`.

Breaking change from the old `Skeleton`: the per-widget `baseColor` and `highlightColor`
params are gone. Colours now live on `Shimmer` and apply to every block below it.

## Bind to your tokens

Set the colours once on the `Shimmer`, and the radii in the constructors' defaults:

```dart
Shimmer(
  baseColor: AppColors.surfaceMuted,
  highlightColor: AppColors.surfaceMutedHighlight,
  child: screen,
);
```
