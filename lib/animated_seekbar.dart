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

class _AnimatedSeekbarState extends State<AnimatedSeekbar> with SingleTickerProviderStateMixin {
  double progress;

  double verticalDragOffset;

  AnimationController _controller;

  Animation _seekbarAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 5), vsync: this);
    _seekbarAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );
    progress = widget.size.width / 2;
//    verticalDragOffset = Offset.zero;
    verticalDragOffset = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return GestureDetector(
//      onHorizontalDragStart: (DragStartDetails dragStartDetails) {
//        if (dragStartDetails.localPosition.dx > 0 && dragStartDetails.localPosition.dx < widget.size.width)
//          setState(() {
//            progress = dragStartDetails.localPosition.dx;
//            verticalDragOffset = dragStartDetails.localPosition.dy;
//          });
//      },
//      onVerticalDragStart: (DragStartDetails dragStartDetails) {
//        if (dragStartDetails.localPosition.dy < widget.size.height && dragStartDetails.localPosition.dy > 0)
//          setState(() {
//            progress = dragStartDetails.localPosition.dx;
//            verticalDragOffset = dragStartDetails.localPosition.dy;
//            verticalDragOffset = dragStartDetails.localPosition.dx;
//          });
//      },
//      onVerticalDragDown: (DragDownDetails dragDownDetails) {
//        setState(() {
//          verticalDragOffset = dragDownDetails.localPosition;
//        });
//      },
    return Container(
      color: Colors.blue,
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          print("dx: ${dragUpdateDetails.localPosition.dx}");
          print("dy: ${dragUpdateDetails.localPosition.dy}");
          if (dragUpdateDetails.localPosition.dx > 0 &&
              dragUpdateDetails.localPosition.dx < widget.size.width)
            setState(() {
              progress = dragUpdateDetails.localPosition.dx;
              verticalDragOffset = dragUpdateDetails.localPosition.dy;
            });
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
//            while(verticalDragOffset != 0) {
          setState(() {
            verticalDragOffset = 0;
          });
//            }
        },
//          onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
//            print("vertical update");
//            if (dragUpdateDetails.localPosition.dy < widget.size.height && dragUpdateDetails.localPosition.dy > 0)
//              setState(() {
//                verticalDragOffset = dragUpdateDetails.primaryDelta;
// //                progress = dragUpdateDetails.localPosition.dx;
//              });
//          },
        child: AnimatedBuilder(
          animation: _seekbarAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: widget.size,
              painter: SeekBarPainter(
                verticalDragOffset: verticalDragOffset * _seekbarAnimation.value ?? 0,
                progress: progress,
                width: widget.size.width,
                height: widget.size.height,
              ),
            );
          },
        ),
      ),
    );
//    );
  }
}
