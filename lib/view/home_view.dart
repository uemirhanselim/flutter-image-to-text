import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_to_text/view/camera_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraView(cameras: value))));
          },
          child: const Text("Launch Camera"),
        ),
      ),
    );
  }
}
