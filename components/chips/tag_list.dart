import 'package:flutter/material.dart';

import 'chip.dart';

/// Wrap of [SelectableChip] with single- or multi-select support.
class TagList extends StatelessWidget {
  const TagList({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multi = true,
    this.spacing = 8,
    this.runSpacing = 8,
    super.key,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final bool multi;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return SelectableChip(
          label: opt,
          selected: isSelected,
          onTap: () {
            final next = Set<String>.from(selected);
            if (multi) {
              if (isSelected) {
                next.remove(opt);
              } else {
                next.add(opt);
              }
            } else {
              next
                ..clear()
                ..add(opt);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}
