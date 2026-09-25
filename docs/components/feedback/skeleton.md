---
name: skeleton
symbols: [Skeleton]
use_when: A shimmer placeholder matching the eventual content's shape while data loads.
avoid_when: A centered, content-agnostic loading state (use feedback/loading).
related: [feedback/loading]
---
# Skeleton

Lightweight animated shimmer placeholder used while data is loading, with named
constructors for common shapes.

## When to use

- The eventual content's shape is known ahead of time — a text line, an avatar circle, a
  card block — so the placeholder can match it and avoid layout jump when real content
  arrives.
- Use the named constructors for the common cases: `Skeleton.line` (full-width, 12px tall),
  `Skeleton.avatar` (circle, default 44px), `Skeleton.card` (full-width block, default
  120px tall). Use the base `Skeleton()` constructor for anything else via `width`/
  `height`/`radius`.

## When not to use

- The content's shape is unknown or the loading state is a full-panel blocking wait (e.g.
  an initial screen fetch with no layout to preserve) — use `feedback/loading`'s
  `LoadingIndicator` instead.

## Usage

```dart
import 'package:your_app/ui/components/feedback/skeleton.dart';

const Skeleton.line();
const Skeleton.avatar();
const Skeleton.card();

const Skeleton(width: 120, height: 20, radius: 6);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `width` | `null` (base); `double.infinity` (`.line`/`.card`); `size` (`.avatar`) | Placeholder width. |
| `height` | `16` (base); `12` (`.line`); `size` (`.avatar`); `120` (`.card`) | Placeholder height. |
| `radius` | `8` (base/`.line`); `999` (`.avatar`); `16` (`.card`) | Corner radius. |
| `baseColor` | `Color(0xFFF3F5F9)` | Shimmer gradient's base tone. |
| `highlightColor` | `Color(0xFFEEF1F6)` | Shimmer gradient's moving highlight tone. |

`Skeleton.avatar` and `Skeleton.card` also take a constructor-only `size`/`height` argument
(not a stored field) to set their dimension.

## Bind to your tokens

Wire `baseColor` and `highlightColor` to your neutral/surface tokens:

```dart
Skeleton.line(
  baseColor: AppColors.surfaceMuted,
  highlightColor: AppColors.surfaceMutedHighlight,
);
```
