---
name: header_title
symbols: [HeaderTitle]
use_when: The large page-title text at the top of a page, kept visually consistent across the app.
avoid_when: A bold section title with a trailing link (use layout/section_header); the title needs to sit inside AppBar/PageHeader chrome, not just be styled text (those compose HeaderTitle for you already).
related: [layout/page_header, layout/section_header]
---
# Header Title

Standardised large page-title text: 22px semibold in the primary text colour.

## When to use

`HeaderTitle` is a thin `Text` wrapper that standardises the large page-title style (22px,
semibold). Use it as the visual title at the top of any page, or wherever you need that
exact style reused. `layout/page_header.dart`'s `PageHeader` already renders one for you
when given a `title` string, so use `HeaderTitle` directly only when you need the title
text without the rest of `PageHeader`'s row/actions layout.

## When not to use

- **A section title with a trailing "See all" style link** — use
  `layout/section_header.dart`'s `SectionHeader`.
- **Inside a `PageHeader`** — pass `title` to `PageHeader` instead of nesting a
  `HeaderTitle` yourself; it already builds one from the string.

## Usage

```dart
import 'package:your_app/ui/components/layout/header_title.dart';

const HeaderTitle('Settings')
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `text` (positional) | required | The title string. |
| `color` | `Color(0xFF0B1220)` | Text color. |

## Bind to your tokens

Bind `color` to your primary text token.

```dart
HeaderTitle('Settings', color: AppColors.textPrimary)
```
