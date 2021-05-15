import 'package:flutter/material.dart';
import 'package:winkr/uiElements/CircleTabIndicator.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
              color: Color(0x12000000),
              offset: Offset(0.0, -0.0),
              blurRadius: 3.0)
        ],
        // shape:
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constr) {
            Size size = constr.constrain(Size.fromHeight(100.0));
            return Container(
              decoration: GroupTilePainter(
                  colors: [Colors.lime, Colors.teal], size: size),
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.centerRight,
              //         colors: [Colors.orange, Colors.pink])),
            );
          }),
          Icon(Icons.public, size: 20.0, color: Colors.black12)
        ],
      ),
    );
  }
}

// Positioned(
//   child: CircleAvatar(
//     radius: 40.0,
//     backgroundImage: AssetImage('assets/profile_pics/damon.jpg'),
//   ),
// ),
