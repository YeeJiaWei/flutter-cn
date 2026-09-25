import 'package:flutter/material.dart';

/// Standardised page header title — 22px semibold in the primary text
/// colour. Use for the large title at the top of a page so the style stays
/// consistent.
class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
    this.text, {
    this.color = const Color(0xFF0B1220),
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
