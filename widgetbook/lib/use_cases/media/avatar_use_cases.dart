import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/media/avatar.dart';

/// "Default" use case for [Avatar].
Widget avatarUseCase(BuildContext context) {
  final name = context.knobs.string(label: 'Name', initialValue: 'Jane Doe');
  final size = context.knobs.object.dropdown<AvatarSize>(
    label: 'Size',
    options: AvatarSize.values,
    initialOption: AvatarSize.lg,
    labelBuilder: (v) => v.name,
  );
  final withImage = context.knobs.boolean(label: 'With network image');
  return Center(
    child: Avatar(
      name: name,
      size: size,
      imageUrl: withImage ? 'https://picsum.photos/seed/avatar/200' : null,
    ),
  );
}

/// The avatar component group, mirroring `media/avatar.dart`.
final avatarComponents = [
  WidgetbookComponent(
    name: 'Avatar',
    useCases: [WidgetbookUseCase(name: 'Default', builder: avatarUseCase)],
  ),
];
