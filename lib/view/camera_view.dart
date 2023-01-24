import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;
  @override
  State<CameraView> createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: SizedBox(
              height: 400,
              width: 400,
              child: CameraPreview(controller),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
              onPressed: () async {
                pictureFile = await controller.takePicture();
                setState(() {});
              },
              child: const Text("Capture Image")),
        ),
        pictureFile != null
            ? Image.file(
                File(pictureFile!.path),
                width: 600,
                height: 200,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
