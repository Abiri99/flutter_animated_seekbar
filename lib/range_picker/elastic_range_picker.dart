import 'package:bouncyseekbar/range_picker/range_picker_painter.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class ElasticRangePicker extends StatefulWidget {
  final Size size;
  final Function(double firstVal, double secVal) valueListener;
  final double minValue;
  final double maxValue;

  // How much seek bar stretches in vertical axis
  final double stretchRange;

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

  ElasticRangePicker({
    this.size,
    this.valueListener,
    this.stretchRange = 100,
    this.minValue = 0,
    this.maxValue = 100,
    this.circleRadius = 12,
    this.thickLineStrokeWidth = 4,
    this.thinLineStrokeWidth = 3,
    this.thickLineColor,
    this.thinLineColor,
    this.bounceDuration,
  }) {
    if (thickLineColor == null) thickLineColor = Color(0xff1f3453);
    if (thinLineColor == null) thinLineColor = Colors.blueGrey;
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

  double firstVal;
  double secVal;

  // Old
  bool firstNodeTouched;
  bool secNodeTouched;

//  double firstNodeProgress;
//  double secNodeProgress;
//
//  double firstNodeVerticalOffset;
//  double secNodeVerticalOffset;

  AnimationController firstController;
  AnimationController secController;

//  AnimationController secondNodeController;

  Animation firstNodeAnimation;
  Animation secNodeAnimation;

  String getFirstValue() {
    if (firstThumbX <= trackStartX) return widget.minValue.toString();
    if (firstThumbX >= trackEndX) return widget.maxValue.toString();
    return (((firstThumbX - trackStartX) / (trackEndX - trackStartX)) *
            (widget.maxValue - widget.minValue))
        .toString();
  }

  String getSecValue() {
    if (secThumbX <= trackStartX) return widget.minValue.toString();
    if (secThumbX >= trackEndX) return widget.maxValue.toString();
    return (((secThumbX - trackStartX) / (trackEndX - trackStartX)) *
            (widget.maxValue - widget.minValue))
        .toString();
  }

  @override
  void initState() {
    firstThumbY = widget.size.height / 2;
    secThumbY = widget.size.height / 2;

    trackY = widget.size.height / 2;
    trackEndX = widget.size.width -
        widget.circleRadius -
        widget.thickLineStrokeWidth / 2;
    trackStartX = widget.circleRadius + widget.thickLineStrokeWidth / 2;
    firstThumbX = (trackEndX - trackStartX) / 3;
    secThumbX = 2 * (trackEndX - trackStartX) / 3;

    firstVal = double.parse(getFirstValue());
    secVal = double.parse(getSecValue());

    // Old
    firstNodeTouched = false;
    secNodeTouched = false;
//    firstNodeProgress = widget.size.width / 4;
//    secNodeProgress = 3 * widget.size.width / 4;
//    firstNodeVerticalOffset = widget.size.height / 2;
//    firstNodeVerticalOffset = 0;
//    secNodeVerticalOffset = widget.size.height / 2;
//    secNodeVerticalOffset = 0;

//    firstNodeController = AnimationController(
//      duration: Duration.zero,
//      reverseDuration: Duration(milliseconds: 1000),
//      vsync: this,
//    );
    firstController = AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration(milliseconds: 1000),
      vsync: this,
    );
    secController = AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration(milliseconds: 1000),
      vsync: this,
    );

    firstNodeAnimation = CurvedAnimation(
      parent: firstController,
      curve: Curves.elasticIn,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.completed) {}
      });
    secNodeAnimation = CurvedAnimation(
      parent: secController,
      curve: Curves.elasticIn,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.completed) {}
      });
    super.initState();
  }

  int detectNode(var gestureDetectorDetails) {
    if (firstNodeTouched) return 0;
    if (secNodeTouched) return 1;
//    return 1;
//    print("dy: ${gestureDetectorDetails.localPosition.dy}");
//    print("dx: ${gestureDetectorDetails.localPosition.dx}");
//    print("trackY: $trackY");
//    print("trackStartX: $trackStartX");
//    print("trackEndX: $trackEndX");
//    print("firstThumbY: $firstThumbY");
//    print("firstThumbX: $firstThumbX");
//    print("secThumbY: $secThumbY");
//    print("secThumbX: $secThumbX");
    if (gestureDetectorDetails.localPosition.dy >=
//            trackY -
            firstThumbY -
                widget.circleRadius -
                widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dy <=
//            trackY -
            firstThumbY +
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
      return 0;
    } else if (gestureDetectorDetails.localPosition.dy >=
//            trackY -
            secThumbY - widget.circleRadius - widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dy <=
//            trackY -
            secThumbY + widget.circleRadius + widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx >=
            secThumbX - widget.circleRadius - widget.thickLineStrokeWidth / 2 &&
        gestureDetectorDetails.localPosition.dx <=
            secThumbX + widget.circleRadius + widget.thickLineStrokeWidth / 2) {
      return 1;
    }
    return -1;
  }

  bool isInVerticalConstraint(var gestureDetectorDetails) {
    if (gestureDetectorDetails.localPosition.dy >= 0 &&
        gestureDetectorDetails.localPosition.dy <= widget.size.height) {
      return true;
    }
    return false;
  }

  bool isInHorizontalConstraint(var gestureDetectorDetails) {
    if (gestureDetectorDetails.localPosition.dx >= 0 &&
        gestureDetectorDetails.localPosition.dx <= widget.size.width) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Colors.green,
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) {
          var node = detectNode(tapDownDetails);
          print("node; $node");
          if (node == 0) {
            // THIS MEANS FIRST NODE IS TAPPED
            setState(() {
              firstNodeTouched = true;
              secNodeTouched = false;
            });
          } else if (node == 1) {
            // THIS MEANS SECOND NODE IS TOUCHED
            setState(() {
              firstNodeTouched = false;
              secNodeTouched = true;
            });
          }
        },
        onTapUp: (TapUpDetails tapUpDetails) {
          setState(() {
            firstNodeTouched = false;
            secNodeTouched = false;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          var node = detectNode(dragUpdateDetails);
          RenderBox box = context.findRenderObject();
          var touchPoint = box.globalToLocal(dragUpdateDetails.globalPosition);
          if (node == 0) {
            firstController.forward().then((value) {
              firstThumbX = touchPoint.dx.coerceHorizontal(
                  trackStartX,
                  trackEndX -
                      2 * widget.circleRadius -
                      widget.thickLineStrokeWidth -
                      widget.circleRadius -
                      widget.thickLineStrokeWidth / 2);
              if (touchPoint.dx >=
                  secThumbX -
                      widget.circleRadius -
                      widget.thickLineStrokeWidth / 2)
                secThumbX = touchPoint.dx.coerceHorizontal(
                    secThumbX,
                    trackEndX -
                        widget.circleRadius -
                        widget.thickLineStrokeWidth / 2);
              firstThumbY = (touchPoint.dy - widget.size.height / 2)
                  .coerceVertical(0, widget.stretchRange)
                  .coerceToStretchRange(
                      firstThumbX,
                      widget.size.height,
                      widget.size.width,
                      widget.stretchRange,
                      trackStartX,
                      trackEndX);

//              if (isInHorizontalConstraint(dragUpdateDetails)) {
//                firstNodeProgress = dragUpdateDetails.localPosition.dx;
//                if (firstNodeProgress > secNodeProgress)
//                  secNodeProgress = firstNodeProgress;
//              }
//              if (isInVerticalConstraint(dragUpdateDetails)) {
//                firstNodeVerticalOffset =
//                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
//              }
              setState(() {});
            });
          } else if (node == 1) {
            secController.forward().then((value) {
              secThumbX =
                  touchPoint.dx.coerceHorizontal(trackStartX, trackEndX);
              secThumbY = (touchPoint.dy - widget.size.height / 2)
                  .coerceVertical(0, widget.stretchRange)
                  .coerceToStretchRange(
                      secThumbX,
                      widget.size.height,
                      widget.size.width,
                      widget.stretchRange,
                      trackStartX,
                      trackEndX);
//              if (isInHorizontalConstraint(dragUpdateDetails)) {
//                secNodeProgress = dragUpdateDetails.localPosition.dx;
//                if (secNodeProgress < firstNodeProgress)
//                  firstNodeProgress = secNodeProgress;
//              }
//              if (isInVerticalConstraint(dragUpdateDetails)) {
//                secNodeVerticalOffset =
//                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
//              }
              setState(() {});
            });
          }
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          firstController.reverse().then((value) {
            firstThumbY = 0;
            secThumbY = 0;
//            firstNodeVerticalOffset = 0;
//            secNodeVerticalOffset = 0;
            firstController.reset();
          });
          secController.reverse().then((value) {
            firstThumbY = 0;
            secThumbY = 0;
//            firstNodeVerticalOffset = 0;
//            secNodeVerticalOffset = 0;
            secController.reset();
          });
          firstNodeTouched = false;
          secNodeTouched = false;
        },
        child: AnimatedBuilder(
          animation: firstNodeAnimation,
          builder: (context, child) {
            return AnimatedBuilder(
                animation: secNodeAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(
                      widget.size.width,
                      widget.size.height,
                    ),
                    painter: RangePickerPainter(
                      firstThumbX: firstThumbX,
                      firstThumbY: widget.size.height / 2 +
                          firstNodeAnimation.value * firstThumbY,
                      secThumbX: secThumbX,
                      secThumbY: widget.size.height / 2 +
                          secNodeAnimation.value * secThumbY,
                      circleRadius: 12,
                      thickLineStrokeWidth: 4,
                      thinLineStrokeWidth: 2,
                      width: widget.size.width,
                      height: widget.size.height,
                      firstNodeTouched: firstNodeTouched,
                      secNodeTouched: secNodeTouched,
                    ),
                  );
                },);
          },
        ),
      ),
    );
  }
}
