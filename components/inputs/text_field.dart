import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Standard text input with label, hint, error, prefix/suffix slots. Named
/// `FormTextField` to avoid clashing with Flutter's own [TextField].
class FormTextField extends StatelessWidget {
  const FormTextField({
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.initialValue,
    this.fillColor,
    this.contentPadding,
    this.dense = false,
    this.labelColor = const Color(0xFF5A616D),
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String? initialValue;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color labelColor;

  /// Tightens the field for compact contexts (e.g. a sheet search box):
  /// enables [InputDecoration.isDense] and shrinks the prefix/suffix icon
  /// hit areas from their 48x48 default so the hint, typed text, cursor and
  /// icon stay vertically centred at a smaller [contentPadding].
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.labelLarge?.copyWith(color: labelColor),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          autofocus: autofocus,
          focusNode: focusNode,
          onTap: onTap,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixIconConstraints: dense
                ? const BoxConstraints(minWidth: 40, minHeight: 40)
                : null,
            suffixIconConstraints: dense
                ? const BoxConstraints(minWidth: 40, minHeight: 40)
                : null,
            isDense: dense,
            counterText: '',
            filled: fillColor != null,
            fillColor: fillColor,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          ),
        ),
      ],
    );
  }
}
