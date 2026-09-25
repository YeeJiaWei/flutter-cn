import 'package:flutter/material.dart';

import 'network_image.dart';

enum AvatarSize { xs, sm, md, lg, xl, xxl }

/// Circular avatar with network image and initials fallback.
class Avatar extends StatelessWidget {
  const Avatar({
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,
    this.borderColor,
    this.backgroundColor = const Color(0xFFE9F0FF),
    this.foregroundColor = const Color(0xFF156EFC),
    this.placeholderColor = const Color(0xFFF3F5F9),
    super.key,
  });

  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final Color? borderColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color placeholderColor;

  double get _diameter {
    switch (size) {
      case AvatarSize.xs:
        return 24;
      case AvatarSize.sm:
        return 32;
      case AvatarSize.md:
        return 44;
      case AvatarSize.lg:
        return 64;
      case AvatarSize.xl:
        return 78;
      case AvatarSize.xxl:
        return 96;
    }
  }

  String get _initials {
    final n = name?.trim() ?? '';
    if (n.isEmpty) return '?';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final d = _diameter;
    final fontSize = d * 0.36;

    Widget content = Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipOval(
        child: NetImage(
          imageUrl: imageUrl!,
          width: d,
          height: d,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Container(width: d, height: d, color: placeholderColor),
          errorWidget: (context, url, error) => content,
        ),
      );
      if (borderColor != null) {
        content = DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor!, width: 2),
          ),
          child: content,
        );
      }
    }

    return content;
  }
}
