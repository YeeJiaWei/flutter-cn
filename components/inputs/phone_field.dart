import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryCode {
  const CountryCode({required this.iso, required this.dialCode});

  final String iso;
  final String dialCode;
}

/// Phone input with a fixed country-code prefix. Built on
/// `InputDecorationTheme`, no external package.
class PhoneField extends StatefulWidget {
  const PhoneField({
    this.controller,
    this.label,
    this.hint = 'Phone number',
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.fillColor,
    this.country = defaultCountry,
    this.labelColor = const Color(0xFF5A616D),
    this.dialCodeColor = const Color(0xFF5A616D),
    this.dividerColor = const Color(0xFFA9A9A9),
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final Color? fillColor;
  final CountryCode country;
  final Color labelColor;
  final Color dialCodeColor;
  final Color dividerColor;

  static const CountryCode defaultCountry =
      CountryCode(iso: 'MY', dialCode: '+60');

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: textTheme.labelLarge?.copyWith(color: widget.labelColor),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            prefixIcon: _buildCountryPrefix(textTheme),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 24, minHeight: 48),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryPrefix(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.country.dialCode,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: widget.dialCodeColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: widget.dividerColor),
        ],
      ),
    );
  }
}
