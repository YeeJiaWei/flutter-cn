import 'package:flutter/widgets.dart';

import 'shimmer.dart';
import 'skeleton_block.dart';
import 'text_skeleton.dart';

/// Shimmer placeholder for loading content; colours and timing come from the enclosing [Shimmer].
class Skeleton extends StatelessWidget {
  /// Block of [width] x [height] with rounded [radius]; a null [width] fills the available width.
  const Skeleton({this.width, this.height = 16, this.radius = 8, super.key});

  /// Full-width line (height 12).
  const Skeleton.line({super.key})
    : width = double.infinity,
      height = 12,
      radius = 8;

  /// Circle avatar placeholder.
  const Skeleton.avatar({double size = 44, super.key})
    : width = size,
      height = size,
      radius = 999;

  /// Card block (default height 120).
  const Skeleton.card({double? height, super.key})
    : width = double.infinity,
      height = height ?? 120,
      radius = 16;

  /// Text-shaped placeholder with a seeded, stable random width per line.
  static Widget text({
    TextStyle? style,
    int lines = 1,
    double minFactor = 0.5,
    double maxFactor = 0.9,
    int? chars,
    int? minChars,
    int? maxChars,
    double? widthFactor,
    int? seed,
    Key? key,
  }) => TextSkeleton(
    style: style,
    lines: lines,
    minFactor: minFactor,
    maxFactor: maxFactor,
    chars: chars,
    minChars: minChars,
    maxChars: maxChars,
    widthFactor: widthFactor,
    seed: seed,
    key: key,
  );

  /// Block width; null or infinite fills the available width.
  final double? width;

  /// Block height.
  final double height;

  /// Corner radius.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShimmerScope>();
    if (scope == null) return Shimmer(child: this);
    return SkeletonBlock(
      width: width,
      height: height,
      radius: radius,
      animation: scope.animation,
      baseColor: scope.baseColor,
      highlightColor: scope.highlightColor,
    );
  }
}
