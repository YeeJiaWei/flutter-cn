import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

/// Full-screen 4:3 portrait crop page backed by `crop_your_image` (pure
/// Dart, no native crop activity).
///
/// Pops with the cropped image bytes ([Uint8List]) on confirm, or `null` on
/// cancel. Output keeps the input format (JPG in → JPG out). On crop
/// failure, shows [failureMessage] via a [SnackBar] unless [onCropFailed]
/// is given.
class PhotoCropPage extends StatefulWidget {
  const PhotoCropPage({
    required this.imageData,
    this.failureMessage = 'Crop failed. Please try a different photo.',
    this.onCropFailed,
    super.key,
  });

  final Uint8List imageData;
  final String failureMessage;
  final VoidCallback? onCropFailed;

  /// 4:3 portrait — taller than wide (width:height = 3:4).
  static const double aspectRatio = 3 / 4;

  @override
  State<PhotoCropPage> createState() => _PhotoCropPageState();
}

class _PhotoCropPageState extends State<PhotoCropPage> {
  final _controller = CropController();
  bool _busy = false;

  void _confirm() {
    setState(() => _busy = true);
    _controller.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _busy ? null : () => Navigator.of(context).pop<Uint8List?>(null),
        ),
        title: const Text('Crop photo'),
        actions: [
          TextButton(
            onPressed: _busy ? null : _confirm,
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Crop(
            image: widget.imageData,
            controller: _controller,
            aspectRatio: PhotoCropPage.aspectRatio,
            interactive: true,
            baseColor: Colors.black,
            maskColor: Colors.black.withValues(alpha: 0.6),
            onCropped: (result) {
              switch (result) {
                case CropSuccess(:final croppedImage):
                  Navigator.of(context).pop<Uint8List?>(croppedImage);
                case CropFailure():
                  setState(() => _busy = false);
                  if (widget.onCropFailed != null) {
                    widget.onCropFailed!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(widget.failureMessage)),
                    );
                  }
              }
            },
          ),
          if (_busy)
            const ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
