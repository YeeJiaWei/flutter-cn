import 'package:flutter/material.dart';

/// Hairline divider that fades out toward its left and right ends. Named
/// `FadingDivider` to avoid clashing with Flutter's own [Divider].
class FadingDivider extends StatelessWidget {
  const FadingDivider({
    this.indent = 0,
    this.endIndent = 0,
    this.height = 1,
    this.thickness = 1,
    this.color = const Color(0xFFCCCCCC),
    super.key,
  });

  final double indent;
  final double endIndent;
  final double height;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: indent, right: endIndent),
          child: Container(
            height: thickness,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0),
                  color,
                  color.withValues(alpha: 0),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
