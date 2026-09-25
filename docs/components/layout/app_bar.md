---
name: app_bar
symbols: [TopBar]
use_when: A page-level AppBar with a back button and, optionally, a wizard progress bar.
avoid_when: A tab page inside a bottom-nav shell with no AppBar (use layout/page_header); a plain title-only header with no navigation chrome (use layout/header_title).
related: [layout/page_header, layout/header_title, layout/progress_stepper]
---
# App Bar

`AppBar` wrapper with a pop-or-fallback back button and an optional wizard progress bar.
Named `TopBar` to avoid clashing with Flutter's own `AppBar`, which it wraps.

## When to use

`TopBar` wraps Flutter's `AppBar` and implements `PreferredSizeWidget`, so it drops
straight into `Scaffold.appBar`. Use it for any pushed page that needs a title, a
pop-or-fallback back button, trailing actions, and — when `currentStep`/`totalSteps` are
both given — a thin wizard progress bar under the title row.

## When not to use

- **A tab page with no `AppBar`, inside a bottom-nav shell** — use
  `layout/page_header.dart`'s `PageHeader`, which matches `AppBar` geometry without being
  one.
- **Just a styled title string with no bar chrome** — use `layout/header_title.dart`'s
  `HeaderTitle`.
- **A full wizard progress bar as its own block, not inside a bar** — use
  `layout/progress_stepper.dart`'s `ProgressStepper` directly.

## Usage

```dart
import 'package:your_app/ui/components/layout/app_bar.dart';

Scaffold(
  appBar: TopBar(
    title: 'Edit profile',
    actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
  ),
)
```

```dart
// With a wizard progress bar and a fallback for when there's nothing to pop.
Scaffold(
  appBar: TopBar(
    title: 'Step 2',
    currentStep: 2,
    totalSteps: 4,
    onFallback: () => Navigator.of(context).pushReplacementNamed('/home'),
  ),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `title` | `null` | Bar title; omitted when `null`. |
| `showBack` | `true` | Shows the leading back `IconButton`. |
| `onBack` | `null` | Overrides the default pop-or-fallback behavior. |
| `onFallback` | `null` | Called when the back action has nothing to pop. |
| `actions` | `null` | Trailing action widgets. |
| `currentStep` / `totalSteps` | `null` / `null` | When both set (and `totalSteps > 0`), renders the progress bar. |
| `progressColor` | `Color(0xFF156EFC)` | Filled portion of the progress bar. |
| `progressBackgroundColor` | `Color(0xFFF3F5F9)` | Track color of the progress bar. |

## Bind to your tokens

Bind `progressColor` to your brand token and `progressBackgroundColor` to your neutral
track token; the title text style comes from the default `AppBar` theme, so set that at
the `ThemeData` level rather than per instance.

```dart
TopBar(
  title: 'Step 2',
  currentStep: 2,
  totalSteps: 4,
  progressColor: AppColors.brand,
  progressBackgroundColor: AppColors.surfaceMuted,
)
```
