---
name: tabs
symbols: [TabListVariant, Tabs, TabsScope, TabList, TabItem, TabBadge, TabContent, TabPages]
use_when: Switching between sibling views of one screen with an underline tab strip or a pill segmented control, optionally swipeable via TabPages.
avoid_when: Step-by-step wizard progress (use layout/progress_stepper); carousel position dots (use layout/page_dots); filter options that can be multi-selected (use chips/tag_list).
related: [layout/progress_stepper, layout/page_dots, chips/tag_list]
---
# Tabs

Controlled tab family, after shadcn/ui's Tabs: a `Tabs<T>` root holds the selected value,
a `TabList` of `TabItem`s selects it, and `TabContent` or `TabPages` shows the matching
panel. The non-scrollable pill variant draws **one** selected background that slides to the
selected tab's slot (position and width come from the selected index), and tapping a tab
jumps `TabPages` straight to its page instead of scrolling through the pages in between.

## When to use

- Two to five sibling views of one screen (Upcoming / Pending, Interested / Past / Reviewed).
- A pill segmented control above swipeable lists — `TabList(variant: TabListVariant.pill)`
  + `TabPages`.
- An underline strip over static panels — `TabList()` + `TabContent`.
- A count next to a tab label — `TabBadge` in the tab's `badge` slot; it flips colours when
  its tab is selected.

## When not to use

- Wizard progress through ordered steps — use `layout/progress_stepper`.
- Showing which carousel page is visible — use `layout/page_dots`.
- Multi-select filters — use `chips/tag_list`.

## Usage

```dart
import 'package:your_app/ui/components/layout/tabs.dart';

Tabs<int>(
  value: tab,
  onChanged: (next) => setState(() => tab = next),
  child: Column(
    children: [
      TabList(
        variant: TabListVariant.pill,
        children: [
          TabItem<int>(value: 0, label: 'Upcoming', badge: TabBadge(count: upcoming)),
          const TabItem<int>(value: 1, label: 'Pending'),
        ],
      ),
      Expanded(
        child: TabPages<int>(
          values: const [0, 1],
          children: const [UpcomingList(), PendingList()],
        ),
      ),
    ],
  ),
);
```

Static panels instead of a pager:

```dart
TabContent<int>(value: 0, child: UpcomingList()),
TabContent<int>(value: 1, keepAlive: true, child: PendingList()),
```

Read or change the selection from a descendant with `Tabs.of<int>(context).value` /
`.select(1)`.

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `Tabs.value` / `onChanged` | required | Selected value and its change handler (the caller owns state). |
| `TabList.variant` | `underline` | `underline` strip or `pill` segmented control. |
| `TabList.scrollable` | `false` | Content-width tabs in a horizontal scroll; a scrollable pill uses a per-tab background instead of the sliding one. |
| `TabList.indicatorColor` | `Color(0xFF156EFC)` | Underline bar, and the pill's selected background. |
| `TabList.indicatorDecoration` | `null` | Replaces the pill's selected background (gradient, image). |
| `TabList.activeLabelColor` | underline: `indicatorColor`, pill: white | Selected label colour. |
| `TabList.inactiveLabelColor` | underline: `0xFF5A616D`, pill: `0xFF0B1220` | Unselected label colour. |
| `TabList.labelStyle` | underline: `labelLarge`, pill: 14 | Base label style; colour and weight are applied on top. |
| `TabList.backgroundColor` | `Colors.white` | Pill track colour. |
| `TabList.borderColor` | `Color(0xFFA9A9A9)` | Underline strip's bottom border. |
| `TabList.trackRadius` / `indicatorRadius` | 12 / 8 | Pill track and selected background corners. |
| `TabList.trackShadow` | soft card shadow | Pill track shadow. |
| `TabList.tabHeight` | `45` | Pill tab height. |
| `TabList.duration` | 250 ms | Indicator slide and label colour transition. |
| `TabItem.value` | required | Value this tab selects. |
| `TabItem.label` / `child` | — | Exactly one: text label or custom content. |
| `TabItem.icon` / `badge` | `null` | Leading icon / trailing widget (usually `TabBadge`). |
| `TabBadge.count` | required | Number shown; colours via `color`, `textColor`, `selectedColor`, `selectedTextColor`. |
| `TabContent.keepAlive` | `false` | Keep an unselected panel mounted offstage. |
| `TabPages.values` / `children` | required | Page order, same length; give it a bounded height. |

## Bind to your tokens

Wrap the list once with your palette and reuse it:

```dart
TabList(
  variant: TabListVariant.pill,
  indicatorColor: AppColors.brand,
  backgroundColor: AppColors.surface,
  inactiveLabelColor: AppColors.textPrimary,
  trackRadius: AppRadius.md,
  indicatorRadius: AppRadius.sm,
  trackShadow: AppShadows.card,
  children: tabs,
);

TabBadge(
  count: count,
  color: AppColors.brand,
  selectedColor: AppColors.onBrand,
  selectedTextColor: AppColors.brand,
);
```
