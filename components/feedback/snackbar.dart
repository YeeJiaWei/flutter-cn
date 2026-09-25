import 'dart:async';

import 'package:flutter/material.dart';

/// Top-anchored toast notifications with slide in/out animation. Call
/// [Toast.success]/[Toast.error]/[Toast.info] with a [BuildContext]; pass
/// `useRootOverlay: false` to anchor within the nearest [Overlay].
class Toast {
  Toast._();

  /// How long a toast stays on screen once shown.
  static const Duration defaultDuration = Duration(seconds: 5);

  static OverlayEntry? _activeEntry;

  static void success(
    BuildContext context,
    String message, {
    bool useRootOverlay = true,
  }) =>
      _show(
        context,
        message,
        const Color(0xFF10B981),
        Icons.check_circle_rounded,
        useRootOverlay,
      );

  static void error(
    BuildContext context,
    String message, {
    bool useRootOverlay = true,
  }) =>
      _show(
        context,
        message,
        const Color(0xFFEF4444),
        Icons.error_rounded,
        useRootOverlay,
      );

  static void info(
    BuildContext context,
    String message, {
    bool useRootOverlay = true,
  }) =>
      _show(
        context,
        message,
        const Color(0xFF3B82F6),
        Icons.info_rounded,
        useRootOverlay,
      );

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
    bool useRootOverlay,
  ) {
    _activeEntry?.remove();
    _activeEntry = null;

    // Pass useRootOverlay: false to anchor the toast to the nearest Overlay
    // instead of the app's root one.
    final overlay = Overlay.maybeOf(context, rootOverlay: useRootOverlay) ??
        Navigator.of(context, rootNavigator: useRootOverlay).overlay;
    if (overlay == null) return;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _Toast(
        message: message,
        color: color,
        icon: icon,
        onDismissed: () {
          if (_activeEntry == entry) _activeEntry = null;
          entry.remove();
        },
      ),
    );
    _activeEntry = entry;
    overlay.insert(entry);
  }
}

class _Toast extends StatefulWidget {
  const _Toast({
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismissed,
  });

  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismissed;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _autoHide;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _controller.forward();
    _autoHide = Timer(Toast.defaultDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _autoHide?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _autoHide?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF141B2B) : Colors.white;
    final textColor =
        isDark ? const Color(0xFFF5F7FB) : const Color(0xFF0B1220);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 18,
      right: 18,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) < 0) _dismiss();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F0B1220),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
