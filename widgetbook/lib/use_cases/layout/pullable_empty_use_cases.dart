import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/empty_state.dart';
import '../../store/layout/pullable_empty.dart';

/// "Default" use case for [PullableEmpty], wrapping an [EmptyState] inside
/// a [RefreshIndicator] to show the pull-to-refresh gesture still works.
Widget pullableEmptyUseCase(BuildContext context) {
  return SizedBox(
    height: 420,
    child: RefreshIndicator(
      onRefresh: () async => Future.delayed(const Duration(milliseconds: 600)),
      child: const PullableEmpty(
        child: EmptyState(
          title: 'No results',
          subtitle: 'Pull down to refresh.',
        ),
      ),
    ),
  );
}

/// The pullable-empty component group, mirroring `layout/pullable_empty.dart`.
final pullableEmptyComponents = [
  WidgetbookComponent(
    name: 'PullableEmpty',
    useCases: [WidgetbookUseCase(name: 'Default', builder: pullableEmptyUseCase)],
  ),
];
