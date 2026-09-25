import 'package:flutter/material.dart';

/// Generic modal shell: a rounded, padded [Dialog] wrapping a stretched,
/// top-to-bottom [Column] of [children]. Carries no icon, title or button
/// layout of its own — those belong in a project-specific widget built on
/// top of this shell (see the flutter-snippets README).
class BaseDialog extends StatelessWidget {
  const BaseDialog({
    required this.children,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.borderSide,
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.contentPadding = const EdgeInsets.all(24),
    super.key,
  });

  final List<Widget> children;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final BorderSide? borderSide;
  final EdgeInsets insetPadding;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderSide ?? BorderSide.none,
      ),
      insetPadding: insetPadding,
      child: Padding(
        padding: contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// Shows a [BaseDialog] via [showDialog] and returns its popped result.
/// Pass `useRootNavigator: false` to show it within the nearest [Navigator]
/// instead of the app's root one.
Future<T?> showBaseDialog<T>({
  required BuildContext context,
  required List<Widget> children,
  Color backgroundColor = Colors.white,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20)),
  BorderSide? borderSide,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
  EdgeInsets contentPadding = const EdgeInsets.all(24),
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (_) => BaseDialog(
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      borderSide: borderSide,
      insetPadding: insetPadding,
      contentPadding: contentPadding,
      children: children,
    ),
  );
}
