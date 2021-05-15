import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator(
      {@required Color color, @required double radius, double offsetY: 0.0})
      : _painter = _CirclePainter(color, radius, offsetY);

  @override
  BoxPainter createBoxPainter([onchanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final double userOffSetY;

  _CirclePainter(Color color, this.radius, this.userOffSetY)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset +
        Offset(cfg.size.width / 2, cfg.size.height - radius + userOffSetY);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

class GroupTilePainter extends Decoration {
  final BoxPainter _painter;

  GroupTilePainter({@required List<Color> colors, @required Size size})
      : _painter = _GroupTilePainter(colors, size);

  @override
  BoxPainter createBoxPainter([onchanged]) => _painter;
}

class _GroupTilePainter extends BoxPainter {
  final Paint _paint;
  final Size size;

  _GroupTilePainter(List<Color> colors, this.size)
      : _paint = Paint()
          ..shader = ui.Gradient.linear(Offset(0.0, 0.0),
              Offset(size.width, size.height), [colors[0], colors[1]])
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    var paint = Paint();

    paint.style = PaintingStyle.fill;
    double yCenter = size.height * 1.1;

    var path = Path();
    path.lineTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        size.width * 0.5, yCenter, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    path.close();
    // canvas.drawImage(image, Offset.zero, Paint());

    canvas.drawPath(path, _paint);
  }
}
