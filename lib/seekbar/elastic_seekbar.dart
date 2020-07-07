import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'seekbar_painter.dart';
import '../utils.dart';

// ignore: must_be_immutable
class ElasticSeekBar extends StatefulWidget {
  // Notifies parent of the current value
  final Function(String value) valueListener;

  // Size of seek bar
  final Size size;

  // Minimum value of seek bar
  final double minValue;

  // Maximum value of seek bar
  final double maxValue;

  // How much seek bar stretches in vertical axis
  final double stretchRange;

  // Thickness of progress line and thumb
  final double thickLineStrokeWidth;

  // Thickness of default line
  final double thinLineStrokeWidth;

  // Radius of thumb
  final double circleRadius;

  // Color of progress line and thumb
  Color thickLineColor;

  // Color of default line
  Color thinLineColor;

  // Speed of bouncing animation
  final Duration bounceDuration;

  final double stiffness;

  final double dampingRatio;

  ElasticSeekBar({
    @required this.valueListener,
    @required this.size,
    this.stretchRange = 100,
    this.minValue = 0,
    this.maxValue = 100,
    this.circleRadius = 12,
    this.thickLineStrokeWidth = 4,
    this.thinLineStrokeWidth = 3,
    this.thickLineColor,
    this.thinLineColor,
    this.bounceDuration,
    this.stiffness = 300,
    this.dampingRatio = 8,
  }) {
    if (thickLineColor == null) thickLineColor = Color(0xff1f3453);
    if (thinLineColor == null) thinLineColor = Colors.blueGrey;
  }

  @override
  _ElasticSeekBarState createState() => _ElasticSeekBarState();
}

class _ElasticSeekBarState extends State<ElasticSeekBar>
    with SingleTickerProviderStateMixin {
  GlobalKey _key = GlobalKey();

  double value;

  double thumbY;
  double thumbX;

  double trackStartX;
  double trackEndX;
  double trackY;

  AnimationController _controller;

  Animation _seekbarAnimation;

  Animation<double> _animation;

  bool touched;

  @override
  void initState() {
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//      getSizeAndPosition();
//    });

    _controller =
        AnimationController(vsync: this, upperBound: 500);

    _controller.addListener(() {
//      print("val: ${_animation.value}");
//      var value = 10 * (1 - _animation.value) * thumbY;

//      const spring = SpringDescription(
//        mass: 1.0,
//        stiffness: 300.0,
//        damping: 0.5,
//      );
//      final simulation = SpringSimulation(spring, 0, 100, -4000.0);
      setState(() {
        print("anim val: ${_animation.value}");
        thumbY = _animation.value;
//        thumbY = 2 * (1 - _animation.value) * thumbY;
      });
    });

    touched = false;
    value = (widget.maxValue - widget.minValue) / 2;
    thumbY = 0;
    thumbX = widget.size.width / 2;
    trackY = widget.size.height / 2;
    trackEndX = widget.size.width -
        widget.circleRadius -
        widget.thickLineStrokeWidth / 2;
    trackStartX = widget.circleRadius + widget.thickLineStrokeWidth / 2;
    super.initState();
  }

  String getCurrentValue() {
    if (thumbX <= trackStartX) return widget.minValue.toString();
    if (thumbX >= trackEndX) return widget.maxValue.toString();
    return (((thumbX - trackStartX) / (trackEndX - trackStartX)) *
            (widget.maxValue - widget.minValue))
        .toString();
  }

  runAnimation(Offset pixelsPerSecond, Size size) {
//    _animation = CurvedAnimation(
//      parent: _controller,
//      curve: Curves.elasticOut,
//    );

//    _controller.forward().then((value) {
//      _controller.reset();
//    });

    _animation = _controller.drive(Tween<double>(
      begin: thumbY,
      end: 0.0,
    ));
    var spring = SpringDescription(
      mass: 1.0,
      stiffness: widget.stiffness,
      damping: widget.dampingRatio,
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Colors.grey,
      child: GestureDetector(
        onPanDown: (details) {
          _controller.stop();
        },
        onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
          RenderBox box = context.findRenderObject();
          var touchPoint = box.globalToLocal(dragUpdateDetails.globalPosition);

//          _controller.forward().then(
//            (value) {

          setState(() {
            thumbX = (dragUpdateDetails.localPosition.dx as double)
                .coerceHorizontal(trackStartX, trackEndX);
            thumbY = (touchPoint.dy - widget.size.height / 2)
                .coerceVertical(0, widget.stretchRange)
                .coerceToStretchRange(
                    thumbX,
                    widget.size.height,
                    widget.size.width,
                    widget.stretchRange,
                    trackStartX,
                    trackEndX);
          });
          widget.valueListener(getCurrentValue());
//            },
//          );
        },
        onPanEnd: (DragEndDetails dragEndDetails) {
          runAnimation(dragEndDetails.velocity.pixelsPerSecond, size);
//          print("end");
//          _controller.animateBack(0.0).then((value) {
//          });
        },
        child: CustomPaint(
          size: Size(widget.size.width, widget.size.height),
          painter: SeekBarPainter(
            thumbX: thumbX,
            thumbY: thumbY,
            width: widget.size.width,
            height: widget.size.height,
            touched: touched,
            thickLineColor: widget.thickLineColor,
            thickLineStrokeWidth: widget.thickLineStrokeWidth,
            thinLineColor: widget.thinLineColor,
            thinLineStrokeWidth: widget.thinLineStrokeWidth,
            circleRadius: widget.circleRadius,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
