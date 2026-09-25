import 'package:flutter/material.dart';

/// Pill-style chip with optional leading icon and selected state. Named
/// `SelectableChip` rather than `Chip` to avoid clashing with Flutter's own
/// [Chip] widget.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.color,
    this.selectedColor = const Color(0xFF156EFC),
    this.unselectedBackgroundColor = const Color(0xFFF3F5F9),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF0B1220),
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;
  final Color selectedColor;
  final Color unselectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (color ?? selectedColor) : unselectedBackgroundColor;
    final fg = selected ? selectedTextColor : unselectedTextColor;

    return Material(
      color: bg,
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
