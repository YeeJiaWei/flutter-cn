---
name: badge
symbols: [CountBadge]
use_when: A small pill marking a count, quota, or status next to another element (e.g. on an avatar or a nav icon).
avoid_when: A larger, labeled status indicator standing on its own (use feedback/status_pill).
related: [feedback/status_pill]
---
# CountBadge

Small numeric/text pill for counts, status markers, or quota indicators. Named
`CountBadge` to avoid clashing with Flutter's own `Badge` widget.

## When to use

- A short label overlaid on or next to another widget — an unread count, a "New" marker, a
  quota indicator — where the badge itself is small and secondary to what it's attached to.
- Pass `icon` for a leading glyph alongside the text (e.g. a warning triangle before "3
  issues").

## When not to use

- A standalone, larger status indicator that reads as its own element (an order/match
  status) — use `feedback/status_pill`'s `StatusPill`, which has filled/outlined variants
  and larger text.

## Usage

```dart
import 'package:your_app/ui/components/feedback/badge.dart';

const CountBadge(label: '3');

const CountBadge(
  label: 'New',
  color: Color(0xFF10B981),
  icon: Icons.star,
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | required | Badge text. |
| `color` | `Color(0xFFEF4444)` | Pill background color. |
| `textColor` | `Colors.white` | Text/icon color. |
| `icon` | `null` | Optional leading glyph. |

## Bind to your tokens

Wire `color` and `textColor` to your semantic color tokens (e.g. an "attention" or
"success" color):

```dart
CountBadge(
  label: '3',
  color: AppColors.danger,
  textColor: AppColors.onDanger,
);
```
