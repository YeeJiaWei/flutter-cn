import 'package:flutter/material.dart';

import '../buttons/button.dart';

/// Empty state placeholder with illustration / icon, title, subtitle,
/// optional CTA.
///
/// Pass `imageAsset` to render a full bleed illustration; otherwise falls
/// back to a circle-tinted material `icon`.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.imageAsset,
    this.imageSize = 180,
    this.actionLabel,
    this.onAction,
    this.actionFullWidth = false,
    this.actionTrailingIcon,
    this.iconBackgroundColor = const Color(0xFFE9F0FF),
    this.iconColor = const Color(0xFF156EFC),
    this.titleColor = const Color(0xFF156EFC),
    this.subtitleColor = const Color(0xFF5A616D),
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String? imageAsset;
  final double imageSize;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionFullWidth;
  final IconData? actionTrailingIcon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Image.asset(
              imageAsset!,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: subtitleColor),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 22),
            SizedBox(
              width: actionFullWidth ? double.infinity : null,
              child: PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: actionFullWidth,
                trailingIcon: actionTrailingIcon,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
