import 'package:flutter/material.dart';

enum ButtonSize { sm, md, lg }

enum _Variant { primary, secondary, outline, text }

/// Base button shared by the typed button variants.
class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.onPressed,
    required this.variant,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.fullWidth = true,
    this.size = ButtonSize.md,
    this.danger = false,
    this.brandColor = const Color(0xFF156EFC),
    this.dangerColor = const Color(0xFFEF4444),
    this.secondaryBackgroundColor = const Color(0xFFE9F0FF),
    this.onColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final String label;
  final VoidCallback? onPressed;
  final _Variant variant;
  final bool loading;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final ButtonSize size;
  final bool danger;
  final Color brandColor;
  final Color dangerColor;
  final Color secondaryBackgroundColor;
  final Color onColor;
  final BorderRadius borderRadius;

  double get _height {
    switch (size) {
      case ButtonSize.sm:
        return 40;
      case ButtonSize.md:
        return 48;
      case ButtonSize.lg:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 18);
      case ButtonSize.md:
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 22);
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.sm:
        return 13;
      case ButtonSize.md:
        return 15;
      case ButtonSize.lg:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    final brand = danger ? dangerColor : brandColor;

    final child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == _Variant.primary ? onColor : brand,
              ),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _fontSize + 4),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: _fontSize + 4),
              ],
            ],
          );

    Widget button;
    switch (variant) {
      case _Variant.primary:
        button = ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: brand,
            foregroundColor: onColor,
            padding: _padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, _height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );
        break;
      case _Variant.secondary:
        button = FilledButton(
          onPressed: disabled ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: secondaryBackgroundColor,
            foregroundColor: brand,
            padding: _padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, _height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );
        break;
      case _Variant.outline:
        button = OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: brand,
            side: BorderSide(color: brand, width: 1.5),
            padding: _padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, _height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );
        break;
      case _Variant.text:
        button = TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: brand,
            padding: _padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, _height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );
        break;
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Solid brand-colored call-to-action button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    this.fullWidth = true,
    this.size = ButtonSize.md,
    this.danger = false,
    this.brandColor = const Color(0xFF156EFC),
    this.dangerColor = const Color(0xFFEF4444),
    this.onColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final ButtonSize size;
  final bool danger;
  final Color brandColor;
  final Color dangerColor;
  final Color onColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => _Button(
        label: label,
        onPressed: onPressed,
        variant: _Variant.primary,
        loading: loading,
        icon: icon,
        trailingIcon: trailingIcon,
        fullWidth: fullWidth,
        size: size,
        danger: danger,
        brandColor: brandColor,
        dangerColor: dangerColor,
        onColor: onColor,
        borderRadius: borderRadius,
      );
}

/// Tinted, lower-emphasis button (brand-light fill, brand-colored label).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.md,
    this.brandColor = const Color(0xFF156EFC),
    this.secondaryBackgroundColor = const Color(0xFFE9F0FF),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final ButtonSize size;
  final Color brandColor;
  final Color secondaryBackgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => _Button(
        label: label,
        onPressed: onPressed,
        variant: _Variant.secondary,
        loading: loading,
        icon: icon,
        fullWidth: fullWidth,
        size: size,
        brandColor: brandColor,
        secondaryBackgroundColor: secondaryBackgroundColor,
        borderRadius: borderRadius,
      );
}

/// Outlined, brand-bordered button.
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.md,
    this.danger = false,
    this.brandColor = const Color(0xFF156EFC),
    this.dangerColor = const Color(0xFFEF4444),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final ButtonSize size;
  final bool danger;
  final Color brandColor;
  final Color dangerColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => _Button(
        label: label,
        onPressed: onPressed,
        variant: _Variant.outline,
        loading: loading,
        icon: icon,
        fullWidth: fullWidth,
        size: size,
        danger: danger,
        brandColor: brandColor,
        dangerColor: dangerColor,
        borderRadius: borderRadius,
      );
}

/// Text-only, no-background button. Named to avoid clashing with Flutter's
/// own [TextButton], which this builds on internally.
class PlainTextButton extends StatelessWidget {
  const PlainTextButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.fullWidth = false,
    this.size = ButtonSize.md,
    this.danger = false,
    this.brandColor = const Color(0xFF156EFC),
    this.dangerColor = const Color(0xFFEF4444),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;
  final ButtonSize size;
  final bool danger;
  final Color brandColor;
  final Color dangerColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => _Button(
        label: label,
        onPressed: onPressed,
        variant: _Variant.text,
        loading: loading,
        icon: icon,
        fullWidth: fullWidth,
        size: size,
        danger: danger,
        brandColor: brandColor,
        dangerColor: dangerColor,
        borderRadius: borderRadius,
      );
}
