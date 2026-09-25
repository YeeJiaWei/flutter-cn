---
name: photo_crop_page
symbols: [PhotoCropPage]
use_when: A full-screen 4:3 portrait photo crop flow (e.g. after picking/taking a profile photo).
avoid_when: A bottom-sheet picker is wanted instead of a full page (this is a Scaffold page, pushed with Navigator); a different aspect ratio or native-crop-activity behavior is required.
related: []
---
# Photo Crop Page

Full-screen 4:3 portrait crop page backed by `crop_your_image` (pure Dart, no native
crop activity).

## When to use

`PhotoCropPage` is a full-screen `Scaffold` (not a bottom sheet) that crops
`imageData` to a fixed 4:3 portrait aspect ratio (`PhotoCropPage.aspectRatio` = `3/4`,
width:height) using the pure-Dart `crop_your_image` package — no native crop activity.
Push it with `Navigator` and await the popped result. Use it right after an image
picker/camera capture step.

**Requires the `crop_your_image` pub package.** `fcn add` installs it automatically; by
hand, add it to the copying project's `pubspec.yaml`.

Pops `Uint8List?`: the cropped image bytes (same format as the input, e.g. JPG in → JPG
out) on confirm, or `null` on cancel.

## When not to use

- **A different fixed aspect ratio, or a native platform crop UI** is required — this page
  hardcodes 4:3 portrait and always uses the pure-Dart cropper.
- **A bottom-sheet flow** is wanted instead of a full page — this is a pushed `Scaffold`
  page, not a `showModalBottomSheet` picker like the other `pickers/` components.

## Usage

```dart
import 'package:your_app/ui/components/pickers/photo_crop_page.dart';

final croppedBytes = await Navigator.of(context).push<Uint8List?>(
  MaterialPageRoute(
    builder: (_) => PhotoCropPage(imageData: pickedImageBytes),
  ),
);
if (croppedBytes != null) {
  // upload/display croppedBytes
}
```

```dart
// Custom failure handling instead of the default SnackBar.
PhotoCropPage(
  imageData: pickedImageBytes,
  onCropFailed: () => showToastError(context),
)
```

## Key parameters

| Parameter | Default | Purpose |
|---|---|---|
| `imageData` | required | Source image bytes to crop. |
| `failureMessage` | `'Crop failed. Please try a different photo.'` | SnackBar text shown on crop failure, unless `onCropFailed` is given. |
| `onCropFailed` | `null` | Overrides the default SnackBar failure handling. |

## Bind to your tokens

The page uses fixed black/white chrome by design (a full-screen photo editor convention),
so there are no color tokens to bind. Bind `failureMessage` to your localized copy if the
app is localized.
