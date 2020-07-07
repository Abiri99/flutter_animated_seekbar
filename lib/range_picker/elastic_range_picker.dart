import 'package:bouncyseekbar/range_picker/range_picker_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../utils.dart';

class ElasticRangePicker extends StatefulWidget {
  final Size size;
  final Function(double firstVal, double secVal) valueListener;
  final double minValue;
  final double maxValue;

  // How much seek bar stretches in vertical axis
  double stretchRange;

  // Thickness of progress line and thumb
  final double thickLineStrokeWidth;

  // Thickness of default line
  final double thinLineStrokeWidth;

  // Radius of thumb
  final double circleRadius;

  // Color of progress line and thumb
  Color thickLineColor;

  // Color of default line
  Color thinLineColor;

  // Speed of bouncing animation
  final Duration bounceDuration;

  final double stiffness;

  final double dampingRatio;

  ElasticRangePicker({
    this.size,
    this.valueListener,
    this.stretchRange,
    this.minValue = 0,
    this.maxValue = 100,
    this.circleRadius = 12,
    this.thickLineStrokeWidth = 4,
    this.thinLineStrokeWidth = 3,
    this.thickLineColor,
    this.thinLineColor,
    this.bounceDuration,
    this.stiffness = 300,
    this.dampingRatio = 8,
  }) {
    if (thickLineColor == null) thickLineColor = Color(0xff1f3453);
    if (thinLineColor == null) thinLineColor = Colors.blueGrey;
    if (stretchRange == null)
      stretchRange = size.height / 2 - circleRadius - thickLineStrokeWidth / 2;
  }

  @override
  _ElasticRangePickerState createState() => _ElasticRangePickerState();
}

class _ElasticRangePickerState extends State<ElasticRangePicker>
    with TickerProviderStateMixin {
  double firstThumbY;
  double firstThumbX;
  double secThumbY;
  double secThumbX;

  double trackStartX;
  double trackEndX;
  double trackY;

  double firstValue;
  double secondValue;

  bool firstNodeTouched;
  bool secNodeTouched;

  AnimationController _firstController;
  AnimationController _secondController;

  Animation<double> _firstAnimation;
  Animation<double> _secondAnimation;

  @override
  void initState() {
    _firstController = AnimationController(vsync: this, upperBound: 500);
    _secondController = AnimationController(vsync: this, upperBound: 500);

    _firstController.addListener(firstControllerListener);
    _secondController.addListener(secondControllerListener);

    firstNodeTouched = false;
    secNodeTouched = false;
    firstValue = (widget.maxValue - widget.minValue) / 3;
    secondValue = 2 * (widget.maxValue - widget.minValue) / 3;
    firstThumbY = 0;
    secThumbY = 0;
    firstThumbX = widget.size.width / 3;
    secThumbX = 2 * widget.size.width / 3;
    trackEndX = widget.size.width -
        widget.circleRadius -
        widget.thickLineStrokeWidth / 2;
    trackStartX = widget.circleRadius + widget.thickLineStrokeWidth / 2;
  }

  firstControllerListener() {
    setState(() {
      firstThumbY = _firstAnimation.value;
    });
  }

  secondControllerListener() {
    setState(() {
      secThumbY = _secondAnimation.value;
    });
  }

  double getFirstValue() {
    if (firstThumbX <= trackStartX) return widget.minValue;
    if (firstThumbX >= trackEndX) return widget.maxValue;
    return (((firstThumbX - trackStartX) / (trackEndX - trackStartX)) *
        (widget.maxValue - widget.minValue));
  }

  double getSecValue() {
    if (secThumbX <= trackStartX) return widget.minValue;
    if (secThumbX >= trackEndX) return widget.maxValue;
    return (((secThumbX - trackStartX) / (trackEndX - trackStartX)) *
        (widget.maxValue - widget.minValue));
  }

  runFirstThumbAnimation(Offset pixelsPerSecond, Size size) {
    _firstAnimation = _firstController.drive(Tween<double>(
      begin: firstThumbY,
      end: 0.0,
    ));
    var spring = SpringDescription(
      mass: 1.0,
      stiffness: widget.stiffness,
      damping: widget.dampingRatio,
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _firstController.animateWith(simulation);
  }

  runSecondThumbAnimation(Offset pixelsPerSecond, Size size) {
    _secondAnimation = _secondController.drive(Tween<double>(
      begin: secThumbY,
      end: 0.0,
    ));
    var spring = SpringDescription(
      mass: 1.0,
      stiffness: widget.stiffness,
      damping: widget.dampingRatio,
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _secondController.animateWith(simulation);
  }

  int detectNode(var gestureDetectorDetails) {
    if (firstNodeTouched) return 0;
    if (secNodeTouched) return 1;
    if (gestureDetectorDetails.localPosition.dy >=
//            trackY -
            widget.size.height / 2 -
                widget.circleRadius -
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dy <=
//            trackY -
            widget.size.height / 2 +
                widget.circleRadius +
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx >=
            firstThumbX -
                widget.circleRadius -
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx <=
            firstThumbX +
                widget.circleRadius +
                widget.thickLineStrokeWidth / 2) {
      print("touched first node");
      return 0;
    } else if (gestureDetectorDetails.localPosition.dy >=
//            trackY -
            widget.size.height / 2 -
                widget.circleRadius -
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dy <=
//            trackY -
            widget.size.height / 2 +
                widget.circleRadius +
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx >=
            secThumbX - widget.circleRadius - widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx <=
            secThumbX + widget.circleRadius + widget.thickLineStrokeWidth / 2) {
      print("touched sec node");
      return 1;
    }
    return -1;
  }

//  bool isInVerticalConstraint(var gestureDetectorDetails) {
//    if (gestureDetectorDetails.localPosition.dy >= 0 &&
//        gestureDetectorDetails.localPosition.dy <= widget.size.height) {
//      return true;
//    }
//    return false;
//  }
//
//  bool isInHorizontalConstraint(var gestureDetectorDetails) {
//    if (gestureDetectorDetails.localPosition.dx >= 0 &&
//        gestureDetectorDetails.localPosition.dx <= widget.size.width) {
//      return true;
//    }
//    return false;
//  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Colors.green,
      child: GestureDetector(
        onPanDown: (details) {
          var node = detectNode(details);
          if (node == 0) _firstController.stop();
          if (node == 1) _secondController.stop();
        },
        onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
//          RenderBox box = context.findRenderObject();
//          var touchPoint = box.globalToLocal(dragUpdateDetails.globalPosition);
          var node = detectNode(dragUpdateDetails);
          if (node == 0) {
            firstNodeTouched = true;
            setState(() {
              firstThumbX = dragUpdateDetails.localPosition.dx.coerceHorizontal(
                  trackStartX,
                  trackEndX -
                      2 *
                          (widget.circleRadius +
                              widget.thickLineStrokeWidth / 2));
              if (dragUpdateDetails.localPosition.dx >=
                  secThumbX -
                      widget.circleRadius -
                      widget.thickLineStrokeWidth / 2) {
                secThumbX = (dragUpdateDetails.localPosition.dx +
                        widget.circleRadius +
                        widget.thickLineStrokeWidth / 2)
                    .coerceHorizontal(
                        trackStartX +
                            2 *
                                (widget.circleRadius +
                                    widget.thickLineStrokeWidth / 2),
                        trackEndX);
              }
              firstThumbY =
                  (dragUpdateDetails.localPosition.dy - widget.size.height / 2)
                      .coerceVertical(
                          0,
                          widget.size.height / 2 -
                              widget.circleRadius -
                              widget.thickLineStrokeWidth / 2)
                      .coerceToStretchRange(
                          firstThumbX,
                          widget.size.height,
                          widget.size.width,
                          widget.stretchRange,
                          trackStartX,
                          trackEndX);
            });
            widget.valueListener(getFirstValue(), getSecValue());
          } else if (node == 1) {
            secNodeTouched = true;
            setState(() {
              secThumbX = dragUpdateDetails.localPosition.dx.coerceHorizontal(
                  trackStartX +
                      2 *
                          (widget.circleRadius +
                              widget.thickLineStrokeWidth / 2),
                  trackEndX);
              if (dragUpdateDetails.localPosition.dx <=
                  firstThumbX +
                      widget.circleRadius +
                      widget.thickLineStrokeWidth / 2) {
                firstThumbX = (dragUpdateDetails.localPosition.dx -
                        widget.circleRadius -
                        widget.thickLineStrokeWidth / 2)
                    .coerceHorizontal(
                        trackStartX,
                        trackEndX -
                            2 *
                                (widget.circleRadius +
                                    widget.thickLineStrokeWidth / 2));
              }
              secThumbY =
                  (dragUpdateDetails.localPosition.dy - widget.size.height / 2)
                      .coerceVertical(
                          0,
                          widget.size.height / 2 -
                              widget.circleRadius -
                              widget.thickLineStrokeWidth / 2)
                      .coerceToStretchRange(
                          secThumbX,
                          widget.size.height,
                          widget.size.width,
                          widget.stretchRange,
                          trackStartX,
                          trackEndX);
            });
            widget.valueListener(getFirstValue(), getSecValue());
          }
        },
        onPanEnd: (DragEndDetails dragEndDetails) {
          runFirstThumbAnimation(dragEndDetails.velocity.pixelsPerSecond, size);
          runSecondThumbAnimation(
              dragEndDetails.velocity.pixelsPerSecond, size);
          setState(() {
            firstNodeTouched = false;
            secNodeTouched = false;
          });
        },
        child: CustomPaint(
          size: Size(
            widget.size.width,
            widget.size.height,
          ),
          painter: RangePickerPainter(
            firstThumbX: firstThumbX,
            firstThumbY: firstThumbY,
            secThumbX: secThumbX,
            secThumbY: secThumbY,
            circleRadius: 12,
            thickLineStrokeWidth: 4,
            thinLineStrokeWidth: 2,
            width: widget.size.width,
            height: widget.size.height,
            firstNodeTouched: firstNodeTouched,
            secNodeTouched: secNodeTouched,
          ),
        ),
      ),
    );
  }
}
