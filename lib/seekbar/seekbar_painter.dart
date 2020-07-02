import 'package:flutter/material.dart';

class SeekBarPainter extends CustomPainter {

  double x1;
  double x2;
  double y1;
  double y2;

  double thumbX;
  double thumbY;

  Path path;

//  double progress;
  bool touched;

  double width;
  double height;

  double thickLineStrokeWidth;
  double thinLineStrokeWidth;

  Color thickLineColor;
  Color thinLineColor;

  double circleRadius;

  SeekBarPainter({
    @required this.thumbX,
    @required this.thumbY,
    @required this.width,
    @required this.height,
//    @required this.progress,
    @required this.thickLineStrokeWidth,
    @required this.thinLineStrokeWidth,
    @required this.thickLineColor,
    @required this.thinLineColor,
    @required this.circleRadius,
    this.touched = false,
  }) {
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

//    path.reset();
    
    final Paint progressPainter = Paint()
      ..color = thickLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickLineStrokeWidth;

    final Paint circleInsidePainter = Paint()
      ..color = thickLineColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    final Paint circleBorderPainter = Paint()
      ..color = thickLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickLineStrokeWidth;
    final Paint defaultPainter = Paint()
      ..color = thinLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thinLineStrokeWidth;

    x1 = (thumbX + trackStartX) / 2;
    y1 = height / 2;
    x2 = x1;
    y2 = height / 2 + thumbY;

    path.moveTo(trackStartX, height/2);
    path.cubicTo(x1, y1, x2, y2, thumbX, height / 2 + thumbY);
    canvas.drawPath(path, progressPainter);

    path.reset();
    path.moveTo(thumbX, height / 2 + thumbY);
    
    x1 = (thumbX + trackEndX) / 2;
    y1 = height / 2 + thumbY;
    x2 = x1;
    y2 = height/2;
    
    path.cubicTo(x1, y1, x2, y2, trackEndX, trackY);

    canvas.drawPath(path, defaultPainter);

    canvas.drawCircle(Offset(thumbX, height / 2 + thumbY), circleRadius, circleBorderPainter);
    
//    final Path path1 = Path()
//      ..moveTo(thickLineStrokeWidth + circleRadius, height / 2)
//      ..cubicTo(
//        (progress - 12) / 3,
//        height / 2,
//        2 * (progress - 12) / 3,
//        height / 2 + thumbY,
//        progress - circleRadius - thickLineStrokeWidth / 2,
//        height / 2 + thumbY,
//      );
//    final Path path2 = Path()
//      ..moveTo(
//          progress + circleRadius + thickLineStrokeWidth / 2,
//          height / 2 + thumbY)
//      ..cubicTo(
//        progress + (width - progress) / 3,
//        height / 2 + thumbY,
//        progress + 2 * (width - progress) / 3,
//        height / 2,
//        width - thinLineStrokeWidth - circleRadius,
//        height / 2,
//      );
//    canvas.drawPath(path1, progressPainter);
//    canvas.drawPath(path2, defaultPainter);
//    canvas.drawCircle(
//      Offset(progress, height / 2 + thumbY),
//      circleRadius,
//      circleInsidePainter,
//    );
//    canvas.drawCircle(
//      Offset(progress, height / 2 + thumbY),
//      circleRadius + 2,
//      circleBorderPainter,
//    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
