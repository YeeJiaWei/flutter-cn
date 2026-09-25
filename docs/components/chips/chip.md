---
name: chip
symbols: [SelectableChip]
use_when: A pill-shaped, tappable option for filter/select UIs, especially rendered from a list via chips/tag_list.
avoid_when: A single outlined display/pick chip with a distinct filled-vs-outlined selected look (use chips/outline_chip); a read-only status label (use feedback/status_pill).
related: [chips/tag_list, chips/outline_chip, feedback/status_pill]
---
# Chip

Pill-style, fully-rounded chip with an optional leading icon and a selected/unselected
color state. Named `SelectableChip` rather than `Chip` to avoid clashing with Flutter's own
`Chip` widget.

## When to use

- A single filter or option chip that toggles between a selected brand-filled state and an
  unselected neutral state.
- Rendering several of these from a list of string options — reach for `chips/tag_list`'s
  `TagList` instead of mapping `SelectableChip` by hand; it already wires the
  single/multi-select toggling logic.

## When not to use

- A rounded-rectangle (not pill) chip that needs an outlined-vs-filled selected look or a
  trailing icon slot — use `chips/outline_chip`'s `OutlineChip`.
- A read-only status indicator with no tap target — use `feedback/status_pill`'s
  `StatusPill`.

## Usage

```dart
import 'package:your_app/ui/components/chips/chip.dart';

SelectableChip(
  label: 'Vegetarian',
  icon: Icons.eco,
  selected: isSelected,
  onTap: () => setState(() => isSelected = !isSelected),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Chip text. |
| `icon` | `null` | Optional leading glyph. |
| `selected` | `false` | Switches between selected/unselected colors. |
| `onTap` | `null` | Tap handler; omit for a non-interactive chip. |
| `color` | `null` | Overrides `selectedColor` for this instance when selected. |
| `selectedColor` | `Color(0xFF156EFC)` | Background when `selected`. |
| `unselectedBackgroundColor` | `Color(0xFFF3F5F9)` | Background when not selected. |
| `selectedTextColor` | `Colors.white` | Text/icon color when selected. |
| `unselectedTextColor` | `Color(0xFF0B1220)` | Text/icon color when not selected. |

## Bind to your tokens

Wire `selectedColor`, `unselectedBackgroundColor`, `selectedTextColor` and
`unselectedTextColor` to your palette:

```dart
SelectableChip(
  label: 'Vegetarian',
  selected: isSelected,
  onTap: toggle,
  selectedColor: AppColors.brand,
  unselectedBackgroundColor: AppColors.surfaceMuted,
  selectedTextColor: AppColors.onBrand,
  unselectedTextColor: AppColors.textPrimary,
);
```
