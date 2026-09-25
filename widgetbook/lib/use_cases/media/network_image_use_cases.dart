import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/media/network_image.dart';

/// "Default" use case for [NetImage]. Toggle a broken URL to see the
/// [errorWidget] fallback render.
Widget netImageUseCase(BuildContext context) {
  final broken = context.knobs.boolean(label: 'Broken URL');
  final width = context.knobs.double.input(label: 'Width', initialValue: 240);
  final height = context.knobs.double.input(label: 'Height', initialValue: 160);
  return Center(
    child: NetImage(
      imageUrl: broken
          ? 'https://example.invalid/missing.jpg'
          : 'https://picsum.photos/seed/netimage/400/300',
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      ),
    ),
  );
}

/// The network-image component group, mirroring `media/network_image.dart`.
final networkImageComponents = [
  WidgetbookComponent(
    name: 'NetImage',
    useCases: [WidgetbookUseCase(name: 'Default', builder: netImageUseCase)],
  ),
];
