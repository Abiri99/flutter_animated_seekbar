import 'package:flutter/material.dart';

import 'SeekBarPainter.dart';

class AnimatedSeekbar extends StatelessWidget {
  final Size size;

  AnimatedSeekbar({
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: SeekBarPainter(
        width: size.width,
        height: size.height,
      ),
    );
  }
}
