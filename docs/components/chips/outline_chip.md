---
name: outline_chip
symbols: [OutlineChipVariant, OutlineChip]
use_when: A single rounded-rectangle chip for displaying or picking one value (a trait, an interest, a category) that needs an outlined or brand-filled selected look.
avoid_when: A pill-shaped multi/single-select chip meant to be repeated in a group (use chips/chip with chips/tag_list); a read-only status label (use feedback/status_pill).
related: [chips/chip, chips/tag_list, feedback/status_pill]
---
# OutlineChip

Outlined, rounded-rectangle chip for a single picked or displayed value. Pass `onTap` to
make it interactive; leave it `null` for a read-only display chip.

## When to use

- `OutlineChipVariant.outlined` (default) — selected state keeps the white/plain background
  and switches the border and text to `selectedColor`. Good for a subtle "picked" look.
- `OutlineChipVariant.filled` — selected state fills the whole chip with `selectedColor` and
  switches the text (and optional `trailingIcon`) to `selectedTextColor`. Good for a bolder
  "picked" look, e.g. a confirmed selection with a trailing checkmark.
- Omit `onTap` to render a static, non-interactive display chip (e.g. showing a profile's
  existing trait) — no ripple is drawn.

## When not to use

- A group of pill-shaped options meant to be selected together — use `chips/chip`'s
  `SelectableChip`, ideally through `chips/tag_list`'s `TagList`.
- A read-only colored status marker resolved from domain state (order/match status) — use
  `feedback/status_pill`'s `StatusPill`.

## Usage

```dart
import 'package:your_app/ui/components/chips/outline_chip.dart';

OutlineChip(
  label: 'Non-smoker',
  selected: isSelected,
  onTap: () => setState(() => isSelected = !isSelected),
);

OutlineChip(
  label: 'Verified',
  selected: true,
  variant: OutlineChipVariant.filled,
  trailingIcon: const Icon(Icons.check, size: 14, color: Colors.white),
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Chip text. |
| `selected` | `false` | Switches the selected styling on. |
| `variant` | `OutlineChipVariant.outlined` | `outlined` or `filled` selected look. |
| `onTap` | `null` | `null` renders a plain, non-interactive chip (no ripple). |
| `trailingIcon` | `null` | Shown after the label when `selected` and `variant` is `filled`. |
| `backgroundColor` | `Colors.white` | Background when not filled-selected. |
| `borderColor` | `Color(0xFFC4C9D3)` | Border color when not selected. |
| `selectedColor` | `Color(0xFF156EFC)` | Border/fill color when selected. |
| `selectedTextColor` | `Colors.white` | Text/icon color when `selected` and `filled`. |
| `borderWidth` | `0.6` | Border stroke width. |
| `borderRadius` | `BorderRadius.circular(8)` | Corner radius. |
| `padding` | `EdgeInsets.symmetric(horizontal: 12, vertical: 8)` | Inner padding. |
| `fontSize` | `14` | Label font size. |
| `fontWeight` | `FontWeight.w600` | Label font weight. |

## Bind to your tokens

Wire `backgroundColor`, `borderColor`, `selectedColor`, `selectedTextColor` and
`borderRadius` to your palette and radius tokens:

```dart
OutlineChip(
  label: 'Non-smoker',
  selected: isSelected,
  onTap: toggle,
  backgroundColor: AppColors.surface,
  borderColor: AppColors.outline,
  selectedColor: AppColors.brand,
  selectedTextColor: AppColors.onBrand,
  borderRadius: BorderRadius.circular(AppRadius.sm),
);
```
