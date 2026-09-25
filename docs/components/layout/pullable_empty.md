---
name: pullable_empty
symbols: [PullableEmpty]
use_when: Wrapping an empty/error state that must still respond to pull-to-refresh inside a parent RefreshIndicator.
avoid_when: The empty/error state is already inside a scrollable list (e.g. as the sole item of a ListView) — wrapping it again is redundant.
related: [feedback/empty_state]
---
# Pullable Empty

Scrollable wrapper for empty/error states so a parent `RefreshIndicator` still detects
pull gestures even when the content fits on screen.

## When to use

`PullableEmpty` wraps a non-scrolling child (typically an `EmptyState` or error widget) in
a `SingleChildScrollView` with `AlwaysScrollableScrollPhysics`, constrained to at least the
parent's height and centered. Use it whenever an empty or error state is rendered as the
direct child of a `RefreshIndicator` — a plain `Center`/`Column` there won't fill the
viewport, so `RefreshIndicator` can't detect the pull gesture. **Requires a parent
`RefreshIndicator`** to have any pull-to-refresh effect; on its own it's just a
scrollable, centered box.

## When not to use

- **The empty state already sits inside a scrollable list** (e.g. it's the only child of a
  `ListView` with `AlwaysScrollableScrollPhysics`) — that already satisfies
  `RefreshIndicator`, so this wrapper is redundant.
- **No pull-to-refresh is involved** — just render the child directly.

## Usage

```dart
import 'package:your_app/ui/components/layout/pullable_empty.dart';

RefreshIndicator(
  onRefresh: () async {
    // reload data
  },
  child: PullableEmpty(
    child: const EmptyState(
      title: 'No results',
      subtitle: 'Try a different search.',
    ),
  ),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `child` | required | The empty/error widget to center and make scrollable. |

## Bind to your tokens

None — `PullableEmpty` is pure layout with no literal colors, spacing, or text styles.
Bind tokens on the `child` widget itself (e.g. `EmptyState`).
