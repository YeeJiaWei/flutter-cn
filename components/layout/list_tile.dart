import 'package:flutter/material.dart';

/// Consistent 56px list tile with leading icon, title, subtitle, trailing
/// slot. Named `InfoListTile` to avoid clashing with Flutter's own
/// [ListTile].
class InfoListTile extends StatelessWidget {
  const InfoListTile({
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.leadingIconBackgroundColor = const Color(0xFFE9F0FF),
    this.leadingIconColor = const Color(0xFF156EFC),
    this.subtitleColor = const Color(0xFF5A616D),
    this.chevronColor = const Color(0xFF7E8A9A),
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;
  final Color leadingIconBackgroundColor;
  final Color leadingIconColor;
  final Color subtitleColor;
  final Color chevronColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final height = dense ? 48.0 : 56.0;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && leadingIcon != null) {
      leadingWidget = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: leadingIconBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Icon(leadingIcon, size: 18, color: leadingIconColor),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: height),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: chevronColor),
            ],
          ),
        ),
      ),
    );
  }
}
