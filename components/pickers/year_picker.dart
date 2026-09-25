import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button.dart';

/// Bottom-sheet single-column year wheel picker with a column header,
/// styled to match [showDobPicker]. Returns the chosen year, or null if
/// dismissed. Years are listed newest-first.
Future<int?> showYearPicker({
  required BuildContext context,
  required String title,
  required int initial,
  required int min,
  required int max,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _YearSheet(title: title, initial: initial, min: min, max: max),
  );
}

class _YearSheet extends StatefulWidget {
  const _YearSheet({
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
  State<_YearSheet> createState() => _YearSheetState();
}

class _YearSheetState extends State<_YearSheet> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.clamp(widget.min, widget.max);
  }

  /// Years from newest to oldest, so the current year sits at the top.
  List<int> get _years =>
      List.generate(widget.max - widget.min + 1, (i) => widget.max - i);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = _years;
    final selectedIndex = years.indexOf(_year).clamp(0, years.length - 1);
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
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: _HeaderLabel('Year'),
          ),
          SizedBox(
            height: 196,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Selection band, matching the DOB picker.
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
                  child: _wheel(
                    count: years.length,
                    selected: selectedIndex,
                    label: (i) => '${years[i]}',
                    onChanged: (i) => setState(() => _year = years[i]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: PrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.of(context).pop(_year),
            ),
          ),
        ],
      ),
    );
  }

  static const double _itemExtent = 40;

  Widget _wheel({
    required int count,
    required int selected,
    required String Function(int) label,
    required ValueChanged<int> onChanged,
  }) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF0B1220),
          fontWeight: FontWeight.w500,
        );
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: selected),
      itemExtent: _itemExtent,
      squeeze: 1.05,
      diameterRatio: 1.4,
      selectionOverlay: const SizedBox.shrink(),
      onSelectedItemChanged: onChanged,
      children: List.generate(count, (i) => Center(child: Text(label(i), style: style))),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF7E8A9A),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
    );
  }
}
