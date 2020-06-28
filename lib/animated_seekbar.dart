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
    progress = 50;
//    verticalDragOffset = Offset.zero;
    verticalDragOffset = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
        setState(() {
          verticalDragOffset = dragUpdateDetails.primaryDelta;
        });
      },
//      onVerticalDragDown: (DragDownDetails dragDownDetails) {
//        dragD
//      },
      child: Container(
        color: Colors.blue,
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
  }
}
