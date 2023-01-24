import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_to_text/view/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Image To Text',
      home: HomeView(),
    );
  }
}
