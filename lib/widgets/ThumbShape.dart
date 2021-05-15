import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class ThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;
  final int min;
  final int max;

  ThumbShape(this.thumbRadius, this.thumbHeight, this.min, this.max);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: center,
            width: thumbHeight * 1.0,
            height: thumbHeight * 1.0),
        Radius.circular(thumbRadius * 1.4));
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
        style: new TextStyle(
            fontSize: thumbHeight * 0.3,
            fontWeight: FontWeight.w600,
            fontFamily: "Ropa Sans"),
        text: "${getValue(value)}:00");
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
