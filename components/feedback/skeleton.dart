import 'package:flutter/material.dart';

/// Lightweight shimmer placeholder used while data is loading.
class Skeleton extends StatefulWidget {
  const Skeleton({
    this.width,
    this.height = 16,
    this.radius = 8,
    this.baseColor = const Color(0xFFF3F5F9),
    this.highlightColor = const Color(0xFFEEF1F6),
    super.key,
  });

  /// Full-width line (height 12).
  const Skeleton.line({
    this.baseColor = const Color(0xFFF3F5F9),
    this.highlightColor = const Color(0xFFEEF1F6),
    super.key,
  })  : width = double.infinity,
        height = 12,
        radius = 8;

  /// Circle avatar placeholder.
  const Skeleton.avatar({
    double size = 44,
    this.baseColor = const Color(0xFFF3F5F9),
    this.highlightColor = const Color(0xFFEEF1F6),
    super.key,
  })  : width = size,
        height = size,
        radius = 999;

  /// Card block (default height 120).
  const Skeleton.card({
    double? height,
    this.baseColor = const Color(0xFFF3F5F9),
    this.highlightColor = const Color(0xFFEEF1F6),
    super.key,
  })  : width = double.infinity,
        height = height ?? 120,
        radius = 16;

  final double? width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _c.value * 2, 0),
              end: Alignment(1 + _c.value * 2, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}
