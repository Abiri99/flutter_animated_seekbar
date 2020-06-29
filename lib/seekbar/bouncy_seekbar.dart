import 'package:flutter/material.dart';

import 'seekbar_painter.dart';

class BouncySeekbar extends StatefulWidget {
  final Function(String value) valueListener;
  final Size size;

//  final SeekBarType seekBarType;

  BouncySeekbar({
    @required this.valueListener,
    @required this.size,
//    this.seekBarType = SeekBarType.Default,
  });

  @override
  _BouncySeekbarState createState() => _BouncySeekbarState();
}

class _BouncySeekbarState extends State<BouncySeekbar>
    with SingleTickerProviderStateMixin {
  double progress;

  double verticalDragOffset;
  double horizontalDragOffset;

  AnimationController _controller;

  Animation _seekbarAnimation;

  bool touched;

  @override
  void initState() {
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
      color: Colors.red,
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
          _controller.forward().then((value) {
            if (dragUpdateDetails.localPosition.dx >= 9 &&
                dragUpdateDetails.localPosition.dx <= widget.size.width - 9) {
//              setState(() {
              progress = dragUpdateDetails.localPosition.dx;
              widget.valueListener(progress.toString());
//                verticalDragOffset =
//                    dragUpdateDetails.localPosition.dy - widget.size.height / 2;
//              });
            }
            if (dragUpdateDetails.localPosition.dy >= 0 &&
                dragUpdateDetails.localPosition.dy <= widget.size.height) {
              verticalDragOffset =
                  dragUpdateDetails.localPosition.dy - widget.size.height / 2;
            }
            setState(() {});
          });
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
            print("value: ${_seekbarAnimation.value}");
            print("offset: $verticalDragOffset");
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Container(color: Colors.green, child: Text(progress.toString(), style: TextStyle(fontSize: 20),)),
                CustomPaint(
                  size: Size(widget.size.width, widget.size.height),
//                  size: widget.size,
                  painter: SeekBarPainter(
                      progress: progress,
                      width: widget.size.width,
                      height: widget.size.height,
                      touched: touched,
                      verticalDragOffset:
                          _seekbarAnimation.value * verticalDragOffset),
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
