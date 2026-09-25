---
name: empty_state
symbols: [EmptyState]
use_when: A full-panel placeholder for an empty list, empty search result, or error state, with a title, optional subtitle and optional CTA.
avoid_when: The empty content sits inside a pull-to-refresh scroll view that still needs to detect swipe gestures (wrap it in layout/pullable_empty as well).
related: [buttons/button, layout/pullable_empty]
---
# EmptyState

Empty state placeholder with an illustration or icon, title, subtitle, and an optional
call-to-action button, built on `buttons/button`'s `PrimaryButton`.

## When to use

- Any screen or panel with nothing to show — an empty list, no search results, a first-run
  screen — where you want an icon/illustration, a title, and optionally a subtitle and CTA.
- Pass `imageAsset` for a full illustration instead of the default circle-tinted icon.
- Pass `actionLabel` + `onAction` together to show a CTA button; both are required for the
  button to render.

## When not to use

- The empty state lives inside a scrollable list under a `RefreshIndicator` and needs to
  stay swipe-detectable when there's nothing to scroll — wrap `EmptyState` in
  `layout/pullable_empty`'s `PullableEmpty` rather than dropping it in directly.

## Usage

```dart
import 'package:your_app/ui/components/feedback/empty_state.dart';

EmptyState(
  title: 'No results yet',
  subtitle: 'Try adjusting your filters.',
  icon: Icons.search_off,
);

EmptyState(
  title: 'Your inbox is empty',
  actionLabel: 'Start a conversation',
  onAction: () {},
);
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | required | Main heading text. |
| `subtitle` | `null` | Optional supporting text. |
| `icon` | `Icons.inbox_outlined` | Fallback glyph when `imageAsset` is not set. |
| `imageAsset` | `null` | Full-bleed illustration asset path; overrides the icon circle. |
| `imageSize` | `180` | Width/height of `imageAsset`. |
| `actionLabel` / `onAction` | `null` | Both required together to render the CTA `PrimaryButton`. |
| `actionFullWidth` | `false` | Stretches the CTA to full width. |
| `actionTrailingIcon` | `null` | Trailing glyph on the CTA. |
| `iconBackgroundColor` | `Color(0xFFE9F0FF)` | Circle fill behind `icon`. |
| `iconColor` | `Color(0xFF156EFC)` | `icon` glyph color. |
| `titleColor` | `Color(0xFF156EFC)` | Title text color. |
| `subtitleColor` | `Color(0xFF5A616D)` | Subtitle text color. |

## Bind to your tokens

Wire `iconBackgroundColor`, `iconColor`, `titleColor`, `subtitleColor` to your palette; the
CTA button's colors come from `buttons/button`'s own defaults:

```dart
EmptyState(
  title: 'No results yet',
  iconBackgroundColor: AppColors.brandMuted,
  iconColor: AppColors.brand,
  titleColor: AppColors.textPrimary,
  subtitleColor: AppColors.textSecondary,
);
```
