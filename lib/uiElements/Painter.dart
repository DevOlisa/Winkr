import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/widgets.dart';

class GroupTilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xFFF11660);
    paint.style = PaintingStyle.fill;
    double slice = math.pi;

    paint.strokeWidth = 2.0;
    double yCenter = 100.0 * 0.9 + 20 * math.cos(0.5 * slice);

    var path = Path();
    path.lineTo(0, 100.0 * 0.9);
    path.quadraticBezierTo(size.width * 0.5, yCenter, size.width, 100.0 * 0.9);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  Offset offset;
  final double radius;
  final Color circleFill;

  CirclePainter([
    this.radius,
    this.offset = const Offset(0.0, 0.0),
    this.circleFill = const Color(0xFFF5AA68),
  ]);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = circleFill;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
//  LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
// Color(0xFFF5AA68),
// Color(0xFFF11660),
//     ]);
