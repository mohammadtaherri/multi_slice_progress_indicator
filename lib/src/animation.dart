part of multi_slice_progress_indicator;

abstract class ProgressAnimation extends ProxyAnimation {
  ProgressAnimation([super.animation]);

  double of(int sliceIndex);
  double ofInnerSlice();
  double ofMiddleSlice();
  double ofOutterSlice();
}

class CurvedProgressAnimation extends ProgressAnimation {
  CurvedProgressAnimation({
    Animation<double> parent = kAlwaysDismissedAnimation,
    Curve innerSliceCurve = _defaultInnerSliceAnimationCurve,
    Curve middleSliceCurve = _defaultMiddleSliceAnimationCurve,
    Curve outterSliceCurve = _defaultOutterSliceAnimationCurve,
  })  : _innerSliceCurve = innerSliceCurve,
        _middleSliceCurve = middleSliceCurve,
        _outterSliceCurve = outterSliceCurve,
        super(parent);

  final List<double> _values = [0, 0, 0];
  final Curve _innerSliceCurve;
  final Curve _middleSliceCurve;
  final Curve _outterSliceCurve;

  @override
  double of(int sliceIndex) => _values[sliceIndex];

  @override
  double ofInnerSlice() => _values[0];

  @override
  double ofMiddleSlice() => _values[1];

  @override
  double ofOutterSlice() => _values[2];

  @override
  void notifyListeners() {
    _updateValues();
    super.notifyListeners();
  }

  void _updateValues() {
    if (_isReversing)
      _updateValuesWithFlippedCurves();
    else
      _updateValuesWithCurves();
  }

  bool get _isReversing => status == AnimationStatus.reverse;

  void _updateValuesWithFlippedCurves() {
    _values[0] = _transformValueWithCurve(_innerSliceCurve.flipped);
    _values[1] = _transformValueWithCurve(_middleSliceCurve.flipped);
    _values[2] = _transformValueWithCurve(_outterSliceCurve.flipped);
  }

  void _updateValuesWithCurves() {
    _values[0] = _transformValueWithCurve(_innerSliceCurve);
    _values[1] = _transformValueWithCurve(_middleSliceCurve);
    _values[2] = _transformValueWithCurve(_outterSliceCurve);
  }

  double _transformValueWithCurve(Curve curve) {
    return curve.transform(value);
  }
}

class ProgressController {
  ProgressController({
    required TickerProvider vsync,
    Duration forewardAnimationDuration = _defaultForewardAnimationDuration,
    Duration reverseAnimationDuration = _defaultReverseAnimationDuration,
    Duration completeAnimationDuration = _defaultCompleteAnimationDuration,
  })  : _animationController = AnimationController(
          vsync: vsync,
        ),
        _forewardAnimationDuration = forewardAnimationDuration,
        _reverseAnimationDuration = reverseAnimationDuration,
        _completeAnimationDuration = completeAnimationDuration,
        _startAngleProxyAnimation = CurvedProgressAnimation(),
        _successColorsOpacityProxyAnimation = CurvedProgressAnimation(),
        _failureColorsOpacityProxyAnimation = CurvedProgressAnimation();

  final AnimationController _animationController;
  final Duration _forewardAnimationDuration;
  final Duration _reverseAnimationDuration;
  final Duration _completeAnimationDuration;
  Completer? _runCompeleter;
  Completer? _stopCompleter;

  ProgressAnimation get startAngle => _startAngleProxyAnimation;
  final ProgressAnimation _startAngleProxyAnimation;

  ProgressAnimation get successColorsOpacity =>
      _successColorsOpacityProxyAnimation;
  final ProgressAnimation _successColorsOpacityProxyAnimation;

  ProgressAnimation get failureColorsOpacity =>
      _failureColorsOpacityProxyAnimation;
  final ProgressAnimation _failureColorsOpacityProxyAnimation;

  Future<void> start() async {
    if (!_canStart()) 
      return;

    _prepareToStart();
    await _repeatAnimation();
    _doAfterStop();
  }

  bool _canStart() => _runCompeleter == null;

  void _prepareToStart() {
    _runCompeleter = Completer();
    _updateAnimationDuration(_forewardAnimationDuration);

    _startAngleProxyAnimation.parent = _animationController;
    _successColorsOpacityProxyAnimation.parent = kAlwaysDismissedAnimation;
    _failureColorsOpacityProxyAnimation.parent = kAlwaysDismissedAnimation;
  }

  Future<void> _repeatAnimation() async {
    while (!_runCompeleter!.isCompleted) {
      await _forewardAnimation();
    }
  }

  void _doAfterStop() {
    _stopCompleter?.complete();
    _startAngleProxyAnimation.parent = kAlwaysCompleteAnimation;
  }

  Future<void> completeWithSuccess() async {
    if (!_canStop()) 
      return;

    await stop();
    _prepareToCompleteWithSuccess();
    await _forewardAnimation();
    _doAfterCompleteWithSuccess();
  }

  void _prepareToCompleteWithSuccess() {
    _updateAnimationDuration(_completeAnimationDuration);
    _successColorsOpacityProxyAnimation.parent = _animationController;
  }

  void _doAfterCompleteWithSuccess() {
    _successColorsOpacityProxyAnimation.parent = kAlwaysCompleteAnimation;
  }

  Future<void> completeWithFailure() async {
    if (!_canStop()) 
      return;

    await stop();
    _prepareToCompleteWithFailure();
    await _forewardAnimation();
    _doAfterCompleteWithFailure();
  }

  void _prepareToCompleteWithFailure() {
    _updateAnimationDuration(_completeAnimationDuration);
    _failureColorsOpacityProxyAnimation.parent = _animationController;
  }

  void _doAfterCompleteWithFailure() {
    _failureColorsOpacityProxyAnimation.parent = kAlwaysCompleteAnimation;
  }

  Future<void> _forewardAnimation() async {
    _animationController.reset();
    return _animationController.forward();
  }

  Future<void> stop() async {
    if (!_canStop()) 
      return;

    _runCompeleter!.complete();
    _stopCompleter = Completer();

    return _stopCompleter!.future;
  }

  bool _canStop() => !(_runCompeleter?.isCompleted ?? true);

  Future<void> reverse() async {
    if (!_canReverse()) 
      return;

    _prepareToReverse();
    await _reversAnimation();
    _refresh();
  }

  bool _canReverse() =>
      (_runCompeleter?.isCompleted ?? false) &&
      (_stopCompleter?.isCompleted ?? false);

  void _prepareToReverse() {
    _updateAnimationDuration(_reverseAnimationDuration);

    _startAngleProxyAnimation.parent = _animationController;

    if (_successColorsOpacityProxyAnimation.parent == kAlwaysCompleteAnimation)
      _successColorsOpacityProxyAnimation.parent = _animationController;

    if (_failureColorsOpacityProxyAnimation.parent == kAlwaysCompleteAnimation)
      _failureColorsOpacityProxyAnimation.parent = _animationController;
  }

  Future<void> _reversAnimation() async {
    _animationController.value = _animationController.upperBound;
    return _animationController.reverse();
  }

  void _refresh() {
    _startAngleProxyAnimation.parent = kAlwaysDismissedAnimation;
    _successColorsOpacityProxyAnimation.parent = kAlwaysDismissedAnimation;
    _failureColorsOpacityProxyAnimation.parent = kAlwaysDismissedAnimation;

    _runCompeleter = null;
    _stopCompleter = null;
  }

  void _updateAnimationDuration(Duration newDuration) {
    _animationController.duration = newDuration;
  }

  void dispose() {
    _animationController.dispose();
  }
}
