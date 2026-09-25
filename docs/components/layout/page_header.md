---
name: page_header
symbols: [PageHeader]
use_when: The top bar of a tab page inside a bottom-nav shell that has no Scaffold.appBar.
avoid_when: A pushed page that needs a real AppBar with a back button (use layout/app_bar); just a title string with no row/actions layout (use layout/header_title).
related: [layout/app_bar, layout/header_title]
---
# Page Header

Tab-page top bar matching `AppBar`'s geometry without being one, so every tab in a
bottom-nav shell lines up even without a real `AppBar`.

## When to use

`PageHeader` matches `AppBar`'s geometry (status-bar inset + `kToolbarHeight` row) without
being a `PreferredSizeWidget`/`Scaffold.appBar`, so every tab in a bottom-nav shell lines
up even though none of them have a real `AppBar`. Renders a title (via `HeaderTitle`) or a
custom `leading` widget, plus trailing `actions`.

## When not to use

- **A pushed page with back navigation** — use `layout/app_bar.dart`'s `TopBar`, which
  implements `PreferredSizeWidget` for `Scaffold.appBar` and includes a back button.
- **Just a title with no row/trailing-actions layout** — use
  `layout/header_title.dart`'s `HeaderTitle` directly.

## Usage

```dart
import 'package:your_app/ui/components/layout/page_header.dart';

PageHeader(
  title: 'Home',
  actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
)
```

```dart
// Custom leading widget instead of a title string.
PageHeader(leading: const Text('Custom leading'))
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | `null` | Renders a `HeaderTitle`; either this or `leading` is required (asserted). |
| `leading` | `null` | Custom leading widget instead of the default `HeaderTitle`. |
| `actions` | `null` | Trailing action widgets. |

## Bind to your tokens

`PageHeader` has no literal colors of its own — it delegates title styling to
`HeaderTitle`, so bind tokens there.

```dart
PageHeader(leading: HeaderTitle('Home', color: AppColors.textPrimary))
```
