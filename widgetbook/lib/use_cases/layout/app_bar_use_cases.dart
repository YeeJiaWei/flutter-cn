import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/app_bar.dart';

/// "Default" use case for [TopBar], shown inside a [Scaffold] so its app-bar
/// geometry and optional progress bar render as they would on a real page.
Widget topBarUseCase(BuildContext context) {
  final title = context.knobs.stringOrNull(label: 'Title', initialValue: 'Account details');
  final showBack = context.knobs.boolean(label: 'Show back', initialValue: true);
  final showProgress = context.knobs.boolean(label: 'Show progress');
  final currentStep = context.knobs.int.slider(
    label: 'Current step',
    initialValue: 2,
    min: 0,
    max: 5,
  );
  final totalSteps = context.knobs.int.slider(
    label: 'Total steps',
    initialValue: 4,
    min: 1,
    max: 6,
  );
  return Scaffold(
    appBar: TopBar(
      title: title,
      showBack: showBack,
      currentStep: showProgress ? currentStep : null,
      totalSteps: showProgress ? totalSteps : null,
    ),
    body: const SizedBox.shrink(),
  );
}

/// The app-bar component group, mirroring `layout/app_bar.dart`.
final appBarComponents = [
  WidgetbookComponent(
    name: 'TopBar',
    useCases: [WidgetbookUseCase(name: 'Default', builder: topBarUseCase)],
  ),
];
