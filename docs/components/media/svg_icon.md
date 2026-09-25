---
name: svg_icon
symbols: [SvgIcon]
use_when: Rendering a bundled SVG asset as a sized, optionally tinted icon.
avoid_when: A Material icon glyph is available (use core Flutter's Icon with IconData — no extra package needed).
related: []
---
# Svg Icon

Thin, sized, tintable wrapper over `flutter_svg`'s `SvgPicture.asset`.

## When to use

`SvgIcon` wraps `flutter_svg`'s `SvgPicture.asset` to render an SVG asset at a fixed
square `size`, optionally tinted with a `ColorFilter`. Use it for custom/brand icons that
aren't available as a Material `IconData` glyph.

**Requires the `flutter_svg` pub package.** `fcn add` installs it automatically; by hand,
add it to the copying project's `pubspec.yaml`.

## When not to use

- **A standard Material glyph exists** — use core Flutter's `Icon(IconData)`; it avoids
  the `flutter_svg` dependency and SVG parsing cost entirely.

## Usage

```dart
import 'package:your_app/ui/components/media/svg_icon.dart';

SvgIcon('assets/icons/brand_mark.svg', size: 20, color: Colors.black)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `assetPath` (positional) | required | Path to the bundled SVG asset. |
| `size` | `24` | Width and height (square). |
| `color` | `null` | Tint applied via `ColorFilter.mode(color, BlendMode.srcIn)`; untinted when `null`. |

## Bind to your tokens

Bind `color` to your icon token when the SVG should follow theme/state color rather than
its own baked-in fill.

```dart
SvgIcon('assets/icons/brand_mark.svg', color: AppColors.iconDefault)
```
