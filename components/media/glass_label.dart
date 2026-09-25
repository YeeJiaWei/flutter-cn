import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// A small frosted-glass pill used to overlay a short label on top of
/// imagery (e.g. a "Profile Photo" marker on a photo tile). Blurs whatever
/// is behind it and sits on a translucent white fill with a subtle white
/// border.
class GlassLabel extends StatelessWidget {
  const GlassLabel({
    required this.label,
    this.blurSigma = 8,
    this.radius = 8,
    super.key,
  });

  final String label;
  final double blurSigma;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
