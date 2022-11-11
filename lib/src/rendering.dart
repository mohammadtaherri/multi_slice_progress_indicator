part of multi_slice_progress_indicator;

class RenderMultiSliceProgressIndicator extends RenderBox {
  RenderMultiSliceProgressIndicator({
    required double radius,
    required Color background,
    required List<Color> colors,
    required List<Color> successColors,
    required ProgressAnimation suceessColorsOpacity,
    required List<Color> failureColors,
    required ProgressAnimation failureColorsOpacity,
    required List<double> colorStops,
    required ProgressAnimation startAngle,
  })  : _radius = radius,
        _background = background,
        _colors = colors,
        _successColorsOpacity = suceessColorsOpacity,
        _successColors = successColors,
        _failureColors = failureColors,
        _failureColorsOpacity = failureColorsOpacity,
        _colorStops = colorStops,
        _startAngle = startAngle;

  late Canvas _canvas;
  late double _sliceStrokeWidth;
  bool _spinnerSlicesShouldBeDrawn = false;
  bool _successSlicesShouldBeDrawn = false;
  bool _failureSlicesShouldBeDrawn = false;

  double get radius => _radius;
  double _radius;
  set radius(double value) {
    if (_radius == value) 
      return;

    _radius = value;
    markNeedsLayout();
  }

  Color get background => _background;
  Color _background;
  set background(Color value) {
    if (_background == value) 
      return;

    _background = value;
    markNeedsPaint();
  }

  List<Color> get colors => _colors;
  List<Color> _colors;
  set colors(List<Color> value) {
    if (_colors == value) 
      return;

    _colors = value;
    markNeedsPaint();
  }

  List<Color> get successColors => _successColors;
  List<Color> _successColors;
  set successColors(List<Color> value) {
    if (_successColors == value) 
      return;

    _successColors = value;
    markNeedsPaint();
  }

  ProgressAnimation get successColorsOpacity => _successColorsOpacity;
  ProgressAnimation _successColorsOpacity;
  set successColorsOpacity(ProgressAnimation value) {
    if (_successColorsOpacity == value) 
      return;

    if (attached) 
      _successColorsOpacity.removeListener(_animationsUpdated);

    _successColorsOpacity = value;

    if (attached) 
      _successColorsOpacity.addListener(_animationsUpdated);

    _animationsUpdated();
  }

  List<Color> get failureColors => _failureColors;
  List<Color> _failureColors;
  set failureColors(List<Color> value) {
    if (_failureColors == value) 
      return;

    _failureColors = value;
    markNeedsPaint();
  }

  ProgressAnimation get failureColorsOpacity => _failureColorsOpacity;
  ProgressAnimation _failureColorsOpacity;
  set failureColorsOpacity(ProgressAnimation value) {
    if (_failureColorsOpacity == value) 
      return;

    if (attached) 
      _failureColorsOpacity.removeListener(_animationsUpdated);

    _failureColorsOpacity = value;

    if (attached) 
      _failureColorsOpacity.addListener(_animationsUpdated);

    _animationsUpdated();
  }

  List<double> get colorStops => _colorStops;
  List<double> _colorStops;
  set colorStops(List<double> value) {
    if (_colorStops == value) 
      return;

    _colorStops = value;
    markNeedsPaint();
  }

  ProgressAnimation get startAngle => _startAngle;
  ProgressAnimation _startAngle;
  set startAngle(ProgressAnimation value) {
    if (_startAngle == value) 
      return;

    if (attached) 
      _startAngle.removeListener(_animationsUpdated);

    _startAngle = value;

    if (attached) 
      _startAngle.addListener(_animationsUpdated);

    _animationsUpdated();
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _successColorsOpacity.addListener(_animationsUpdated);
    _failureColorsOpacity.addListener(_animationsUpdated);
    _startAngle.addListener(_animationsUpdated);

    _animationsUpdated();
  }

  @override
  void detach() {
    _successColorsOpacity.removeListener(_animationsUpdated);
    _failureColorsOpacity.removeListener(_animationsUpdated);
    _startAngle.removeListener(_animationsUpdated);
    super.detach();
  }

  void _animationsUpdated() {
    _updateDrawnFlags();
    markNeedsPaint();
  }

  void _updateDrawnFlags() {
    _successSlicesShouldBeDrawn =
        successColorsOpacity.status != AnimationStatus.dismissed;

    _failureSlicesShouldBeDrawn =
        failureColorsOpacity.status != AnimationStatus.dismissed;

    _spinnerSlicesShouldBeDrawn =
        successColorsOpacity.status != AnimationStatus.completed &&
            failureColorsOpacity.status != AnimationStatus.completed;
  }

  @override
  double computeMinIntrinsicWidth(double height) => radius * 2;

  @override
  double computeMaxIntrinsicWidth(double height) => radius * 2;

  @override
  double computeMinIntrinsicHeight(double width) => radius * 2;

  @override
  double computeMaxIntrinsicHeight(double width) => radius * 2;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(Size(radius * 2, radius * 2));
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size(radius * 2, radius * 2));
  }

  @override
  double? computeDistanceToActualBaseline(ui.TextBaseline baseline) => null;

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    _canvas = context.canvas;
    _sliceStrokeWidth = math.min(size.width, size.height) / 6;

    _trnasformCanvas(offset);
    _drawIndicator();
    _restoreCanvas();
  }

  void _trnasformCanvas(ui.Offset topLeft) {
    _canvas.translate(
        topLeft.dx + size.width / 2, topLeft.dy + size.height / 2);
    _canvas.rotate(math.pi / 2);
    _canvas.save();
  }

  void _drawIndicator() {
    _drawBackground();
    _drawSlices();
  }

  void _drawBackground() {
    _canvas.drawCircle(
      Offset.zero,
      _sliceStrokeWidth * 3,
      Paint()..color = background,
    );
  }

  void _drawSlices() {
    if (_spinnerSlicesShouldBeDrawn)
       _drawSpinnerSlices();

    if (_successSlicesShouldBeDrawn) 
      _drawSuccessSlices();

    if (_failureSlicesShouldBeDrawn)
      _drawFailureSlices();
  }

  void _drawSpinnerSlices() {
    _drawInnerSlice(
      colors,
      startAngle.ofInnerSlice().multiplyBy2Pi,
    );

    _drawMiddleSlice(
      colors,
      startAngle.ofMiddleSlice().multiplyBy2Pi,
    );

    _drawOutterSlice(
      colors,
      startAngle.ofOutterSlice().multiplyBy2Pi,
    );
  }

  void _drawSuccessSlices() {
    _drawInnerSlice(
      successColors.mapWithOpacity(successColorsOpacity.ofInnerSlice()),
    );

    _drawMiddleSlice(
      successColors.mapWithOpacity(successColorsOpacity.ofMiddleSlice()),
    );

    _drawOutterSlice(
      successColors.mapWithOpacity(successColorsOpacity.ofOutterSlice()),
    );
  }

  void _drawFailureSlices() {
    _drawInnerSlice(
      failureColors.mapWithOpacity(failureColorsOpacity.ofInnerSlice()),
    );

    _drawMiddleSlice(
      failureColors.mapWithOpacity(failureColorsOpacity.ofMiddleSlice()),
    );

    _drawOutterSlice(
      failureColors.mapWithOpacity(failureColorsOpacity.ofOutterSlice()),
    );
  }

  void _drawInnerSlice(List<Color> colors, [double startAngle = 0]) {
    _drawStrokedCircle(
      radius: _sliceStrokeWidth * 0.5,
      colors: colors,
      startAngle: startAngle,
    );
  }

  void _drawMiddleSlice(List<Color> colors, [double startAngle = 0]) {
    _drawStrokedCircle(
      radius: _sliceStrokeWidth * 1.5,
      colors: colors,
      startAngle: startAngle,
    );
  }

  void _drawOutterSlice(List<Color> colors, [double startAngle = 0]) {
    _drawStrokedCircle(
      radius: _sliceStrokeWidth * 2.5,
      colors: colors,
      startAngle: startAngle,
    );
  }

  void _drawStrokedCircle({
    required double radius,
    required List<Color> colors,
    double startAngle = 0,
  }) {
    _canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = _sliceStrokeWidth + 1
        ..shader = ui.Gradient.sweep(
          Offset.zero,
          colors,
          colorStops,
          TileMode.repeated,
          startAngle,
          math.pi * 2 + startAngle,
        ),
    );
  }

  void _restoreCanvas() {
    _canvas.restore();
  }
}

extension DoubleEx on double {
  double get multiplyBy2Pi => this * math.pi * 2;
}

extension ColorsListEx on List<Color> {
  List<Color> mapWithOpacity(double opacity) {
    return map((c) => c.withOpacity(opacity)).toList();
  }
}
