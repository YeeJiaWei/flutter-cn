import 'package:flutter/material.dart';

/// Visual style for a [TabList]: an underline strip or a pill segmented
/// control.
enum TabListVariant { underline, pill }

/// Controlled root that shares the selected tab [value] with its [TabList],
/// [TabContent] and [TabPages] descendants. The caller owns [value] and
/// updates it in [onChanged].
class Tabs<T> extends StatelessWidget {
  const Tabs({
    required this.value,
    required this.onChanged,
    required this.child,
    super.key,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final Widget child;

  /// Returns the nearest [TabsScope] of type [T].
  static TabsScope<T> of<T>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TabsScope<T>>();
    assert(scope != null, 'Tabs.of<$T>() called with no Tabs<$T> ancestor');
    return scope!;
  }

  @override
  Widget build(BuildContext context) {
    return TabsScope<T>(value: value, onChanged: onChanged, child: child);
  }
}

/// Inherited scope a [Tabs] publishes: the selected value and its change
/// handler. Read it with `Tabs.of<T>(context)`.
class TabsScope<T> extends InheritedWidget {
  const TabsScope({
    required this.value,
    required this.onChanged,
    required super.child,
    super.key,
  });

  final T value;
  final ValueChanged<T> onChanged;

  /// Whether [candidate] is the selected value.
  bool isSelected(T candidate) => candidate == value;

  /// Selects [candidate] through the caller's change handler.
  void select(T candidate) => onChanged(candidate);

  @override
  bool updateShouldNotify(covariant TabsScope<T> oldWidget) =>
      oldWidget.value != value;
}

/// Row of [TabItem]s styled as an underline strip or a pill segmented
/// control. The non-scrollable pill draws one selected background that
/// slides to the selected tab. Must sit under a [Tabs].
class TabList extends StatelessWidget {
  const TabList({
    required this.children,
    this.variant = TabListVariant.underline,
    this.scrollable = false,
    this.padding,
    this.indicatorColor = const Color(0xFF156EFC),
    this.indicatorDecoration,
    this.activeLabelColor,
    this.inactiveLabelColor,
    this.labelStyle,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFA9A9A9),
    this.trackRadius = const BorderRadius.all(Radius.circular(12)),
    this.indicatorRadius = const BorderRadius.all(Radius.circular(8)),
    this.trackShadow = const [
      BoxShadow(color: Color(0x0F0B1220), blurRadius: 16, offset: Offset(0, 4)),
    ],
    this.tabHeight = 45,
    this.duration = const Duration(milliseconds: 250),
    super.key,
  });

  final List<Widget> children;
  final TabListVariant variant;

  /// Sizes tabs to their content and scrolls horizontally. A scrollable pill
  /// falls back to a per-tab background, since slot widths are unknown.
  final bool scrollable;

  /// Defaults to none for underline and 4 for pill.
  final EdgeInsetsGeometry? padding;

  /// Underline bar colour, and the pill's selected background colour.
  final Color indicatorColor;

  /// Replaces the pill's selected background (e.g. a gradient or image).
  final Decoration? indicatorDecoration;

  /// Defaults to [indicatorColor] for underline and white for pill.
  final Color? activeLabelColor;

  /// Defaults to a muted grey for underline and near-black for pill.
  final Color? inactiveLabelColor;
  final TextStyle? labelStyle;

  /// Pill track colour.
  final Color backgroundColor;

  /// Underline strip's bottom border colour.
  final Color borderColor;
  final BorderRadius trackRadius;
  final BorderRadius indicatorRadius;
  final List<BoxShadow> trackShadow;

  /// Pill tab height.
  final double tabHeight;

  /// Indicator slide and label colour transition time.
  final Duration duration;

  bool get _slidingIndicator => variant == TabListVariant.pill && !scrollable;

  @override
  Widget build(BuildContext context) {
    final spacing = variant == TabListVariant.pill ? 4.0 : 0.0;

    final row = scrollable
        ? Row(spacing: spacing, children: children)
        : Row(
            spacing: spacing,
            children: [for (final child in children) Expanded(child: child)],
          );

    final content = scrollable
        ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: row)
        : row;

    final scoped = _TabListScope(
      list: this,
      slidingIndicator: _slidingIndicator,
      child: content,
    );

    switch (variant) {
      case TabListVariant.underline:
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: scoped),
        );
      case TabListVariant.pill:
        return Container(
          padding: padding ?? const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: trackRadius,
            boxShadow: trackShadow,
          ),
          child: _slidingIndicator
              ? _withSlidingIndicator(context, spacing, scoped)
              : scoped,
        );
    }
  }

  /// Stacks one selected background behind the tabs, sized to a tab slot and
  /// moved to the selected tab's index.
  Widget _withSlidingIndicator(
    BuildContext context,
    double spacing,
    Widget tabs,
  ) {
    final selectedIndex = children.indexWhere(
      (child) => child is TabItem && child.isSelectedIn(context),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth =
            (constraints.maxWidth - spacing * (children.length - 1)) /
                children.length;

        return Stack(
          children: [
            if (selectedIndex >= 0)
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeOutCubic,
                top: 0,
                bottom: 0,
                left: selectedIndex * (slotWidth + spacing),
                width: slotWidth,
                child: DecoratedBox(
                  decoration: indicatorDecoration ??
                      BoxDecoration(
                        color: indicatorColor,
                        borderRadius: indicatorRadius,
                      ),
                ),
              ),
            tabs,
          ],
        );
      },
    );
  }
}

/// Passes the enclosing [TabList] down to each [TabItem].
class _TabListScope extends InheritedWidget {
  const _TabListScope({
    required this.list,
    required this.slidingIndicator,
    required super.child,
  });

  final TabList list;

  /// True when the list draws the shared sliding background, so each
  /// [TabItem] must not draw its own.
  final bool slidingIndicator;

  static _TabListScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TabListScope>();

  @override
  bool updateShouldNotify(covariant _TabListScope oldWidget) =>
      oldWidget.list != list || oldWidget.slidingIndicator != slidingIndicator;
}

/// One selectable tab inside a [TabList], styled per the list's variant.
/// Supply exactly one of [label] or [child]. Named `TabItem` to avoid
/// clashing with Flutter's own [Tab] widget.
class TabItem<T> extends StatelessWidget {
  const TabItem({
    required this.value,
    this.label,
    this.child,
    this.icon,
    this.badge,
    super.key,
  }) : assert(
          (label == null) != (child == null),
          'TabItem requires exactly one of label or child',
        );

  final T value;
  final String? label;
  final Widget? child;
  final Widget? icon;

  /// Trailing widget, usually a [TabBadge].
  final Widget? badge;

  /// Whether this tab is the enclosing [Tabs]' selected value.
  bool isSelectedIn(BuildContext context) =>
      Tabs.of<T>(context).isSelected(value);

  @override
  Widget build(BuildContext context) {
    final tabs = Tabs.of<T>(context);
    final listScope = _TabListScope.of(context);
    final list = listScope?.list ?? const TabList(children: []);
    final selected = tabs.isSelected(value);

    final content = _TabSelectionScope(
      selected: selected,
      child: _content(context, list, selected),
    );

    switch (list.variant) {
      case TabListVariant.underline:
        return InkWell(
          onTap: () => tabs.select(value),
          child: AnimatedContainer(
            duration: list.duration,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: selected ? list.indicatorColor : Colors.transparent,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        );
      case TabListVariant.pill:
        final drawsOwnIndicator =
            selected && !(listScope?.slidingIndicator ?? false);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => tabs.select(value),
          child: AnimatedContainer(
            duration: list.duration,
            height: list.tabHeight,
            alignment: Alignment.center,
            decoration: drawsOwnIndicator
                ? (list.indicatorDecoration ??
                    BoxDecoration(
                      color: list.indicatorColor,
                      borderRadius: list.indicatorRadius,
                    ))
                : null,
            child: content,
          ),
        );
    }
  }

  /// Builds the icon, label and badge row with the variant's text style.
  Widget _content(BuildContext context, TabList list, bool selected) {
    final textStyle = list.variant == TabListVariant.underline
        ? _underlineTextStyle(context, list, selected)
        : _pillTextStyle(list, selected);

    final labelWidget = AnimatedDefaultTextStyle(
      duration: list.duration,
      style: textStyle,
      child: child ?? Text(label!),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: 4)],
        labelWidget,
        if (badge != null) ...[const SizedBox(width: 4), badge!],
      ],
    );
  }

  /// Label style for the underline variant.
  TextStyle _underlineTextStyle(
    BuildContext context,
    TabList list,
    bool selected,
  ) {
    final base = list.labelStyle ??
        Theme.of(context).textTheme.labelLarge ??
        const TextStyle(fontSize: 14);
    return base.copyWith(
      color: selected
          ? (list.activeLabelColor ?? list.indicatorColor)
          : (list.inactiveLabelColor ?? const Color(0xFF5A616D)),
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
    );
  }

  /// Label style for the pill variant.
  TextStyle _pillTextStyle(TabList list, bool selected) {
    final base = list.labelStyle ?? const TextStyle(fontSize: 14);
    return base.copyWith(
      color: selected
          ? (list.activeLabelColor ?? Colors.white)
          : (list.inactiveLabelColor ?? const Color(0xFF0B1220)),
      fontWeight: FontWeight.w700,
    );
  }
}

/// Exposes whether the nearest [TabItem] is selected, so its badge can flip
/// colours.
class _TabSelectionScope extends InheritedWidget {
  const _TabSelectionScope({required this.selected, required super.child});

  final bool selected;

  static bool? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_TabSelectionScope>()
      ?.selected;

  @override
  bool updateShouldNotify(covariant _TabSelectionScope oldWidget) =>
      oldWidget.selected != selected;
}

/// Small circular count shown in a [TabItem]'s badge slot. Inside a tab it
/// flips colours automatically when that tab is selected; elsewhere pass
/// [selected].
class TabBadge extends StatelessWidget {
  const TabBadge({
    required this.count,
    this.selected = false,
    this.color = const Color(0xFF156EFC),
    this.textColor = Colors.white,
    this.selectedColor = Colors.white,
    this.selectedTextColor = const Color(0xFF156EFC),
    super.key,
  });

  final int count;

  /// Used only outside a [TabItem].
  final bool selected;
  final Color color;
  final Color textColor;
  final Color selectedColor;
  final Color selectedTextColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = _TabSelectionScope.maybeOf(context) ?? selected;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          color: isSelected ? selectedTextColor : textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Panel shown only while its [value] is the enclosing [Tabs]' selected
/// value. Use for static switching; use [TabPages] for swipeable panels.
class TabContent<T> extends StatelessWidget {
  const TabContent({
    required this.value,
    required this.child,
    this.keepAlive = false,
    super.key,
  });

  final T value;
  final Widget child;

  /// Keeps an unselected panel mounted (offstage) instead of discarding it.
  final bool keepAlive;

  @override
  Widget build(BuildContext context) {
    if (Tabs.of<T>(context).isSelected(value)) return child;
    if (keepAlive) {
      return Offstage(
        offstage: true,
        child: TickerMode(enabled: false, child: child),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Swipeable [PageView] synced to the enclosing [Tabs]: swiping selects the
/// page's value, and selecting a tab jumps straight to its page. Give it a
/// bounded height (e.g. inside `Expanded`).
class TabPages<T> extends StatefulWidget {
  const TabPages({
    required this.values,
    required this.children,
    this.physics,
    super.key,
  }) : assert(
          values.length == children.length,
          'values and children must match',
        );

  final List<T> values;
  final List<Widget> children;
  final ScrollPhysics? physics;

  @override
  State<TabPages<T>> createState() => _TabPagesState<T>();
}

class _TabPagesState<T> extends State<TabPages<T>> {
  late PageController _pageController;
  bool _initialised = false;

  /// Set while a tab tap jumps the pager, whose synchronous onPageChanged
  /// would otherwise re-select mid-build.
  bool _jumping = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final index = widget.values.indexOf(Tabs.of<T>(context).value);
    final target = index < 0 ? 0 : index;

    if (!_initialised) {
      _initialised = true;
      _pageController = PageController(initialPage: target);
      return;
    }

    // Jump, not animate: scrolling through in-between pages fires
    // onPageChanged for each, which flicks the tab selection through them.
    if (_pageController.hasClients && _pageController.page?.round() != target) {
      _jumping = true;
      _pageController.jumpToPage(target);
      _jumping = false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = Tabs.of<T>(context);
    return PageView.builder(
      controller: _pageController,
      physics: widget.physics,
      onPageChanged: (index) {
        if (!_jumping) tabs.select(widget.values[index]);
      },
      itemCount: widget.children.length,
      itemBuilder: (_, index) => widget.children[index],
    );
  }
}
