import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkr/pages/base.dart';
import 'package:winkr/pages/homepage.dart';
import 'package:camera/camera.dart';
import 'package:winkr/services/Handlers.dart';
import 'package:winkr/uiElements/CircleTabIndicator.dart';

Future<void> main() async {
  // Provider.debugCheckInvalidValueType = null;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    runApp(Provider(create: (context) => cameras, child: Base()));
  } on CameraException catch (e) {
    logError(e.code, e.description);
    runApp(Winkr());
  }
}

class Winkr extends StatelessWidget {
  // This widget is the root of your application.
  const Winkr({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winkr',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0)),
          primarySwatch: Colors.teal,
          tabBarTheme: TabBarTheme(
            indicator: CircleTabIndicator(
                color: Colors.white, radius: 3.0, offsetY: -8.0),
          ),
          fontFamily: 'Ropa Sans'),
      home: MyHomePage(title: 'Winkr'),
    );
  }
}
