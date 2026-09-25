---
name: network_image
symbols: [NetImage]
use_when: Loading a network image with a placeholder/error builder, without a caching package dependency.
avoid_when: A circular avatar with an initials fallback (use media/avatar); disk/memory caching across sessions is required (this holds no cache — use CachedNetworkImage instead).
related: [media/avatar]
---
# Network Image

`Image.network`-backed drop-in for a `CachedNetworkImage`-shaped API
(placeholder/error builders). Named `NetImage` to avoid clashing with Flutter's own
`NetworkImage` (dart:ui) image provider.

## When to use

`NetImage` is a drop-in, `Image.network`-backed replacement for the common subset of the
`CachedNetworkImage` API (`placeholder`/`errorWidget` builders). Use it where a
cache-manager-backed loader stalls on its placeholder for otherwise-valid images on some
platforms, or simply to avoid the extra package when caching isn't required.

## When not to use

- **A circular avatar with initials fallback** — use `media/avatar.dart`'s `Avatar`, which
  already composes `NetImage` for the image case.
- **Persistent disk/memory image caching across app sessions is actually needed** —
  `NetImage` has no cache; reach for `cached_network_image`'s `CachedNetworkImage` instead.

## Usage

```dart
import 'package:your_app/ui/components/media/network_image.dart';

NetImage(
  imageUrl: product.imageUrl,
  width: 96,
  height: 96,
  fit: BoxFit.cover,
  placeholder: (context, url) => const ColoredBox(color: Color(0xFFF3F5F9)),
  errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `imageUrl` | required | The network image URL. |
| `width` / `height` | `null` / `null` | Fixed dimensions passed to `Image.network`. |
| `fit` | `null` | `BoxFit` for the image. |
| `placeholder` | `null` | Builder shown while loading; falls back to `SizedBox.shrink()`. |
| `errorWidget` | `null` | Builder shown on load error; falls back to `SizedBox.shrink()`. |

## Bind to your tokens

No literal colors live in `NetImage` itself — bind tokens on the `placeholder`/`errorWidget`
builders you pass in (e.g. a placeholder `ColoredBox` using your surface-muted color).

```dart
NetImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => ColoredBox(color: AppColors.surfaceMuted),
)
```
