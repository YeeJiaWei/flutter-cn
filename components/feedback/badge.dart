import 'package:flutter/material.dart';

/// Small numeric/text badge for counts, status markers, quota indicators.
/// Named `CountBadge` to avoid clashing with Flutter's own [Badge] widget.
class CountBadge extends StatelessWidget {
  const CountBadge({
    required this.label,
    this.color = const Color(0xFFEF4444),
    this.textColor = Colors.white,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
