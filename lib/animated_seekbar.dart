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

  bool loading;

  @override
  void initState() {
    loading = false;
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    )..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (dragUpdateDetails.localPosition.dx > 0 &&
              dragUpdateDetails.localPosition.dx < widget.size.width)
            setState(() {
//              updating = true;
              loading = true;
              progress = dragUpdateDetails.localPosition.dx;
              verticalDragOffset = dragUpdateDetails.localPosition.dy;
            });
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          _controller.forward().then((value) => _controller.reset());
//          _controller.reset();
        },
        child: AnimatedBuilder(
          animation: _seekbarAnimation,
          builder: (context, child) {
            print("value: ${(1 - _seekbarAnimation.value) * verticalDragOffset}");
            return CustomPaint(
              size: widget.size,
              painter: SeekBarPainter(
                progress: progress,
                width: widget.size.width,
                height: widget.size.height,
                verticalDragOffset: loading ? (1 - _seekbarAnimation.value) * verticalDragOffset : 0
              ),
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
