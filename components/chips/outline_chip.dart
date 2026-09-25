import 'package:flutter/material.dart';

/// How [OutlineChip] renders its `selected` state.
enum OutlineChipVariant {
  /// Selected chips keep [backgroundColor] and switch the border + text to
  /// [selectedColor].
  outlined,

  /// Selected chips fill with [selectedColor] and switch the text to
  /// [selectedTextColor].
  filled,
}

/// Outlined rounded-rectangle chip for displaying or picking a single value
/// (e.g. a trait or interest). Pass [onTap] to make it interactive; leave it
/// null for a read-only display chip.
class OutlineChip extends StatelessWidget {
  const OutlineChip({
    required this.label,
    this.selected = false,
    this.variant = OutlineChipVariant.outlined,
    this.onTap,
    this.trailingIcon,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFC4C9D3),
    this.selectedColor = const Color(0xFF156EFC),
    this.selectedTextColor = Colors.white,
    this.borderWidth = 0.6,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.trailingIconGap = 6,
    super.key,
  });

  final String label;
  final bool selected;
  final OutlineChipVariant variant;

  /// Null renders a plain, non-interactive chip (no ripple).
  final VoidCallback? onTap;

  /// Shown after the label when [selected] and [variant] is `filled`.
  final Widget? trailingIcon;

  final Color backgroundColor;
  final Color borderColor;
  final Color selectedColor;

  /// Text (and [trailingIcon]) color when [selected] and [variant] is `filled`.
  final Color selectedTextColor;

  final double borderWidth;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;

  /// Gap between the label and [trailingIcon].
  final double trailingIconGap;

  bool get _filled => selected && variant == OutlineChipVariant.filled;

  @override
  Widget build(BuildContext context) {
    final fg = _filled
        ? selectedTextColor
        : (selected ? selectedColor : const Color(0xFF0B1220));

    final chip = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _filled ? selectedColor : backgroundColor,
        borderRadius: borderRadius,
        border: _filled
            ? null
            : Border.all(
                color: selected ? selectedColor : borderColor,
                width: borderWidth,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: fg,
              ),
            ),
          ),
          if (_filled && trailingIcon != null) ...[
            SizedBox(width: trailingIconGap),
            trailingIcon!,
          ],
        ],
      ),
    );

    if (onTap == null) return chip;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(borderRadius: borderRadius, onTap: onTap, child: chip),
    );
  }
}
