import 'package:face_detection_flutter/screens/face_detection.dart';
import 'package:face_detection_flutter/screens/voice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceDetection(),
    );
  }
}
