import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/list_tile.dart';

/// "Default" use case for [InfoListTile].
Widget infoListTileUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Notifications');
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Push, email and SMS',
  );
  final dense = context.knobs.boolean(label: 'Dense');
  final tappable = context.knobs.boolean(label: 'Tappable', initialValue: true);
  return Center(
    child: SizedBox(
      width: 360,
      child: InfoListTile(
        title: title,
        subtitle: subtitle,
        dense: dense,
        leadingIcon: Icons.notifications_outlined,
        onTap: tappable ? () {} : null,
      ),
    ),
  );
}

/// The list-tile component group, mirroring `layout/list_tile.dart`.
final listTileComponents = [
  WidgetbookComponent(
    name: 'InfoListTile',
    useCases: [WidgetbookUseCase(name: 'Default', builder: infoListTileUseCase)],
  ),
];
