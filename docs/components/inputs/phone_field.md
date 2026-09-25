---
name: phone_field
symbols: [CountryCode, PhoneField]
use_when: A digits-only phone number input with a fixed country/dial-code prefix.
avoid_when: A generic text input (use inputs/text_field); a picker that lets the user change the country (this only displays one fixed CountryCode).
related: [inputs/text_field]
---
# Phone Field

Digits-only phone input with a fixed country-code prefix, built on
`InputDecorationTheme` with no external package.

## When to use

`PhoneField` renders a digits-only `TextFormField` with a fixed, non-editable dial-code
prefix (e.g. `+60`) built from a `CountryCode`. Use it whenever the form collects a phone
number and the country is fixed or pre-selected elsewhere.

## When not to use

- **A country picker is also required** — this widget only *displays* the given
  `CountryCode`; it has no dropdown or selection UI. Pair it with your own country
  selector and pass the chosen `CountryCode` in via `country`.
- **Any other text input** — use `inputs/text_field.dart`'s `FormTextField`.

## Usage

```dart
import 'package:your_app/ui/components/inputs/phone_field.dart';

PhoneField(
  label: 'Phone number',
  onChanged: (value) {},
)
```

```dart
// Custom country.
PhoneField(
  label: 'Phone number',
  country: const CountryCode(iso: 'SG', dialCode: '+65'),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `label` | `null` | Text shown above the field. |
| `hint` | `'Phone number'` | Placeholder text. |
| `errorText` | `null` | Validation error message. |
| `country` | `PhoneField.defaultCountry` (`CountryCode(iso: 'MY', dialCode: '+60')`) | The fixed dial-code prefix shown before the input. |
| `enabled` | `true` | Disables the field when `false`. |
| `fillColor` | `null` | Field fill color; filled only when non-null. |
| `labelColor` | `Color(0xFF5A616D)` | Label text color. |
| `dialCodeColor` | `Color(0xFF5A616D)` | Color of the dial-code text. |
| `dividerColor` | `Color(0xFFA9A9A9)` | Color of the vertical divider between the dial code and the input. |

## Bind to your tokens

Bind `labelColor`, `dialCodeColor`, and `dividerColor` to your text/divider tokens, and set
`country` to your app's default market instead of the `MY`/`+60` fallback.

```dart
PhoneField(
  label: 'Phone number',
  country: AppConfig.defaultCountryCode,
  labelColor: AppColors.textSecondary,
  dialCodeColor: AppColors.textSecondary,
  dividerColor: AppColors.divider,
)
```
