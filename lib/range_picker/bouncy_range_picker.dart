import 'package:bouncyseekbar/range_picker/range_picker_painter.dart';
import 'package:flutter/material.dart';

class BouncyRangePikcer extends StatefulWidget {
  final Size size;
  final Function(double firstVal, double secVal) rangeListener;

  BouncyRangePikcer({
    this.size,
    this.rangeListener,
  });

  @override
  _BouncyRangePikcerState createState() => _BouncyRangePikcerState();
}

class _BouncyRangePikcerState extends State<BouncyRangePikcer>
    with SingleTickerProviderStateMixin {
  bool firstNodeTouched;
  bool secNodeTouched;

  double firstNodeProgress;
  double secNodeProgress;

  double firstNodeVerticalOffset;
  double secNodeVerticalOffset;

  AnimationController controller;

//  AnimationController secondNodeController;

  Animation firstNodeAnimation;
  Animation secNodeAnimation;

  @override
  void initState() {
    firstNodeTouched = false;
    secNodeTouched = false;
    firstNodeProgress = widget.size.width / 4;
    secNodeProgress = 3 * widget.size.width / 4;
//    firstNodeVerticalOffset = widget.size.height / 2;
    firstNodeVerticalOffset = 0;
//    secNodeVerticalOffset = widget.size.height / 2;
    secNodeVerticalOffset = 0;

//    firstNodeController = AnimationController(
//      duration: Duration.zero,
//      reverseDuration: Duration(milliseconds: 1000),
//      vsync: this,
//    );
    controller = AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration(milliseconds: 1000),
      vsync: this,
    );

    firstNodeAnimation = CurvedAnimation(
      parent: controller,
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
      parent: controller,
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
    if (firstNodeTouched)
      return 0;
    if (secNodeTouched)
      return 1;
//    return 1;
    if (gestureDetectorDetails.localPosition.dy >=
            widget.size.height / 2 + firstNodeVerticalOffset - 12 &&
        gestureDetectorDetails.localPosition.dy <=
            widget.size.height / 2 + firstNodeVerticalOffset + 12 &&
        gestureDetectorDetails.localPosition.dx >= firstNodeProgress - 12 &&
        gestureDetectorDetails.localPosition.dx <= firstNodeProgress + 12) {
      return 0;
    } else if (gestureDetectorDetails.localPosition.dy >=
            widget.size.height / 2 + secNodeVerticalOffset - 12 &&
        gestureDetectorDetails.localPosition.dy <=
            widget.size.height / 2 + secNodeVerticalOffset + 12 &&
        gestureDetectorDetails.localPosition.dx >= secNodeProgress - 12 &&
        gestureDetectorDetails.localPosition.dx <= secNodeProgress + 12) {
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
          if (node == 0) {
            controller.forward().then((value) {
              if (isInHorizontalConstraint(dragUpdateDetails)) {
                firstNodeProgress = dragUpdateDetails.localPosition.dx;
                if (firstNodeProgress > secNodeProgress)
                  secNodeProgress = firstNodeProgress;
              }
              if (isInVerticalConstraint(dragUpdateDetails)) {
                firstNodeVerticalOffset =
                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
              }
              setState(() {});
            });
          } else if (node == 1) {
            controller.forward().then((value) {
              if (isInHorizontalConstraint(dragUpdateDetails)) {
                secNodeProgress = dragUpdateDetails.localPosition.dx;
                if (secNodeProgress < firstNodeProgress)
                  firstNodeProgress = secNodeProgress;
              }
              if (isInVerticalConstraint(dragUpdateDetails)) {
                secNodeVerticalOffset =
                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
              }
              setState(() {});
            });
          }
        },

        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          controller.reverse().then((value) {
            firstNodeVerticalOffset = 0;
            secNodeVerticalOffset = 0;
            controller.reset();
          });
          firstNodeTouched = false;

//          controller.reverse().then((value) {
//            secNodeVerticalOffset = 0;
//            controller.reset();
//          });
          secNodeTouched = false;
        },

        child: AnimatedBuilder(
          animation: firstNodeAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: Size(
                widget.size.width,
                widget.size.height,
              ),
              painter: RangePickerPainter(
                width: widget.size.width,
                height: widget.size.height,
                firstNodeTouched: firstNodeTouched,
                secNodeTouched: secNodeTouched,
                firstNodeProgress: firstNodeProgress,
                secNodeProgress: secNodeProgress,
                firstNodeVerticalOffset:
                    firstNodeAnimation.value * firstNodeVerticalOffset,
                secNodeVerticalOffset:
                    secNodeAnimation.value * secNodeVerticalOffset,
              ),
            );
          },
        ),

//        child: AnimatedBuilder(
//          animation: _seekbarAnimation,
//          builder: (context, child) {
//            print("value: ${_seekbarAnimation.value}");
//            print("offset: $verticalDragOffset");
//            return Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
////                Container(color: Colors.green, child: Text(progress.toString(), style: TextStyle(fontSize: 20),)),
//                CustomPaint(
//                  size: Size(widget.size.width, widget.size.height),
////                  size: widget.size,
//                  painter: SeekBarPainter(
//                      progress: progress,
//                      width: widget.size.width,
//                      height: widget.size.height,
//                      touched: touched,
//                      verticalDragOffset:
//                          _seekbarAnimation.value * verticalDragOffset),
//                ),
//              ],
//            );
//          },
//        ),
      ),
    );
  }
}
