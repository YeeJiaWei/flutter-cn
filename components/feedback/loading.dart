import 'package:flutter/material.dart';

/// Centered progress indicator with optional message below.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.message,
    this.size = 28,
    this.color = const Color(0xFF156EFC),
    this.messageColor = const Color(0xFF5A616D),
    super.key,
  });

  final String? message;
  final double size;
  final Color color;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: messageColor),
            ),
          ],
        ],
      ),
    );
  }
}
