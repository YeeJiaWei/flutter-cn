import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/chips/chip.dart';
import '../../store/chips/tag_list.dart';

/// "Default" use case for [SelectableChip].
Widget selectableChipUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Filter');
  final selected = context.knobs.boolean(label: 'Selected');
  final withIcon = context.knobs.boolean(label: 'With icon', initialValue: true);
  return Center(
    child: SelectableChip(
      label: label,
      selected: selected,
      icon: withIcon ? Icons.local_offer_outlined : null,
      onTap: () {},
    ),
  );
}

/// "Default" use case for [TagList].
Widget tagListUseCase(BuildContext context) {
  final multi = context.knobs.boolean(label: 'Multi-select', initialValue: true);
  return _TagListDemo(multi: multi);
}

class _TagListDemo extends StatefulWidget {
  const _TagListDemo({required this.multi});

  final bool multi;

  @override
  State<_TagListDemo> createState() => _TagListDemoState();
}

class _TagListDemoState extends State<_TagListDemo> {
  Set<String> _selected = {'Design'};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TagList(
        options: const ['Design', 'Engineering', 'Marketing', 'Sales'],
        selected: _selected,
        multi: widget.multi,
        onChanged: (next) => setState(() => _selected = next),
      ),
    );
  }
}

/// The chips component group, mirroring `chips/`.
final chipComponents = [
  WidgetbookComponent(
    name: 'SelectableChip',
    useCases: [WidgetbookUseCase(name: 'Default', builder: selectableChipUseCase)],
  ),
  WidgetbookComponent(
    name: 'TagList',
    useCases: [WidgetbookUseCase(name: 'Default', builder: tagListUseCase)],
  ),
];
