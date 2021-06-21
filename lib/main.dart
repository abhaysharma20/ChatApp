import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chatapp/UIPart/homePage.dart';
import 'package:flutter/material.dart';

import 'UIPart/CamVid/cameraScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: HomePage()));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Authentication App'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      body: Container(),
    );
  }
}
