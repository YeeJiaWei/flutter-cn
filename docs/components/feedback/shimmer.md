---
name: shimmer
symbols: [Shimmer, ShimmerScope]
use_when: Wrapping a loading screen so every Skeleton below shares one in-phase shimmer clock and one colour pair.
avoid_when: Animating arbitrary widgets with a shimmer effect — it only drives Skeleton, TextSkeleton and SkeletonBlock.
related: [feedback/skeleton, feedback/text_skeleton, feedback/skeleton_block]
---
# Shimmer

Container that owns one repeating animation and exposes it, the colours and a text-skeleton
seed to every skeleton below through `ShimmerScope`. Blocks repaint in place (no widget
rebuild per frame) and a static shared clock keeps blocks of different `Shimmer`s in phase.

## When to use

- Around any screen or section that shows `Skeleton`/`TextSkeleton` placeholders.
- To restyle all skeletons at once via `baseColor`/`highlightColor`.
- To pin text-skeleton widths (screenshots, tests) with `seed`.

## When not to use

- A single stray `Skeleton` — it wraps itself in a `Shimmer` when none is found.

## Usage

```dart
Shimmer(
  seed: 1,
  child: Column(children: [Skeleton.text(lines: 3), Skeleton.card()]),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `child` | required | Subtree containing skeletons. |
| `baseColor` | `Color(0xFFECEEF1)` | Resting colour. |
| `highlightColor` | `Color(0xFFF7F8FA)` | Colour at the band centre. |
| `seed` | random per mount | Pins text-skeleton random widths. |

Constants: `Shimmer.period` 1800ms (1300ms `sweep` + 500ms rest), `Shimmer.bandWidthFactor`
0.6 of the screen width, band tilted `Alignment(-1,-0.25)` to `(1,0.25)`. With reduced
motion (`MediaQuery.disableAnimations`) blocks paint the solid base colour.
`Shimmer.isActive(context)` tells whether a scope exists; `ShimmerScope` is the
InheritedWidget carrying `animation`, `seed`, `baseColor`, `highlightColor`.

## Bind to your tokens

Pass your neutral surface tokens as `baseColor` and `highlightColor`.
