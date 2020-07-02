import 'package:dartx/dartx.dart';

extension DoubleExtention on double {
  double coerceHorizontal(
    var trackStartX,
    var trackEndX,
  ) {
    return this.coerceAtMost(trackEndX).coerceAtLeast(trackStartX);
  }

  double coerceVertical(
    var trackY,
    var stretchRange,
  ) {
    return this
        .coerceAtMost(trackY + stretchRange)
        .coerceAtLeast(trackY - stretchRange);
  }

  double coerceToStretchRange(var x, var height, var width, var stretchRange,
      var trackStartX, var trackEndX) {
    if (this == 0)
      return this;
    if (this < 0) {
      print("dragged up: $this");
      return this.coerceAtLeast(
//        x <= width/2 ? -40 : -80
        x <= width/2 ?
        -(((2 * stretchRange) * (x - trackStartX)) / (width - (2 * trackStartX))) + (0) :
        -(((2 * stretchRange) * (x - trackEndX)) / (width - (2 * trackEndX))) + (0)
      );
    } else {
      print("dragged down: $this");
      return this.coerceAtMost(x < width / 2
          ? (((2 * (stretchRange + height / 2) - height) * (x - trackStartX)) /
                  (width - (2 * trackStartX))) +
              (0)
          : (((2 * (stretchRange + height / 2) - height) * (x - trackEndX)) /
                  (width - (2 * trackEndX))) +
              (0));
    }
  }
}
