import 'package:flutter/material.dart';

/// Brand-colored circle icon used as the illustration slot on dialog shells.
/// Pass [icon] for the common glyph-on-circle case, or [child] for anything
/// else (an image, an SVG, ...).
class DialogIcon extends StatelessWidget {
  const DialogIcon({
    this.icon,
    this.child,
    this.size = 72,
    this.iconSize = 36,
    this.backgroundColor = const Color(0xFF156EFC),
    this.foregroundColor = Colors.white,
    super.key,
  }) : assert(
          (icon == null) != (child == null),
          'Pass exactly one of icon or child.',
        );

  final IconData? icon;
  final Widget? child;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: foregroundColor, size: iconSize),
    );
  }
}
