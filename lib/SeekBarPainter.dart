import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeekBarPainter extends CustomPainter {
  final double verticalDragOffset;
  final double width;
  final double height;
  final double progress;
  final bool touched;

  SeekBarPainter({
    @required this.verticalDragOffset,
    @required this.width,
    @required this.height,
    @required this.progress,
    @required this.touched = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPainter = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    final Paint circlePainter = Paint()
      ..color = Colors.red
      ..style =  touched ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 6;
    final Paint linePainter = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final Path path1 = Path()
      ..moveTo(0, height / 2)
      ..cubicTo(
        (progress - 12) / 2,
        height / 2,
        3 * (progress - 12) / 4,
        height / 2 + verticalDragOffset,
        progress - 12,
        height / 2 + verticalDragOffset,
      );
    final Path path2 = Path()
      ..moveTo(progress + 12, height / 2 + verticalDragOffset)
      ..cubicTo(
        progress + (width - progress) / 2,
        height / 2 + verticalDragOffset,
        progress + 3 * (width - progress) / 4,
        height / 2,
        width,
        height / 2,
      );
    canvas.drawPath(path1, progressPainter);
    canvas.drawPath(path2, linePainter);
//    canvas.drawLine(
//        Offset(0, height / 2), Offset(progress - 12, height / 2), progressPainter);
//    canvas.drawLine(Offset(progress + 12, height / 2 + verticalDragOffset),
//        Offset(width, height / 2), linePainter);
    canvas.drawCircle(Offset(progress, height / 2 + verticalDragOffset), 12, circlePainter);
//    print("paint done");
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
