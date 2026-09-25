import 'package:flutter/material.dart';

/// Wizard progress bar rendered as connected segments.
class ProgressStepper extends StatelessWidget {
  const ProgressStepper({
    required this.currentStep,
    required this.totalSteps,
    this.showLabel = true,
    this.activeColor = const Color(0xFF156EFC),
    this.inactiveColor = const Color(0xFFF3F5F9),
    super.key,
  });

  final int currentStep;
  final int totalSteps;
  final bool showLabel;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    assert(totalSteps > 0, 'totalSteps must be > 0');
    final clamped = currentStep.clamp(0, totalSteps);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            'Step $clamped of $totalSteps',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: List.generate(totalSteps, (i) {
            final isActive = i < clamped;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 4),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
