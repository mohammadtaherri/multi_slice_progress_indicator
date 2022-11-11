part of multi_slice_progress_indicator;

const _defaultForewardAnimationDuration = Duration(milliseconds: 2000);
const _defaultReverseAnimationDuration = Duration(milliseconds: 2000);
const _defaultCompleteAnimationDuration = Duration(milliseconds: 1000);

const _defaultInnerSliceAnimationCurve = Interval(0, 0.5);
const _defaultMiddleSliceAnimationCurve = Interval(0.25, 0.75);
const _defaultOutterSliceAnimationCurve = Interval(0.45, 0.95);

const _defaultRadius = 42.0;

const _defaultBackground = Color(0xFFF5F5F5);

const _defaultColors = <Color>[
  Color(0xFF37474F), //800
  Color(0xFF455A64), //700
  Color(0xFF607D8B), //500
  Color(0xFF78909C), //400
  Color(0xFF90A4AE), //300
  Color(0xFFB0BEC5), //200
  Color(0xFFECEFF1), //50
];

const _defaultSuccessColors = <Color>[
  // Colors.lightGreen,
  Color(0xFF00838F), //800
  Color(0xFF0097A7), //700
  Color(0xFF00BCD4), //500
  Color(0xFF26C6DA), //400
  Color(0xFF4DD0E1), //300
  Color(0xFF80DEEA), //200
  Color(0xFFE0F7FA), //50
];

const _defaultFailureColors = <Color>[
  Color(0xFFC62828), //800
  Color(0xFFD32F2F), //700
  Color(0xFFF44336), //500
  Color(0xFFEF5350), //400
  Color(0xFFE57373), //300
  Color(0xFFEF9A9A), //200
  Color(0xFFFFEBEE), //50
];

const _defaultColorStops = <double>[0.25, 0.35, 0.5, 0.65, 0.8, 0.9, 0.97];
