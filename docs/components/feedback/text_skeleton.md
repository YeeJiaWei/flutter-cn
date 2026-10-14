---
name: text_skeleton
symbols: [TextSkeleton]
use_when: Placeholder bars that match a text style's height and a plausible, stable text width.
avoid_when: Non-text shapes such as avatars and cards (use feedback/skeleton).
related: [feedback/skeleton, feedback/shimmer, feedback/skeleton_block]
---
# TextSkeleton

Text-shaped shimmer bars. Bar height follows the font size, line height follows the style,
and random widths are seeded once so they stay stable across rebuilds. Reached through
`Skeleton.text(...)` or directly.

## When to use

- Loading titles, names, paragraphs where the real text length is unknown.
- Width by share of space (`minFactor`/`maxFactor`/`widthFactor`) or by character count
  (`chars`, or `minChars`/`maxChars`), measured once per `(TextStyle, TextScaler)` and cached.

## When not to use

- Avatars, images, cards — use `Skeleton`.

## Usage

```dart
Shimmer(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Skeleton.text(style: TextStyle(fontSize: 18), chars: 12),
      Skeleton.text(lines: 3, maxChars: 40),
    ],
  ),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `style` | ambient `DefaultTextStyle` | Sizes bar and line height. |
| `lines` | `1` | Number of bars. |
| `minFactor` / `maxFactor` | `0.5` / `0.9` | Random width range as a share of available width. |
| `widthFactor` | `null` | Fixed share of available width. |
| `chars` | `null` | Fixed width in characters (last line of a paragraph 60%). |
| `minChars` / `maxChars` | `null` | Random character count range per line. |
| `barRadius` | `8` | Radius cap (never more than half the bar height). |
| `seed` | from enclosing `Shimmer` | Pins the random widths. |

`chars` excludes `minChars`/`maxChars`; `widthFactor` excludes all char params. Outside a
`Shimmer` it wraps itself in one.

## Bind to your tokens

Set colours on `Shimmer`; pass your text style via `style` and your radius via `barRadius`.
