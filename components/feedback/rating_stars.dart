import 'package:flutter/material.dart';

/// 5-star rating with half-star precision. Pass `onChanged` for interactive
/// mode.
class RatingStars extends StatelessWidget {
  const RatingStars({
    required this.rating,
    this.onChanged,
    this.size = 24,
    this.color = const Color(0xFFFFB531),
    super.key,
  });

  final double rating;
  final ValueChanged<double>? onChanged;
  final double size;
  final Color color;

  bool get _interactive => onChanged != null;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final fill = (rating - i).clamp(0.0, 1.0);
        final icon = fill >= 0.75
            ? Icons.star_rounded
            : fill >= 0.25
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        final star = Icon(icon, size: size, color: color);
        if (!_interactive) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: star,
          );
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final local = box.globalToLocal(details.globalPosition);
            // half-star: first half of the tapped star = i + 0.5, second half = i + 1.
            final starWidth = size + 2;
            final withinStar = (local.dx - i * starWidth) / starWidth;
            final value = withinStar < 0.5 ? i + 0.5 : i + 1.0;
            onChanged?.call(value);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: star,
          ),
        );
      }),
    );
  }
}
