import 'package:flutter/material.dart';

/// Whether [StatusPill] renders as a solid chip or a bordered outline.
enum StatusPillVariant { filled, outlined }

/// Read-only colored status chip. Callers resolve their own label/color from
/// domain state (e.g. an order status or a match status) and pass them in.
class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    required this.color,
    this.variant = StatusPillVariant.filled,
    this.textColor,
    super.key,
  });

  final String label;
  final Color color;
  final StatusPillVariant variant;

  /// Defaults to white for filled, to [color] for outlined.
  final Color? textColor;

  bool get _filled => variant == StatusPillVariant.filled;

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? (_filled ? Colors.white : color);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: _filled ? 6 : 4),
      decoration: BoxDecoration(
        color: _filled ? color : null,
        border: _filled ? null : Border.all(color: color),
        borderRadius: BorderRadius.all(
          Radius.circular(_filled ? 999 : 8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: _filled ? 12 : 14,
          fontWeight: _filled ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
