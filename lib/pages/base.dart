import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Error Initializing FlutterFire"),
        );
      }

      // Once complete, show our application
      if (snapshot.connectionState == ConnectionState.done) {
        // return MyAwesomeApp();
      }
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.lime[600],
            Colors.teal[300],
          ])),
          child: WidgetsApp(
              color: Colors.white,
              textStyle: TextStyle(
                  fontFamily: "Ropa sans",
                  shadows: [Shadow(color: Colors.black26, blurRadius: 1.0)]),
              builder: (context, child) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign in to Winkr", style: TextStyle(fontSize: 36.0)),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3.0, color: Colors.black26)
                              ]),
                          child: TextButton(
                            child: Icon(
                              Icons.biotech_rounded,
                              color: Colors.teal,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3.0, color: Colors.black26)
                              ]),
                        ),
                      ],
                    )
                  ],
                ));
              },
              home: Text("Welcome")));
    });
  }

  void checkUserLoginStatus() {}
}
