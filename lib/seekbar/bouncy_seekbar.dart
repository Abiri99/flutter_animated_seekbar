import 'package:flutter/material.dart';

import 'seekbar_painter.dart';

class BouncySeekbar extends StatefulWidget {
  final Function(String value) valueListener;
  final Size size;
  final double minValue;
  final double maxValue;

  double thickLineStrokeWidth;
  double thinLineStrokeWidth;

  double circleRadius;

  Color thickLineColor;
  Color thinLineColor;

  BouncySeekbar({
    @required this.valueListener,
    @required this.size,
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

  double progress;

  double verticalDragOffset;
  double horizontalDragOffset;

  AnimationController _controller;

  Animation _seekbarAnimation;

  bool touched;

  getSizeAndPosition() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    print("render size: ${renderBox.size}");
    print("render position: ${renderBox.localToGlobal(Offset.zero)}");
  }

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
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.completed) {}
      });
    progress = widget.size.width / 2;
    verticalDragOffset = 0;
    horizontalDragOffset = 0;
    super.initState();
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

          if (touchPoint.dx > widget.size.width || touchPoint.dx < 0)
//            return;

          print("touchpoint: ${touchPoint.dx}");
//          return;

          _controller.forward().then(
            (value) {
//            print("dx: ${dragUpdateDetails.localPosition.dx}");
//              if (dragUpdateDetails.localPosition.dx > widget.size.width)
//                return;
//            if (dragUpdateDetails.localPosition.dy > widget.size.height)
//              return;

              if (touchPoint.dx >= widget.circleRadius + widget.thickLineStrokeWidth/2 && touchPoint.dx <= widget.size.width - widget.circleRadius - widget.thickLineStrokeWidth/2) {
                progress = touchPoint.dx;
                var value = (touchPoint.dx - widget.circleRadius - widget.thickLineStrokeWidth/2) / (widget.size.width - 2*(widget.circleRadius - widget.thickLineStrokeWidth/2)) * (widget.maxValue - widget.minValue);
                widget.valueListener(value.toString());
//                widget.valueListener(((widget.maxValue - widget.minValue) *
//                        dragUpdateDetails.localPosition.dx /
//                        (widget.size.width -
//                            2 *
//                                (widget.thickLineStrokeWidth +
//                                    widget.circleRadius)))
//                    .toString());
              }
              if (dragUpdateDetails.localPosition.dy >= 0 &&
                  dragUpdateDetails.localPosition.dy <= widget.size.height) {
                verticalDragOffset =
                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
              }
              setState(() {});
            },
          );
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          _controller.reverse().then((value) {
            verticalDragOffset = 0;
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
                    progress: progress,
                    width: widget.size.width,
                    height: widget.size.height,
                    touched: touched,
                    verticalDragOffset:
                        _seekbarAnimation.value * verticalDragOffset,
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
