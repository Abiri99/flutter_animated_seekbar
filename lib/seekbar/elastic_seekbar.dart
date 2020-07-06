import 'package:flutter/material.dart';
import 'seekbar_painter.dart';
import '../utils.dart';

// ignore: must_be_immutable
class ElasticSeekBar extends StatefulWidget {
  // Notifies parent of the current value
  final Function(String value) valueListener;
  // Size of seek bar
  final Size size;
  // Minimum value of seek bar
  final double minValue;
  // Maximum value of seek bar
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

  ElasticSeekBar({
    @required this.valueListener,
    @required this.size,
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
  _ElasticSeekBarState createState() => _ElasticSeekBarState();
}

class _ElasticSeekBarState extends State<ElasticSeekBar>
    with SingleTickerProviderStateMixin {
  GlobalKey _key = GlobalKey();

  double value;

  double thumbY;
  double thumbX;

  double trackStartX;
  double trackEndX;
  double trackY;

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
      reverseDuration: widget.bounceDuration ?? Duration(milliseconds: 800),
      vsync: this,
//      value: 1,
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    )
      ..addListener(() {
//        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.completed) {}
      });
    value = (widget.maxValue - widget.minValue) / 2;
    thumbY = widget.size.height / 2;
    thumbX = widget.size.width / 2;
    trackY = widget.size.height / 2;
    trackEndX = widget.size.width -
        widget.circleRadius -
        widget.thickLineStrokeWidth / 2;
    trackStartX = widget.circleRadius + widget.thickLineStrokeWidth / 2;
    super.initState();
  }

  String getCurrentValue() {
    if (thumbX <= trackStartX) return widget.minValue.toString();
    if (thumbX >= trackEndX) return widget.maxValue.toString();
    return (((thumbX - trackStartX) / (trackEndX - trackStartX)) *
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

          _controller.forward().then(
            (value) {
              thumbX = (dragUpdateDetails.localPosition.dx as double)
                  .coerceHorizontal(trackStartX, trackEndX);
              thumbY = (touchPoint.dy - widget.size.height / 2 as double)
                  .coerceVertical(0, widget.stretchRange)
                  .coerceToStretchRange(
                      thumbX,
                      widget.size.height,
                      widget.size.width,
                      widget.stretchRange,
                      trackStartX,
                      trackEndX);
              widget.valueListener(getCurrentValue());
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
                CustomPaint(
                  key: _key,
                  size: Size(widget.size.width, widget.size.height),
                  painter: SeekBarPainter(
                    thumbX: thumbX,
                    thumbY: widget.size.height/2 + _seekbarAnimation.value * thumbY,
                    width: widget.size.width,
                    height: widget.size.height,
                    touched: touched,
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
