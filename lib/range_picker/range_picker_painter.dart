import 'package:flutter/material.dart';

class RangePickerPainter extends CustomPainter {

  double x1;
  double y1;
  double x2;
  double y2;

  double firstThumbX;
  double firstThumbY;
  double secThumbX;
  double secThumbY;

  double circleRadius;

  double thickLineStrokeWidth;
  double thinLineStrokeWidth;

  Path path;

  // Old
  double width;
  double height;
  bool firstNodeTouched;
  bool secNodeTouched;
//  double firstNodeProgress;
//  double secNodeProgress;
//  double firstNodeVerticalOffset;
//  double secNodeVerticalOffset;

  RangePickerPainter({
    this.firstThumbX,
    this.firstThumbY,
    this.secThumbX,
    this.secThumbY,
    this.width,
    this.height,
//    this.firstNodeVerticalOffset,
//    this.secNodeVerticalOffset,
//    this.firstNodeProgress,
//    this.secNodeProgress,
    this.firstNodeTouched,
    this.secNodeTouched,
    this.circleRadius,
    this.thickLineStrokeWidth,
    this.thinLineStrokeWidth,
  }) {
//    print("firstnodevertical: $firstNodeVerticalOffset");
    path = Path();
    path.reset();
  }

  double get trackEndX {
    return width - circleRadius - thickLineStrokeWidth/2;
  }

  double get trackStartX {
    return circleRadius + thickLineStrokeWidth/2;
  }

  double get trackY {
    return height/2;
  }

  @override
  void paint(Canvas canvas, Size size) {

    path.reset();

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

    x1 = (firstThumbX + trackStartX) / 2;
    y1 = height / 2;
    x2 = x1;
    y2 = firstThumbY;

    path.moveTo(trackStartX, height/2);
    path.cubicTo(x1, y1, x2, y2, firstThumbX - circleRadius, firstThumbY);
    if (firstThumbX - circleRadius >= trackStartX)
      canvas.drawPath(path, defaultPainter);

    path.reset();
    path.moveTo(firstThumbX + circleRadius, firstThumbY);

    x1 = (firstThumbX + secThumbX) / 2;
    y1 = secThumbY;
    x2 = x1;
    y2 = secThumbY;

    path.cubicTo(x1, y1, x2, y2, secThumbX - circleRadius, secThumbY);
    canvas.drawPath(path, progressLinePainter);

    path.reset();
    path.moveTo(secThumbX + circleRadius, secThumbY);

    x1 = (secThumbX + trackEndX) / 2;
    y1 = secThumbY;
    x2 = x1;
    y2 = height/2;

    path.cubicTo(x1, y1, x2, y2, trackEndX, trackY);
    canvas.drawPath(path, defaultPainter);

    canvas.drawCircle(Offset(firstThumbX, firstThumbY), circleRadius, firstCirclePainter);
    canvas.drawCircle(Offset(secThumbX, secThumbY), circleRadius, secCirclePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
