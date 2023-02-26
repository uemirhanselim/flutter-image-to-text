import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_to_text/manager/word_cache_manager.dart';

import '../model/word_model.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraView> createState() => CameraViewState();
}

class CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  late CameraController controller;
  XFile? pictureFile;
  bool textScanning = false;
  String scannedText = '';
  late final TextRecognizer textRecognizer;
  List<Word>? denemeKelimeleri = [];
  late final ICacheManager<Word> cacheManager;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    cacheManager = WordCacheManager("denemeKelimeler2");
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    check();
    super.initState();
  }

  Future<void> check() async {
    await cacheManager.init();
    if ((cacheManager.getValues()?.isNotEmpty ) ?? false) {
      denemeKelimeleri = cacheManager.getValues();
    }
    setState(() {
      
    });
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    List<String> words = [];
    List<String> meanings = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String stext = "$scannedText${line.text}\n";
        int index = stext.indexOf("=");
        String first = stext.substring(0, index).trim().toLowerCase();
        String second = stext.substring(index + 1).trim().toLowerCase();
        denemeKelimeleri?.add(Word(word: first, meaning: second));
        words.add(first);
        meanings.add(second);
        log("WORDS: $words");
        log("MEANINGS: $meanings");
      }
    }
    if (denemeKelimeleri?.isNotEmpty ?? false) {
      await cacheManager.addItems(denemeKelimeleri!);
    }

    textScanning = false;
    setState(() {});
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    textScanning = true;
                    setState(() {});
                    getRecognisedText(pictureFile!);
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
            Container(
              child: Text(
                scannedText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  List<Word>? values = cacheManager.getValues() ??
                      [Word(word: "NAN", meaning: "NAN")];
                  for (var i = 0; i < values.length; i++) {
                    debugPrint(
                        "VALUES: ${values[i].word} = ${values[i].meaning}");
                  }
                },
                child: const Text("Get Cached Words"))
          ],
        ),
      ),
    );
  }
}
