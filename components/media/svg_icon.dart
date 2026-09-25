import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Thin wrapper rendering an SVG asset as a sized, tintable icon.
/// Requires the `flutter_svg` package.
class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
  });

  final String assetPath;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
