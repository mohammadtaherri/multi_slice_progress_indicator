part of multi_slice_progress_indicator;

class MultiSliceProgressIndicator extends LeafRenderObjectWidget {
  const MultiSliceProgressIndicator({
    super.key,
    this.radius = _defaultRadius,
    this.background = _defaultBackground,
    this.colors = _defaultColors,
    this.successColors = _defaultSuccessColors,
    this.failureColors = _defaultFailureColors,
    this.colorStops = _defaultColorStops,
    required this.controller,
  });

  final double radius;
  final Color background;
  final List<Color> colors;
  final List<Color> successColors;
  final List<Color> failureColors;
  final List<double> colorStops;
  final ProgressController controller;

  @override
  RenderMultiSliceProgressIndicator createRenderObject(BuildContext context) {
    return RenderMultiSliceProgressIndicator(
      radius: radius,
      background: background,
      colors: colors,
      successColors: successColors,
      suceessColorsOpacity: controller.successColorsOpacity,
      failureColors: failureColors,
      failureColorsOpacity: controller.failureColorsOpacity,
      colorStops: colorStops,
      startAngle: controller.startAngle,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMultiSliceProgressIndicator renderObject,
  ) {
    renderObject.radius = radius;
    renderObject.background = background;
    renderObject.colors = colors;
    renderObject.successColors = successColors;
    renderObject.successColorsOpacity = controller.successColorsOpacity;
    renderObject.failureColors = failureColors;
    renderObject.failureColorsOpacity = controller.failureColorsOpacity;
    renderObject.colorStops = colorStops;
    renderObject.startAngle = controller.startAngle;
  }
}
