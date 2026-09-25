---
name: tag_list
symbols: [TagList]
use_when: Rendering a list of string options as selectable pill chips, single- or multi-select.
avoid_when: The options aren't plain strings, or each chip needs its own icon/color logic (map chips/chip by hand instead).
related: [chips/chip]
---
# TagList

`Wrap` of `chips/chip`'s `SelectableChip`, with built-in single- or multi-select toggling.

## When to use

- A group of string options (interests, tags, filters) where tapping a chip should
  add/remove it from a selected set — `multi: true` (default) — or replace the whole
  selection with the tapped option — `multi: false`.
- Any time you'd otherwise map a `List<String>` to `SelectableChip` yourself and hand-write
  the add/remove/replace logic on `onTap`.

## When not to use

- Each option needs a distinct icon, color, or non-string payload — build the `Wrap` of
  `SelectableChip` (or `OutlineChip`) directly instead of forcing it through `TagList`'s
  plain-string API.
- Only one value is ever picked and displayed, not a repeated group — use
  `chips/outline_chip`'s `OutlineChip` directly.

## Usage

```dart
import 'package:your_app/ui/components/chips/tag_list.dart';

Set<String> selected = {};

TagList(
  options: const ['Coffee', 'Tea', 'Juice'],
  selected: selected,
  onChanged: (next) => setState(() => selected = next),
);

TagList(
  options: const ['Small', 'Medium', 'Large'],
  selected: selected,
  onChanged: (next) => setState(() => selected = next),
  multi: false,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `options` | required | The full list of string options rendered as chips. |
| `selected` | required | The current selection, as a `Set<String>`. |
| `onChanged` | required | Called with the next selection set on any tap. |
| `multi` | `true` | `true` toggles into/out of the set; `false` replaces it with one value. |
| `spacing` | `8` | Horizontal gap between chips. |
| `runSpacing` | `8` | Vertical gap between wrapped rows. |

## Bind to your tokens

`TagList` has no color/radius params of its own — it renders plain `SelectableChip`
instances, so bind tokens there (see `chips/chip.md`). Only `spacing`/`runSpacing` are
layout values you may want to align with your spacing scale:

```dart
TagList(
  options: options,
  selected: selected,
  onChanged: onChanged,
  spacing: AppSpacing.sm,
  runSpacing: AppSpacing.sm,
);
```
