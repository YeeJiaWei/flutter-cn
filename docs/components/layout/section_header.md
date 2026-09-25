---
name: section_header
symbols: [SectionHeader]
use_when: A bold section title row with an optional trailing text link (e.g. "See all").
avoid_when: The large page-level title (use layout/header_title).
related: [layout/header_title]
---
# Section Header

Bold title with an optional trailing text link (title + onTap).

## When to use

`SectionHeader` renders a bold title on the left and, when both `trailingLabel` and
`onTrailingTap` are given, a tappable link on the right (e.g. "See all"). Use it above a
list or grid section within a page.

## When not to use

- **The page's main title** — use `layout/header_title.dart`'s `HeaderTitle` (or
  `layout/page_header.dart`'s `PageHeader`, which wraps one).

## Usage

```dart
import 'package:your_app/ui/components/layout/section_header.dart';

SectionHeader(title: 'Recent orders')
```

```dart
// With a trailing link.
SectionHeader(
  title: 'Recent orders',
  trailingLabel: 'See all',
  onTrailingTap: () {},
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | required | Left-aligned bold title. |
| `trailingLabel` | `null` | Trailing link text; shown only when `onTrailingTap` is also set. |
| `onTrailingTap` | `null` | Tap callback for the trailing link. |
| `padding` | `EdgeInsets.symmetric(horizontal: 18, vertical: 12)` | Outer padding of the row. |
| `trailingColor` | `Color(0xFF156EFC)` | Color of the trailing link text. |

## Bind to your tokens

Bind `trailingColor` to your brand/link token and `padding` to your spacing scale; the
title style comes from `Theme.of(context).textTheme.titleMedium`.

```dart
SectionHeader(
  title: 'Recent orders',
  trailingLabel: 'See all',
  onTrailingTap: () {},
  trailingColor: AppColors.brand,
  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
)
```
