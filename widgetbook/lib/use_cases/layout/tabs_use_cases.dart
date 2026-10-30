import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/tabs.dart';

/// "Default" use case for [TabList] with [TabItem]s.
Widget tabListUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<TabListVariant>(
    label: 'Variant',
    options: TabListVariant.values,
    initialOption: TabListVariant.pill,
    labelBuilder: (variant) => variant.name,
  );
  final count = context.knobs.int.slider(
    label: 'Tabs',
    initialValue: 3,
    min: 2,
    max: 5,
  );
  final scrollable = context.knobs.boolean(label: 'Scrollable');
  final withBadges = context.knobs.boolean(label: 'With badges');
  return _TabsDemo(
    variant: variant,
    count: count,
    scrollable: scrollable,
    withBadges: withBadges,
    withPages: false,
  );
}

/// "With pages" use case: a [TabList] driving swipeable [TabPages].
Widget tabPagesUseCase(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Tabs',
    initialValue: 3,
    min: 2,
    max: 5,
  );
  return _TabsDemo(
    variant: TabListVariant.pill,
    count: count,
    scrollable: false,
    withBadges: false,
    withPages: true,
  );
}

class _TabsDemo extends StatefulWidget {
  const _TabsDemo({
    required this.variant,
    required this.count,
    required this.scrollable,
    required this.withBadges,
    required this.withPages,
  });

  final TabListVariant variant;
  final int count;
  final bool scrollable;
  final bool withBadges;
  final bool withPages;

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  static const _labels = ['Upcoming', 'Pending', 'Past', 'Reviewed', 'Archived'];
  static const _colors = [
    Color(0xFFFEE2E2),
    Color(0xFFDBEAFE),
    Color(0xFFDCFCE7),
    Color(0xFFFEF3C7),
    Color(0xFFEDE9FE),
  ];

  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final values = List.generate(widget.count, (index) => index);
    final value = _value < widget.count ? _value : 0;

    return Tabs<int>(
      value: value,
      onChanged: (next) => setState(() => _value = next),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TabList(
              variant: widget.variant,
              scrollable: widget.scrollable,
              children: [
                for (final index in values)
                  TabItem<int>(
                    value: index,
                    label: _labels[index],
                    badge: widget.withBadges
                        ? TabBadge(count: index + 1)
                        : null,
                  ),
              ],
            ),
            if (widget.withPages)
              Expanded(
                child: TabPages<int>(
                  values: values,
                  children: [
                    for (final index in values)
                      ColoredBox(
                        color: _colors[index],
                        child: Center(child: Text(_labels[index])),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The tabs component group, from `layout/tabs.dart`.
final tabsComponents = [
  WidgetbookComponent(
    name: 'Tabs',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: tabListUseCase),
      WidgetbookUseCase(name: 'With pages', builder: tabPagesUseCase),
    ],
  ),
];
