---
name: avatar
symbols: [AvatarSize, Avatar]
use_when: A circular user/entity avatar backed by a network image, falling back to initials.
avoid_when: A generic (non-circular, non-initials) thumbnail (use media/network_image directly).
related: [media/network_image]
---
# Avatar

Circular avatar with network image and initials fallback.

## When to use

`Avatar` renders a circular avatar. When `imageUrl` is non-empty it loads the image (via
`media/network_image.dart`'s `NetImage`) with a placeholder while loading, falling back to
initials generated from `name` on load error; when `imageUrl` is `null`/empty it shows the
initials directly. Pick a `size` from the `AvatarSize` enum (`xs`–`xxl`).

## When not to use

- **A non-circular image tile, or one with no initials fallback** — use
  `media/network_image.dart`'s `NetImage` directly.

## Usage

```dart
import 'package:your_app/ui/components/media/avatar.dart';

Avatar(imageUrl: user.photoUrl, name: user.fullName, size: AvatarSize.lg)
```

```dart
// Initials only, no image.
Avatar(name: 'Jane Doe')
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `imageUrl` | `null` | Network image source; falls back to initials when `null`/empty or on load error. |
| `name` | `null` | Used to derive the 1–2 letter initials fallback (`'?'` when empty). |
| `size` | `AvatarSize.md` | Diameter preset: `xs` 24, `sm` 32, `md` 44, `lg` 64, `xl` 78, `xxl` 96. |
| `borderColor` | `null` | Optional ring around the avatar; no border when `null`. |
| `backgroundColor` | `Color(0xFFE9F0FF)` | Background behind the initials. |
| `foregroundColor` | `Color(0xFF156EFC)` | Initials text color. |
| `placeholderColor` | `Color(0xFFF3F5F9)` | Fill shown while the image loads. |

## Bind to your tokens

Bind `backgroundColor`/`foregroundColor` to your brand-muted pair, and `borderColor` to
your outline token when a ring is used.

```dart
Avatar(
  imageUrl: user.photoUrl,
  name: user.fullName,
  backgroundColor: AppColors.brandMuted,
  foregroundColor: AppColors.brand,
  placeholderColor: AppColors.surfaceMuted,
)
```
