import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PolygonClipper extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  PolygonClipper(this.move);

  @override
  Path getClip(Size size) {
    // print(move);
    Path path = Path();
    // double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);

    path.lineTo(0, size.height * 0.92 - 18 * math.cos(move * slice));
    // path.quadraticBezierTo(0, yCenter, x2, y2)
    path.lineTo(size.width, size.height * 0.90 + 20 * math.cos(move * slice));
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CurveClipper extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  double height;
  CurveClipper(this.move, this.height);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double yCenter = height * 0.9 + 20 * math.cos(move * slice);

    path.lineTo(0, height * 0.9);
    path.quadraticBezierTo(size.width * 0.5, yCenter, size.width, height * 0.9);
    // path.lineTo(
    //     size.width, size.height * 0.89 + 20 * math.cos((move - 0.3) * slice));
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
