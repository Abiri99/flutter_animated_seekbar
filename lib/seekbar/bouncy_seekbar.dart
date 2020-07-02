import 'package:flutter/material.dart';
import 'package:bouncyseekbar/utils.dart';
import 'seekbar_painter.dart';

class BouncySeekbar extends StatefulWidget {
  final Function(String value) valueListener;
  final Size size;
  final double minValue;
  final double maxValue;

  final double stretchRange;

  double thickLineStrokeWidth;
  double thinLineStrokeWidth;

  double circleRadius;

  Color thickLineColor;
  Color thinLineColor;

  BouncySeekbar({
    @required this.valueListener,
    @required this.size,
    this.stretchRange = 100,
    this.minValue = 1,
    this.maxValue = 100,
    this.circleRadius = 12,
    this.thickLineStrokeWidth = 4,
    this.thinLineStrokeWidth = 3,
    this.thickLineColor,
    this.thinLineColor,
  }) {
    if (thickLineColor == null) thickLineColor = Color(0xff1f3453);
    if (thinLineColor == null) thinLineColor = Colors.blueGrey;
  }

  @override
  _BouncySeekbarState createState() => _BouncySeekbarState();
}

class _BouncySeekbarState extends State<BouncySeekbar>
    with SingleTickerProviderStateMixin {
  GlobalKey _key = GlobalKey();

  double value;

  double thumbY;
  double thumbX;

  double trackStartX;
  double trackEndX;

  AnimationController _controller;

  Animation _seekbarAnimation;

  bool touched;

  @override
  void initState() {
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//      getSizeAndPosition();
//    });
    touched = false;
    _controller = AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration(milliseconds: 1000),
      vsync: this,
//      value: 1,
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    )
      ..addListener(() {
//        print("anim val: ${_seekbarAnimation.value}");
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.completed) {}
      });
    value = (widget.maxValue - widget.minValue) / 2;
    thumbY = 0;
    thumbX = 0;
    trackEndX = widget.size.width -
        widget.circleRadius -
        widget.thickLineStrokeWidth / 2;
    trackStartX = widget.circleRadius + widget.thickLineStrokeWidth / 2;
    super.initState();
  }

  String getCurrentValue() {
    if (thumbX <= trackStartX) return widget.minValue.toString();
    if (thumbX >= trackEndX) return widget.maxValue.toString();
    return (((thumbX - trackStartX) / (trackEndX - trackStartX)).round() *
            (widget.maxValue - widget.minValue))
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Colors.grey,
//      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) {
          setState(() {
            touched = true;
          });
        },
        onTapUp: (TapUpDetails tapUpDetails) {
          setState(() {
            touched = false;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          RenderBox box = context.findRenderObject();
          var touchPoint = box.globalToLocal(dragUpdateDetails.globalPosition);

//          thumbX = (touchPoint.dx as double).coerceHorizontal(0, widget.size.width);
//          verticalDragOffset = (touchPoint.dy as double).coerceVertical(0, widget.size.height/2).co

//          if (touchPoint.dx > widget.size.width || touchPoint.dx < 0)
//            return;

//          print("touchpoint: ${touchPoint.dx}");
//          return;

          _controller.forward().then(
            (value) {
              thumbX = (dragUpdateDetails.localPosition.dx as double)
                  .coerceHorizontal(trackStartX, trackEndX);
              thumbY = (touchPoint.dy as double)
                  .coerceVertical(widget.size.height / 2, widget.stretchRange)
                  .coerceToStretchRange(
                      thumbX,
                      widget.size.height,
                      widget.size.width,
                      widget.stretchRange,
                      trackStartX,
                      trackEndX);
              widget.valueListener(getCurrentValue());

//              if (touchPoint.dx >=
//                      widget.circleRadius + widget.thickLineStrokeWidth / 2 &&
//                  touchPoint.dx <=
//                      widget.size.width -
//                          widget.circleRadius -
//                          widget.thickLineStrokeWidth / 2) {
//                progress = touchPoint.dx;
//                var value = (touchPoint.dx -
//                        widget.circleRadius -
//                        widget.thickLineStrokeWidth / 2) /
//                    (widget.size.width -
//                        2 *
//                            (widget.circleRadius -
//                                widget.thickLineStrokeWidth / 2)) *
//                    (widget.maxValue - widget.minValue);
//                widget.valueListener(value.toString());

//                widget.valueListener(((widget.maxValue - widget.minValue) *
//                        dragUpdateDetails.localPosition.dx /
//                        (widget.size.width -
//                            2 *
//                                (widget.thickLineStrokeWidth +
//                                    widget.circleRadius)))
//                    .toString());
//              }
//              if (dragUpdateDetails.localPosition.dy >= 0 &&
//                  dragUpdateDetails.localPosition.dy <= widget.size.height) {
//                verticalDragOffset =
//                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
//              }
//              setState(() {});
            },
          );
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          _controller.reverse().then((value) {
            thumbY = 0;
            _controller.reset();
          });
          touched = false;
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Container(color: Colors.green, child: Text(progress.toString(), style: TextStyle(fontSize: 20),)),
                CustomPaint(
                  key: _key,
                  size: Size(widget.size.width, widget.size.height),
                  painter: SeekBarPainter(
                    thumbX: thumbX,
                    thumbY: _seekbarAnimation.value * thumbY,
                    width: widget.size.width,
                    height: widget.size.height,
                    touched: touched,
//                    verticalDragOffset:
//                        _seekbarAnimation.value * verticalDragOffset,
                    thickLineColor: widget.thickLineColor,
                    thickLineStrokeWidth: widget.thickLineStrokeWidth,
                    thinLineColor: widget.thinLineColor,
                    thinLineStrokeWidth: widget.thinLineStrokeWidth,
                    circleRadius: widget.circleRadius,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
