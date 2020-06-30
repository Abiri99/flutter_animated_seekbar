import 'package:flutter/material.dart';

class SeekBarPainter extends CustomPainter {
  double verticalDragOffset;
  double progress;
  bool touched;

  double width;
  double height;

  double thickLineStrokeWidth;
  double thinLineStrokeWidth;

  Color thickLineColor;
  Color thinLineColor;

  SeekBarPainter({
    @required this.verticalDragOffset,
    @required this.width,
    @required this.height,
    @required this.progress,
    @required this.thickLineStrokeWidth,
    @required this.thinLineStrokeWidth,
    @required this.thickLineColor,
    @required this.thinLineColor,
    this.touched = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPainter = Paint()
      ..color = thickLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickLineStrokeWidth;
    final Paint circlePainter = Paint()
      ..color = thickLineColor
      ..style = touched ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = thickLineStrokeWidth;
    final Paint defaultPainter = Paint()
      ..color = thinLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thinLineStrokeWidth;

    final Path path1 = Path()
      ..moveTo(0, height / 2)
      ..cubicTo(
        (progress - 12) / 3,
        height / 2,
        2 * (progress - 12) / 3,
        height / 2 + verticalDragOffset,
        touched ? progress : progress - 12,
        height / 2 + verticalDragOffset,
      );
    final Path path2 = Path()
      ..moveTo(progress + 12, height / 2 + verticalDragOffset)
      ..cubicTo(
        progress + (width - progress) / 3,
        height / 2 + verticalDragOffset,
        progress + 2 * (width - progress) / 3,
        height / 2,
        width,
        height / 2,
      );
    canvas.drawPath(path1, progressPainter);
    canvas.drawPath(path2, defaultPainter);
    canvas.drawCircle(
        Offset(progress, height / 2 + verticalDragOffset), 12, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
