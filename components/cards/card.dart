import 'package:flutter/material.dart';

/// Neutral surface wrapper with rounded corners and soft elevation shadow.
/// Named `SurfaceCard` rather than `Card` to avoid clashing with Flutter's
/// own [Card] widget.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.onTap,
    this.elevated = true,
    this.backgroundColor,
    this.radius,
    this.outlineColor = const Color(0xFFA9A9A9),
    this.shadow = const [
      BoxShadow(
        color: Color(0x0F0B1220),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool elevated;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final Color outlineColor;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final borderRadius = radius ?? const BorderRadius.all(Radius.circular(16));

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        boxShadow: elevated ? shadow : null,
        border: elevated ? null : Border.all(color: outlineColor),
      ),
      child: child,
    );

    if (onTap == null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: content,
      );
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}
