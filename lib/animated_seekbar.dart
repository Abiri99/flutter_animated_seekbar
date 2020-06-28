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

class _AnimatedSeekbarState extends State<AnimatedSeekbar> {

  double progress;

  double verticalDragOffset;

  @override
  void initState() {
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
            if (dragUpdateDetails.localPosition.dx > 0 && dragUpdateDetails.localPosition.dx < widget.size.width)
              setState(() {
                progress = dragUpdateDetails.localPosition.dx;
                verticalDragOffset = dragUpdateDetails.localPosition.dy;
              });
          },
          onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
            print("dy: ${dragUpdateDetails.localPosition.dy}");
            if (dragUpdateDetails.localPosition.dy < widget.size.height && dragUpdateDetails.localPosition.dy > 0)
              setState(() {
                verticalDragOffset = dragUpdateDetails.primaryDelta;
                progress = dragUpdateDetails.localPosition.dx;
              });
          },
          child: CustomPaint(
            size: widget.size,
            painter: SeekBarPainter(
              verticalDragOffset: verticalDragOffset ?? 0,
              progress: progress,
              width: widget.size.width,
              height: widget.size.height,
            ),
          ),
        ),
      );
//    );
  }
}
