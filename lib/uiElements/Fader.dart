import 'package:flutter/material.dart';

class Fader extends StatelessWidget {
  final double opacity;
  final Widget child;
  const Fader({Key key, this.opacity, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
