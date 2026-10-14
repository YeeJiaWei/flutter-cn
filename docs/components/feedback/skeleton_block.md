---
name: skeleton_block
symbols: [SkeletonBlock, RenderSkeletonBlock]
use_when: Building a custom skeleton shape on the shared shimmer without rebuilding per frame.
avoid_when: Any common shape (use feedback/skeleton or feedback/text_skeleton).
related: [feedback/skeleton, feedback/text_skeleton, feedback/shimmer]
---
# SkeletonBlock

Low-level leaf widget and render object behind `Skeleton` and `TextSkeleton`. It paints one
rounded block whose shimmer band is positioned in screen space, repainting through
`markNeedsPaint` when `animation` ticks. Intrinsics are implemented, so `IntrinsicHeight`
and `IntrinsicWidth` work.

## When to use

- A bespoke placeholder shape that should sweep in phase with the other skeletons.

## When not to use

- Ordinary lines, avatars, cards or text — use `Skeleton`/`TextSkeleton`.

## Usage

```dart
final scope = context.dependOnInheritedWidgetOfExactType<ShimmerScope>()!;
SkeletonBlock(
  width: null,
  widthFactor: 0.6,
  height: 20,
  radius: 8,
  animation: scope.animation,
  baseColor: scope.baseColor,
  highlightColor: scope.highlightColor,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `width` | required (`null`/infinite fills) | Fixed width. |
| `widthFactor` | `null` | Share of incoming max width; overrides `width`. |
| `height` | required | Block height. |
| `radius` | required | Corner radius, capped at half the shortest side. |
| `animation` | required | Repaint trigger; `null` paints the solid base colour. |
| `baseColor` / `highlightColor` | required | Resting and band colours. |

## Bind to your tokens

Pass colours from `ShimmerScope` (set on `Shimmer`) and radii from your tokens.
