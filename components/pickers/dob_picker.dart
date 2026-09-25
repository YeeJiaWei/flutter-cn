import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Bottom-sheet day/month/year wheel picker with column headers.
/// Returns the chosen date, or null if dismissed.
Future<DateTime?> showDobPicker({
  required BuildContext context,
  required String title,
  required DateTime initial,
  required DateTime min,
  required DateTime max,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _DobSheet(title: title, initial: initial, min: min, max: max),
  );
}

class _DobSheet extends StatefulWidget {
  const _DobSheet({
    required this.title,
    required this.initial,
    required this.min,
    required this.max,
  });

  final String title;
  final DateTime initial;
  final DateTime min;
  final DateTime max;

  @override
  State<_DobSheet> createState() => _DobSheetState();
}

class _DobSheetState extends State<_DobSheet> {
  late int _year;
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year;
    _month = widget.initial.month;
    _day = widget.initial.day;
  }

  int get _firstYear => widget.min.year;
  int get _lastYear => widget.max.year;
  int get _daysInMonth => DateTime(_year, _month + 1, 0).day;

  DateTime get _selected {
    final clampedDay = _day > _daysInMonth ? _daysInMonth : _day;
    final picked = DateTime(_year, _month, clampedDay);
    if (picked.isBefore(widget.min)) return widget.min;
    if (picked.isAfter(widget.max)) return widget.max;
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            child: Row(
              children: [
                Expanded(flex: 5, child: _HeaderLabel('Month')),
                Expanded(flex: 3, child: _HeaderLabel('Day')),
                Expanded(flex: 4, child: _HeaderLabel('Year')),
              ],
            ),
          ),
          SizedBox(
            height: 196,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Single continuous selection band spanning all columns.
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _wheel(
                          count: 12,
                          selected: _month - 1,
                          label: (i) => _monthNames[i],
                          onChanged: (i) => setState(() => _month = i + 1),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: _wheel(
                          key: ValueKey('day-$_year-$_month'),
                          count: _daysInMonth,
                          selected: (_day > _daysInMonth ? _daysInMonth : _day) - 1,
                          label: (i) => '${i + 1}',
                          onChanged: (i) => setState(() => _day = i + 1),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: _wheel(
                          count: _lastYear - _firstYear + 1,
                          selected: _year - _firstYear,
                          label: (i) => '${_firstYear + i}',
                          onChanged: (i) => setState(() => _year = _firstYear + i),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: PrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.of(context).pop(_selected),
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
    Key? key,
  }) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF0B1220),
          fontWeight: FontWeight.w500,
        );
    return CupertinoPicker(
      key: key,
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
