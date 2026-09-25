import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/layout/progress_stepper.dart';

/// "Default" use case for [ProgressStepper].
Widget progressStepperUseCase(BuildContext context) {
  final totalSteps = context.knobs.int.slider(
    label: 'Total steps',
    initialValue: 4,
    min: 1,
    max: 8,
  );
  final currentStep = context.knobs.int.slider(
    label: 'Current step',
    initialValue: 2,
    min: 0,
    max: 8,
  );
  final showLabel = context.knobs.boolean(label: 'Show label', initialValue: true);
  return Center(
    child: SizedBox(
      width: 320,
      child: ProgressStepper(
        currentStep: currentStep.clamp(0, totalSteps),
        totalSteps: totalSteps,
        showLabel: showLabel,
      ),
    ),
  );
}

/// The progress-stepper component group, mirroring `layout/progress_stepper.dart`.
final progressStepperComponents = [
  WidgetbookComponent(
    name: 'ProgressStepper',
    useCases: [WidgetbookUseCase(name: 'Default', builder: progressStepperUseCase)],
  ),
];
