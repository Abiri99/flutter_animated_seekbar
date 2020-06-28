import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeekBarPainter extends CustomPainter {

  final double width;
  final double height;

  SeekBarPainter({
    @required this.width,
    @required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, height / 2), Offset(width, height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}