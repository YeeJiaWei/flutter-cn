---
name: password_field
symbols: [PasswordField]
use_when: Password entry with a built-in show/hide toggle.
avoid_when: Any non-password text input (use inputs/text_field); a field needing custom prefix/suffix icons other than the lock/eye pair.
related: [inputs/text_field]
---
# Password Field

Stateful wrapper over `inputs/text_field`'s `FormTextField` that manages the
obscure/reveal state and renders a lock icon plus a show/hide eye toggle.

## When to use

`PasswordField` is a stateful wrapper over `FormTextField` that manages obscure/reveal
state internally and renders a lock icon plus an eye toggle. Use it for any password or
secret entry field.

## When not to use

- **Any other text input** — use `inputs/text_field.dart`'s `FormTextField` directly; it
  exposes the full param set (prefix/suffix widgets, multi-line, formatters) that
  `PasswordField` intentionally narrows down.
- **A field where the leading/trailing icons must be something other than lock/eye** —
  build directly on `FormTextField` with `obscureText` and your own `suffixIcon` toggle.

## Usage

```dart
import 'package:your_app/ui/components/inputs/password_field.dart';

PasswordField(
  label: 'Password',
  hint: 'Enter your password',
  onChanged: (value) {},
  validator: (value) =>
      (value == null || value.length < 8) ? 'At least 8 characters' : null,
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | `null` | Text shown above the field. |
| `hint` | `null` | Placeholder text. |
| `errorText` | `null` | Validation error message. |
| `iconColor` | `Color(0xFF7E8A9A)` | Color of both the lock icon and the eye toggle. |
| `fillColor` | `null` | Passed through to the underlying `FormTextField`. |
| `enabled` | `true` | Disables the field when `false`. |
| `textInputAction` | `null` | Keyboard action button (e.g. `TextInputAction.done`). |
| `autofocus` | `false` | Focuses the field on build. |

## Bind to your tokens

Bind `iconColor` to your muted-icon token; everything else (label color, fill, padding)
flows through `FormTextField`'s own defaults, so bind those there if you compose a custom
wrapper.

```dart
PasswordField(
  label: 'Password',
  iconColor: AppColors.iconMuted,
)
```
