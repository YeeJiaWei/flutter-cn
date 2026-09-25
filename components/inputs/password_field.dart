import 'package:flutter/material.dart';

import 'text_field.dart';

/// Password field with show/hide eye toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction,
    this.enabled = true,
    this.fillColor,
    this.autofocus = false,
    this.iconColor = const Color(0xFF7E8A9A),
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool enabled;
  final Color? fillColor;
  final bool autofocus;
  final Color iconColor;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      obscureText: _obscured,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      fillColor: widget.fillColor,
      autofocus: widget.autofocus,
      prefixIcon: Icon(Icons.lock_outline, color: widget.iconColor, size: 20),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscured = !_obscured),
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: widget.iconColor,
          size: 20,
        ),
      ),
    );
  }
}
