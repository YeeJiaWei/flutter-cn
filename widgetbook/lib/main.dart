import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'directories.dart';

/// Widgetbook catalogue entrypoint for the flutter-snippets store.
void main() {
  runApp(const SnippetsWidgetbookApp());
}

/// Hosts the manual widget tree with theme, viewport, text-scale and
/// inspector addons.
class SnippetsWidgetbookApp extends StatelessWidget {
  const SnippetsWidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light(useMaterial3: true)),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark(useMaterial3: true)),
          ],
        ),
        ViewportAddon(Viewports.all),
        TextScaleAddon(),
        GridAddon(),
        InspectorAddon(),
      ],
    );
  }
}
