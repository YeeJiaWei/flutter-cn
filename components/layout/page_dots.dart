import 'package:flutter/material.dart';

/// Row of animated pill dots indicating the current page of a carousel.
/// The caller supplies [count] pages and the currently selected [index].
class PageDots extends StatelessWidget {
  const PageDots({
    required this.count,
    required this.index,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
    this.dotSize = 6,
    this.activeWidth = 18,
    super.key,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double activeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: selected ? activeWidth : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: selected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.all(Radius.circular(dotSize)),
          ),
        );
      }),
    );
  }
}
