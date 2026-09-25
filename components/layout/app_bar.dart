import 'package:flutter/material.dart';

/// Standard app bar with an optional wizard progress indicator. Named
/// `TopBar` to avoid clashing with Flutter's own [AppBar], which it wraps.
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    this.title,
    this.showBack = true,
    this.onBack,
    this.onFallback,
    this.actions,
    this.currentStep,
    this.totalSteps,
    this.progressColor = const Color(0xFF156EFC),
    this.progressBackgroundColor = const Color(0xFFF3F5F9),
    super.key,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  /// Called when the default back action has nothing to pop — e.g. this
  /// page was reached via a route replacement and is first in the stack.
  final VoidCallback? onFallback;
  final List<Widget>? actions;
  final int? currentStep;
  final int? totalSteps;
  final Color progressColor;
  final Color progressBackgroundColor;

  void _back(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      onFallback?.call();
    }
  }

  bool get _hasProgress =>
      currentStep != null && totalSteps != null && totalSteps! > 0;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (_hasProgress ? 8 : 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null
          ? null
          : Text(title!, style: const TextStyle(fontWeight: FontWeight.w700)),
      centerTitle: false,
      titleSpacing: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => _back(context),
            )
          : null,
      actions: actions,
      bottom: _hasProgress
          ? PreferredSize(
              preferredSize: const Size.fromHeight(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                  child: LinearProgressIndicator(
                    value: currentStep! / totalSteps!,
                    minHeight: 4,
                    backgroundColor: progressBackgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
