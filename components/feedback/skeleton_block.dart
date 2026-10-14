// ignore_for_file: prefer_initializing_formals
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'shimmer.dart';

/// Leaf widget that paints one skeleton block without rebuilding per frame.
class SkeletonBlock extends LeafRenderObjectWidget {
  /// Paints a block of [width] x [height]; [widthFactor] sizes it as a share of the available width instead.
  const SkeletonBlock({
    required this.width,
    required this.height,
    required this.radius,
    required this.animation,
    required this.baseColor,
    required this.highlightColor,
    this.widthFactor,
    super.key,
  });

  /// Fixed width; null or infinite fills the available width.
  final double? width;

  /// Fixed height.
  final double height;

  /// Corner radius, capped at half the shortest side.
  final double radius;

  /// Repaint trigger; null paints the solid base colour.
  final Listenable? animation;

  /// Resting colour.
  final Color baseColor;

  /// Colour at the centre of the moving band.
  final Color highlightColor;

  /// Width as a fraction of the incoming max width; overrides [width].
  final double? widthFactor;

  @override
  RenderSkeletonBlock createRenderObject(BuildContext context) =>
      RenderSkeletonBlock(
        width: width,
        height: height,
        radius: radius,
        screenWidth: MediaQuery.sizeOf(context).width,
        animation: animation,
        baseColor: baseColor,
        highlightColor: highlightColor,
        widthFactor: widthFactor,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSkeletonBlock renderObject,
  ) {
    renderObject
      ..width = width
      ..height = height
      ..radius = radius
      ..screenWidth = MediaQuery.sizeOf(context).width
      ..animation = animation
      ..baseColor = baseColor
      ..highlightColor = highlightColor
      ..widthFactor = widthFactor;
  }
}

/// Render object behind [SkeletonBlock]: paints a rounded block whose shimmer band is positioned in screen space.
class RenderSkeletonBlock extends RenderBox {
  RenderSkeletonBlock({
    required double? width,
    required double height,
    required double radius,
    required double screenWidth,
    required Listenable? animation,
    required Color baseColor,
    required Color highlightColor,
    double? widthFactor,
  }) : _width = width,
       _widthFactor = widthFactor,
       _height = height,
       _radius = radius,
       _screenWidth = screenWidth,
       _animation = animation,
       _baseColor = baseColor,
       _highlightColor = highlightColor;

  double? _width;
  double? _widthFactor;
  double _height;
  double _radius;
  double _screenWidth;
  Listenable? _animation;
  Color _baseColor;
  Color _highlightColor;

  set baseColor(Color value) {
    if (_baseColor == value) return;
    _baseColor = value;
    markNeedsPaint();
  }

  set highlightColor(Color value) {
    if (_highlightColor == value) return;
    _highlightColor = value;
    markNeedsPaint();
  }

  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  set widthFactor(double? value) {
    if (_widthFactor == value) return;
    _widthFactor = value;
    markNeedsLayout();
  }

  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  set radius(double value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsPaint();
  }

  set screenWidth(double value) {
    if (_screenWidth == value) return;
    _screenWidth = value;
    markNeedsPaint();
  }

  set animation(Listenable? value) {
    if (_animation == value) return;
    if (attached) _animation?.removeListener(markNeedsPaint);
    _animation = value;
    if (attached) _animation?.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _animation?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(Size(_resolveWidth(constraints), _height));
  }

  double _resolveWidth(BoxConstraints constraints) {
    final factor = _widthFactor;
    if (factor != null) {
      if (!constraints.hasBoundedWidth) return 0;
      return factor * constraints.maxWidth;
    }
    final requested = _width;
    if (requested == null || requested.isInfinite) {
      return constraints.hasBoundedWidth
          ? constraints.maxWidth
          : constraints.minWidth;
    }
    return requested;
  }

  double get _minIntrinsicWidth => _widthFactor != null ? 0 : _fixedWidth;

  double get _maxIntrinsicWidth => _fixedWidth;

  double get _fixedWidth {
    final requested = _width;
    return requested == null || requested.isInfinite
        ? 0
        : math.max(0, requested);
  }

  @override
  double computeMinIntrinsicWidth(double height) => _minIntrinsicWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _maxIntrinsicWidth;

  @override
  double computeMinIntrinsicHeight(double width) => _height;

  @override
  double computeMaxIntrinsicHeight(double width) => _height;

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = (offset & size);
    final roundedRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(math.min(_radius, size.shortestSide / 2)),
    );
    final paint = Paint()..color = _baseColor;
    if (_animation != null && _screenWidth > 0) {
      final bandWidth = Shimmer.bandWidthFactor * _screenWidth;
      final bandCentre =
          -bandWidth / 2 + (_screenWidth + bandWidth) * Shimmer.phase;
      final globalLeft = localToGlobal(Offset.zero).dx;
      final bandLeft = bandCentre - bandWidth / 2 - globalLeft + offset.dx;
      final bandRect = Rect.fromLTWH(
        bandLeft,
        rect.top,
        bandWidth,
        size.height,
      );
      paint.shader = LinearGradient(
        begin: Alignment(-1, -0.25),
        end: Alignment(1, 0.25),
        colors: [_baseColor, _highlightColor, _baseColor],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bandRect);
    }
    context.canvas.drawRRect(roundedRect, paint);
  }
}
