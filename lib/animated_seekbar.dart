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

  AnimationController _controller;

  Animation _seekbarAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    )..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _controller.forward();
      } else if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    _controller.forward();
    progress = widget.size.width / 2;
    verticalDragOffset = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: GestureDetector(
//        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
//          if (dragUpdateDetails.localPosition.dx > 0 &&
//              dragUpdateDetails.localPosition.dx < widget.size.width)
//            setState(() {
////              updating = true;
//              progress = dragUpdateDetails.localPosition.dx;
//              verticalDragOffset = dragUpdateDetails.localPosition.dy;
//            });
//        },
//        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
//          _controller.forward();
//        },
        child: AnimatedBuilder(
          animation: _seekbarAnimation,
          builder: (context, child) {
            print("value: ${_seekbarAnimation.value * 100}");
            return CustomPaint(
              size: widget.size,
              painter: SeekBarPainter(
                progress: progress,
                width: widget.size.width,
                height: widget.size.height,
                verticalDragOffset: _seekbarAnimation.value * 100
              ),
            );
          },
        ),
      ),
    );
//    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
