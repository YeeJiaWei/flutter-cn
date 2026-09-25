---
name: list_tile
symbols: [InfoListTile]
use_when: A settings/navigation row with an optional leading icon, title, subtitle, and trailing slot or chevron.
avoid_when: A generic list item with checkboxes/radios or Material's default 3-line density controls (use core Flutter's ListTile).
related: []
---
# List Tile

Consistent 56px (or 48px dense) list row with leading icon/widget, title, subtitle, and
trailing slot. Named `InfoListTile` to avoid clashing with Flutter's own `ListTile`.

## When to use

`InfoListTile` is a 56px (or 48px dense) row with an optional icon-in-a-box leading
widget, title, subtitle, and trailing slot, with `InkWell` tap feedback. Use it for
settings rows, navigation lists, and account menus — anywhere Flutter's own `ListTile`
would be reached for but a chevron-on-tap convention and a boxed leading icon are wanted
by default.

## When not to use

- **A tile needing Material's built-in selected/enabled states, checkboxes, or the
  standard three-line density system** — use core Flutter's `ListTile`.

## Usage

```dart
import 'package:your_app/ui/components/layout/list_tile.dart';

InfoListTile(
  title: 'Notifications',
  subtitle: 'Push and email preferences',
  leadingIcon: Icons.notifications_outlined,
  onTap: () {},
)
```

```dart
// Custom trailing widget instead of the default chevron.
InfoListTile(
  title: 'Two-factor auth',
  leadingIcon: Icons.lock_outline,
  trailing: Switch(value: true, onChanged: (_) {}),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | required | Primary text. |
| `subtitle` | `null` | Secondary text below the title. |
| `leadingIcon` | `null` | Icon rendered inside a rounded box (ignored if `leading` is set). |
| `leading` | `null` | Custom leading widget, overrides `leadingIcon`. |
| `trailing` | `null` | Trailing widget; falls back to a chevron when `onTap` is set and `trailing` is `null`. |
| `onTap` | `null` | Tap callback; also gates the default chevron. |
| `dense` | `false` | Uses a 48px row instead of 56px. |
| `leadingIconBackgroundColor` | `Color(0xFFE9F0FF)` | Background of the leading icon box. |
| `leadingIconColor` | `Color(0xFF156EFC)` | Color of the leading icon. |
| `subtitleColor` | `Color(0xFF5A616D)` | Subtitle text color. |
| `chevronColor` | `Color(0xFF7E8A9A)` | Color of the default trailing chevron. |

## Bind to your tokens

Bind the icon box, subtitle, and chevron colors to your tokens; title/subtitle typography
comes from `Theme.of(context).textTheme`.

```dart
InfoListTile(
  title: 'Notifications',
  leadingIcon: Icons.notifications_outlined,
  leadingIconBackgroundColor: AppColors.brandMuted,
  leadingIconColor: AppColors.brand,
  subtitleColor: AppColors.textSecondary,
  chevronColor: AppColors.iconMuted,
)
```
