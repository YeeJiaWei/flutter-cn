---
name: status_pill
symbols: [StatusPillVariant, StatusPill]
use_when: A read-only colored label for domain status (order status, match status) where the caller resolves the color/label from state.
avoid_when: A small count/quota marker attached to another element (use feedback/badge); a tappable selectable option (use chips/chip or chips/outline_chip).
related: [feedback/badge, chips/outline_chip]
---
# StatusPill

Read-only colored status chip, filled or outlined. Callers resolve their own label/color
from domain state (e.g. an order status or a match status) and pass them in — this widget
does no domain mapping itself.

## When to use

- Showing a status value as a small colored label — `StatusPillVariant.filled` (default)
  for a solid pill, `StatusPillVariant.outlined` for a bordered, transparent-background
  look.
- The caller maps its own enum/string status to a `label` and `color` before rendering;
  keep that mapping in the caller, not in this shell (see `CLAUDE.md`'s "Shell, not
  product" rule).

## When not to use

- A small numeric/count marker attached to or overlaid on another widget (unread count,
  quota) — use `feedback/badge`'s `CountBadge`.
- A tappable, selectable option meant to change state on tap — use `chips/chip`'s
  `SelectableChip` or `chips/outline_chip`'s `OutlineChip`.

## Usage

```dart
import 'package:your_app/ui/components/feedback/status_pill.dart';

StatusPill(
  label: 'Active',
  color: const Color(0xFF10B981),
);

StatusPill(
  label: 'Pending',
  color: const Color(0xFFF59E0B),
  variant: StatusPillVariant.outlined,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Status text. |
| `color` | required | Base color; fill (filled) or border/text (outlined). |
| `variant` | `StatusPillVariant.filled` | `filled` solid pill or `outlined` bordered pill. |
| `textColor` | `null` | Overrides the resolved text color; defaults to white for filled, `color` for outlined. |

## Bind to your tokens

`StatusPill` takes `color` per call rather than a project-wide default, so binding happens
at the call site: map your domain status to your semantic color tokens before passing them
in.

```dart
StatusPill(
  label: order.status.label,
  color: switch (order.status) {
    OrderStatus.active => AppColors.success,
    OrderStatus.pending => AppColors.warning,
    OrderStatus.cancelled => AppColors.danger,
  },
);
```
