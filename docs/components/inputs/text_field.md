---
name: text_field
symbols: [FormTextField]
use_when: Any labeled text input with hint/error/helper text and prefix/suffix slots.
avoid_when: Password entry (use inputs/password_field); a phone number with a fixed dial-code prefix (use inputs/phone_field).
related: [inputs/password_field, inputs/phone_field]
---
# Text Field

Labeled `TextFormField` wrapper with hint, error/helper text, and prefix/suffix slots.
Named `FormTextField` to avoid clashing with Flutter's own `TextField`.

## When to use

`FormTextField` is the default text input for any form: a label above the field, an
optional hint, error/helper text below, and prefix/suffix icon slots. Use it for
single-line, multi-line, or `TextFormField`-validated inputs (email, name, notes, search).

## When not to use

- **Password entry** — use `inputs/password_field.dart`'s `PasswordField`, which wraps
  `FormTextField` and adds the show/hide toggle.
- **Phone numbers with a fixed country/dial-code prefix** — use
  `inputs/phone_field.dart`'s `PhoneField` instead of building the prefix by hand.
- **A bare input with no label/hint/error chrome** — use core Flutter's `TextField` or
  `TextFormField` directly; `FormTextField` always renders the label column and decoration.

## Usage

```dart
import 'package:your_app/ui/components/inputs/text_field.dart';

FormTextField(
  label: 'Email',
  hint: 'you@example.com',
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {},
)
```

```dart
// Compact / dense variant for a sheet search box.
FormTextField(
  hint: 'Search',
  dense: true,
  prefixIcon: const Icon(Icons.search),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | `null` | Text shown above the field; omitted when `null`. |
| `hint` | `null` | Placeholder text inside the field. |
| `errorText` | `null` | Shows an error message and error styling. |
| `helperText` | `null` | Helper text below the field when no error. |
| `prefixIcon` / `suffixIcon` | `null` | Leading/trailing widget slots. |
| `obscureText` | `false` | Masks input (used internally by `PasswordField`). |
| `dense` | `false` | Shrinks padding and icon hit areas for compact contexts. |
| `fillColor` | `null` | Fill color; field is filled only when non-null. |
| `contentPadding` | `EdgeInsets.symmetric(horizontal: 18, vertical: 18)` | Inner padding of the decoration. |
| `labelColor` | `Color(0xFF5A616D)` | Color of the label text. |
| `enabled` / `readOnly` | `true` / `false` | Standard `TextFormField` passthroughs. |

## Bind to your tokens

Wire `labelColor` to your text token, and `fillColor` / `contentPadding` to your input
surface and spacing tokens. The default label style already reads from
`Theme.of(context).textTheme`, so most typography comes from the app theme automatically.

```dart
FormTextField(
  label: 'Email',
  labelColor: AppColors.textSecondary,
  fillColor: AppColors.surfaceMuted,
  contentPadding: EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  ),
)
```
