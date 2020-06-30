import 'package:flutter/material.dart';

class RangePickerPainter extends CustomPainter {
  double width;
  double height;
  bool firstNodeTouched;
  bool secNodeTouched;
  double firstNodeProgress;
  double secNodeProgress;
  double firstNodeVerticalOffset;
  double secNodeVerticalOffset;

  RangePickerPainter({
    this.width,
    this.height,
    this.firstNodeVerticalOffset,
    this.secNodeVerticalOffset,
    this.firstNodeProgress,
    this.secNodeProgress,
    this.firstNodeTouched,
    this.secNodeTouched,
  }) {
    print("firstnodevertical: $firstNodeVerticalOffset");
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressLinePainter = Paint()
      ..color = Color(0xff1f3453)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final Paint defaultPainter = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final Paint firstCirclePainter = Paint()
      ..color = Color(0xff1f3453)
      ..style = firstNodeTouched ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 4;

    final Paint secCirclePainter = Paint()
      ..color = Color(0xff1f3453)
      ..style = secNodeTouched ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 4;

    final Path path1 = Path()
      ..moveTo(0, height / 2)
      ..cubicTo(
        (firstNodeProgress - 12) / 3,
        height / 2,
        2 * (firstNodeProgress - 12) / 3,
        height / 2 + firstNodeVerticalOffset,
        firstNodeProgress - 12,
        height / 2 + firstNodeVerticalOffset,
      );

    final Path path2 = Path()
      ..moveTo(firstNodeProgress + 12, height / 2 + firstNodeVerticalOffset)
      ..cubicTo(
        firstNodeProgress + (secNodeProgress - firstNodeProgress) / 3,
        height/2 + firstNodeVerticalOffset,
        firstNodeProgress + 2 * (secNodeProgress - firstNodeProgress) / 3,
        height/2 + secNodeVerticalOffset,
        firstNodeProgress + 3 * (secNodeProgress - firstNodeProgress) / 3 - 12,
        height/2 + secNodeVerticalOffset,
      );

    final Path path3 = Path()
      ..moveTo(secNodeProgress + 12, height / 2 + secNodeVerticalOffset)
      ..cubicTo(
        secNodeProgress + (width - secNodeProgress) / 3,
        height/2 + secNodeVerticalOffset,
        secNodeProgress + 2 * (width - secNodeProgress) / 3,
        height/2,
        secNodeProgress + 3 * (width - secNodeProgress) / 3,
        height/2,
      );

    canvas.drawPath(path1, defaultPainter);
    canvas.drawPath(path2, progressLinePainter);
    canvas.drawPath(path3, defaultPainter);
    canvas.drawCircle(Offset(firstNodeProgress, height / 2 + firstNodeVerticalOffset), 12, firstCirclePainter);
    canvas.drawCircle(Offset(secNodeProgress, height / 2 + secNodeVerticalOffset), 12, secCirclePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
