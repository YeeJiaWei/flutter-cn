import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button.dart';

/// Bottom-sheet single-column wheel picker for height in centimetres.
/// Returns the chosen value, or null if dismissed.
Future<int?> showHeightPicker({
  required BuildContext context,
  required String title,
  required int initial,
  int min = 140,
  int max = 220,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _HeightSheet(title: title, initial: initial, min: min, max: max),
  );
}

class _HeightSheet extends StatefulWidget {
  const _HeightSheet({
    required this.title,
    required this.initial,
    required this.min,
    required this.max,
  });

  final String title;
  final int initial;
  final int min;
  final int max;

  @override
  State<_HeightSheet> createState() => _HeightSheetState();
}

class _HeightSheetState extends State<_HeightSheet> {
  static const double _itemExtent = 40;

  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium?.copyWith(
      color: const Color(0xFF0B1220),
      fontWeight: FontWeight.w500,
    );
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title, style: theme.textTheme.titleLarge),
            ),
          ),
          SizedBox(
            height: 196,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    height: _itemExtent,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: _value - widget.min),
                    itemExtent: _itemExtent,
                    squeeze: 1.05,
                    diameterRatio: 1.4,
                    selectionOverlay: const SizedBox.shrink(),
                    onSelectedItemChanged: (i) => setState(() => _value = widget.min + i),
                    children: List.generate(
                      widget.max - widget.min + 1,
                      (i) => Center(child: Text('${widget.min + i}', style: style)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: PrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.of(context).pop(_value),
            ),
          ),
        ],
      ),
    );
  }
}
