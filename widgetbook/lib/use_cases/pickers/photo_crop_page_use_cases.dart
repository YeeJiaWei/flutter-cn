import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle;
import 'package:widgetbook/widgetbook.dart';

import '../../store/pickers/photo_crop_page.dart';

const _samplePhotoUrl = 'https://picsum.photos/seed/crop/800/1000';

/// Fetches the sample photo's bytes for [PhotoCropPage] to crop.
Future<Uint8List> _loadSamplePhoto() async {
  final bundle = NetworkAssetBundle(Uri.parse(_samplePhotoUrl));
  final data = await bundle.load(_samplePhotoUrl);
  return data.buffer.asUint8List();
}

/// "Default" use case for [PhotoCropPage]: loads a placeholder photo over
/// the network, then renders the full-screen crop page directly (it has no
/// separate show-function).
Widget photoCropPageUseCase(BuildContext context) {
  return FutureBuilder<Uint8List>(
    future: _loadSamplePhoto(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return PhotoCropPage(imageData: snapshot.data!);
    },
  );
}

/// The photo-crop-page component group, mirroring `pickers/photo_crop_page.dart`.
final photoCropPageComponents = [
  WidgetbookComponent(
    name: 'PhotoCropPage',
    useCases: [WidgetbookUseCase(name: 'Default', builder: photoCropPageUseCase)],
  ),
];
