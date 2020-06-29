import 'package:flutter/material.dart';

import 'SeekBarPainter.dart';

class AnimatedSeekbar extends StatefulWidget {
  final Size size;

  AnimatedSeekbar({
    @required this.size,
  });

  @override
  _AnimatedSeekbarState createState() => _AnimatedSeekbarState();
}

class _AnimatedSeekbarState extends State<AnimatedSeekbar>
    with SingleTickerProviderStateMixin {
  double progress;

  double verticalDragOffset;
  double horizontalDragOffset;

  AnimationController _controller;

  Animation _seekbarAnimation;

  bool loading;

  bool touched;

  @override
  void initState() {
    touched = false;
    loading = false;
    _controller = AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration(milliseconds: 500),
      vsync: this,
//      value: 1,
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    )
      ..addListener(() {
//        print("controller value: ${_controller.value}");
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
//        _controller.forward();
        } else if (status == AnimationStatus.completed) {
          setState(() {
            loading = false;
          });
//        _controller.reverse();
//        setState(() {
//          verticalDragOffset = 0;
//        });
        }
      });
//    _controller.forward();
    progress = widget.size.width / 2;
    verticalDragOffset = 0;
    horizontalDragOffset = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.blue,
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
            setState(() {
              progress = dragUpdateDetails.localPosition.dx;
              verticalDragOffset = dragUpdateDetails.localPosition.dy - widget.size.height / 2;
            });
          });


//          if (dragUpdateDetails.localPosition.dx > 9 &&
//              dragUpdateDetails.localPosition.dx < widget.size.width - 9
//          ) {
//            _controller.forward().then((value) => {});
//            setState(() {
////              _controller.forward();
////              loading = true;
//              progress = dragUpdateDetails.localPosition.dx;
//              horizontalDragOffset = dragUpdateDetails.localPosition.dx;
//            });
//          }
//          if (dragUpdateDetails.localPosition.dy < widget.size.height / 2 &&
//              dragUpdateDetails.localPosition.dy > -widget.size.height / 2) {
//            setState(() {
//              print("dy: ${dragUpdateDetails.localPosition.dy}");
//              verticalDragOffset = dragUpdateDetails.localPosition.dy;
//            });
//          }
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
//          loading = false;
//          touched = false;
          _controller.reverse().then((value) {
//            print("controller value after revert: ${_controller.value}");
//            loading = false;
            touched = false;
            verticalDragOffset = 0;
            _controller.reset();
//            print("controller value after reset: ${_controller.value}");
          });
        },
        child: AnimatedBuilder(
          animation: _seekbarAnimation,
          builder: (context, child) {
            print("value: ${_seekbarAnimation.value}");
            print(
                "offset: $verticalDragOffset");
            return CustomPaint(
              size: widget.size,
              painter: SeekBarPainter(
                progress: progress,
//                  progress: progress + (horizontalDragOffset - progress) * _seekbarAnimation.value,
                  width: widget.size.width,
                  height: widget.size.height,
                  touched: touched,
//                verticalDragOffset: loading ? (1 - _seekbarAnimation.value) * verticalDragOffset : 0
                  verticalDragOffset:
                      _seekbarAnimation.value * verticalDragOffset),
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
