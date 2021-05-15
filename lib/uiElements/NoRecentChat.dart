import 'package:flutter/material.dart';

class NoRecentChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_very_satisfied,
              size: 200.0,
              color: Colors.black26,
            ),
            SizedBox(height: 5.0),
            Text(
              'Nothing to show here. Start by sending a message',
              style: TextStyle(color: Colors.black54, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
