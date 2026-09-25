import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../store/feedback/rating_stars.dart';

/// "Default" use case for [RatingStars]. Interactive so the tap-to-rate
/// gesture can be tried; toggled off shows the read-only rendering.
Widget ratingStarsUseCase(BuildContext context) {
  final rating = context.knobs.double.slider(
    label: 'Rating',
    initialValue: 3.5,
    min: 0,
    max: 5,
  );
  final interactive = context.knobs.boolean(label: 'Interactive');
  final size = context.knobs.double.input(label: 'Size', initialValue: 24);
  return Center(
    child: RatingStars(
      rating: rating,
      size: size,
      onChanged: interactive ? (_) {} : null,
    ),
  );
}

/// The rating-stars component group, mirroring `feedback/rating_stars.dart`.
final ratingStarsComponents = [
  WidgetbookComponent(
    name: 'RatingStars',
    useCases: [WidgetbookUseCase(name: 'Default', builder: ratingStarsUseCase)],
  ),
];
