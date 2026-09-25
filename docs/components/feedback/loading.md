---
name: loading
symbols: [LoadingIndicator]
use_when: A centered, blocking loading state for a screen or panel, optionally with a status message.
avoid_when: A skeleton placeholder matching the eventual content's shape (use feedback/skeleton); a loading state inside a button (use buttons/button's own loading param).
related: [feedback/skeleton, buttons/button]
---
# LoadingIndicator

Centered `CircularProgressIndicator` with an optional message below it.

## When to use

- A full-screen or full-panel loading state — e.g. the body of a screen while its initial
  data fetch is in flight — optionally with `message` for context ("Loading orders…").

## When not to use

- The eventual content has a known shape (a list of cards, a text block) — use
  `feedback/skeleton`'s `Skeleton` (or its `.line`/`.avatar`/`.card` factories) for a
  shimmer placeholder instead of a spinner, so the layout doesn't jump when data arrives.
- A button's own loading state — `buttons/button`'s variants already have a `loading`
  parameter that swaps the label for a spinner; don't overlay `LoadingIndicator` on a
  button.

## Usage

```dart
import 'package:your_app/ui/components/feedback/loading.dart';

const LoadingIndicator();

const LoadingIndicator(message: 'Loading orders…');
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `message` | `null` | Optional text shown below the spinner. |
| `size` | `28` | Spinner width/height. |
| `color` | `Color(0xFF156EFC)` | Spinner color. |
| `messageColor` | `Color(0xFF5A616D)` | `message` text color. |

## Bind to your tokens

Wire `color` and `messageColor` to your brand and secondary text tokens:

```dart
LoadingIndicator(
  message: 'Loading orders…',
  color: AppColors.brand,
  messageColor: AppColors.textSecondary,
);
```
