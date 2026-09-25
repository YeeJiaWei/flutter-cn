import 'package:flutter/material.dart';

/// Drop-in replacement for `CachedNetworkImage` backed by `Image.network`.
/// Named `NetImage` to avoid clashing with Flutter's own `NetworkImage`
/// (dart:ui) image provider.
///
/// Useful where a cache-manager-backed image loader stalls on its
/// placeholder for otherwise valid, reachable images on some platforms,
/// while the engine's own `Image.network` renders fine. Mirrors the subset
/// of the `CachedNetworkImage` API most call sites use so it swaps in
/// one-for-one.
class NetImage extends StatelessWidget {
  const NetImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext context, String url)? placeholder;
  final Widget Function(BuildContext context, String url, Object error)?
      errorWidget;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder?.call(context, imageUrl) ?? const SizedBox.shrink();
      },
      errorBuilder: (context, error, _) =>
          errorWidget?.call(context, imageUrl, error) ??
          const SizedBox.shrink(),
    );
  }
}
