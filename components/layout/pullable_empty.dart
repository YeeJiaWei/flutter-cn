import 'package:flutter/material.dart';

/// Scrollable wrapper for empty / error states so a parent `RefreshIndicator`
/// can detect pull gestures even when the content fits on screen.
class PullableEmpty extends StatelessWidget {
  const PullableEmpty({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}
