import 'package:flutter/material.dart';

/// Bold title with optional trailing link (text + onTap).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.trailingColor = const Color(0xFF156EFC),
    super.key,
  });

  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry padding;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: textTheme.titleMedium),
          ),
          if (trailingLabel != null && onTrailingTap != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailingLabel!,
                style: textTheme.labelLarge?.copyWith(color: trailingColor),
              ),
            ),
        ],
      ),
    );
  }
}
