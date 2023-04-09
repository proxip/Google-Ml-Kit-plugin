

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera_view.dart';
import 'painters/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
 

      for (Face face in faces) {
        final Rect boundingBox = face.boundingBox;

        final double? rotX = face.headEulerAngleX; // Head is tilted up and down rotX degrees
        final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
        final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

        // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
        // eyes, cheeks, and nose available):
        print("Kepala atas bawah ${face.headEulerAngleX}");
        print("Kepala kanan kiri ${face.headEulerAngleY}");
        print("Kepala tilt ${face.headEulerAngleZ}");
        // If classification was enabled with FaceDetectorOptions:
        if (face.smilingProbability != null) {
          final double? smileProb = face.smilingProbability;
        }

        // If face tracking was enabled with FaceDetectorOptions:
        if (face.trackingId != null) {
          final int? id = face.trackingId;
        }
      }
    // if (inputImage.inputImageData?.size != null &&
    //     inputImage.inputImageData?.imageRotation != null) {
    //   final painter = FaceDetectorPainter(
    //       faces,
    //       inputImage.inputImageData!.size,
    //       inputImage.inputImageData!.imageRotation);
    //   _customPaint = CustomPaint(painter: painter);
    // } else {
    //   String text = 'Faces found: ${faces.length}\n\n';
    //   for (final face in faces) {
    //     text += 'face: ${face.boundingBox}\n\n';
    //   }
    //   _text = text;
    //   // TODO: set _customPaint to draw boundingRect on top of image
    //   _customPaint = null;
    // }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
