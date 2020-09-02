import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FaceDetection extends StatefulWidget {
  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  ui.Image image;
  var smileProb;
  List<Rect> rect = List<Rect>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var visionImage = FirebaseVisionImage.fromFile(image);

    setState(() {
      rect = List<Rect>();
    }); 

    // var faceDetectionProperties = FaceDetectorOptions(
    //   enableClassification: true,
    // );
    var faceDetection =
        FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
    ));

    List<Face> faces = await faceDetection.processImage(visionImage);
    for (Face f in faces) {
      rect.add(f.boundingBox);
      smileProb = f.smilingProbability;
      
      print('============================================');
      print(smileProb);
    }
    loadImage(image).then((img) {
      setState(() {
        this.image = img;
      });
    });
  }

  Future<ui.Image> loadImage(File image) async {
    var img = await image.readAsBytes();
    return decodeImageFromList(img);
  }

  String detectSmile() {
    if (smileProb > 0.86) {
      return 'Big smile with teeth';
    }
    else if (smileProb > 0.8) {
      return 'Big Smile';
    } else if (smileProb > 0.3) {
      return 'Smile';
    } else
      return 'Sad';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    child: FittedBox(
                      child: SizedBox(
                        width: image != null ? image.width.toDouble() : 500.0,
                        height: image != null ? image.height.toDouble() : 500.0,
                        child: CustomPaint(
                          painter: Painter(rect: rect, image: image),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${detectSmile()}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
          ),
        ));
  }
}

class Painter extends CustomPainter {
  List<Rect> rect;
  ui.Image image;

  Painter({@required this.rect, @required this.image});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // TODO: implement paint

    canvas.drawImage(image, Offset.zero, Paint());

    if (rect != null) {
      for (Rect rect in this.rect) {
        canvas.drawRect(
            rect,
            Paint()
              ..color = Colors.red
              ..strokeWidth = 5.0
              ..style = PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
