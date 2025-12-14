import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' show decodeImage, copyResize;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LeafDetectorScreen extends StatefulWidget {
  const LeafDetectorScreen({super.key});

  @override
  State<LeafDetectorScreen> createState() => _LeafDetectorScreenState();
}

class _LeafDetectorScreenState extends State<LeafDetectorScreen> {
  File? _image;
  String _resultText = "";

  late Interpreter _interpreter;
  late List<String> _labels;

  final int _inputSize = 224; // Teachable Machine default

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // ---------------- LOAD MODEL ----------------
  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/model/leaf_model.tflite',
    );
    _labels = await _loadLabels('assets/model/labels.txt');
  }

  Future<List<String>> _loadLabels(String path) async {
    final raw = await DefaultAssetBundle.of(context).loadString(path);
    return raw.split('\n');
  }

  // ---------------- PICK IMAGE ----------------
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final file = File(picked.path);

    setState(() {
      _image = file;
      _resultText = "Detecting...";
    });

    _runInference(file);
  }

  // ---------------- INFERENCE ----------------
  Future<void> _runInference(File imageFile) async {
    final input = await _preprocessImage(imageFile);
    log('**********Input**********');
    print('input :: $input');
    log('**********Input**********');

    final output = List.filled(
      _labels.length,
      0.0,
    ).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    _processOutput(output[0]);
  }

  // ---------------- IMAGE PREPROCESS ----------------
  Future<List<List<List<List<double>>>>> _preprocessImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = decodeImage(bytes)!;
    final resized = copyResize(image, width: _inputSize, height: _inputSize);

    return [
      List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    ];
  }

  // ---------------- RESULT ----------------
  // []
  void _processOutput(List<double> scores) {
    double maxScore = scores[0];
    int maxIndex = 0;

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    setState(() {
      if (maxScore < 0.5) {
        _resultText = "No leaf detected";
      } else {
        _resultText =
            "${_labels[maxIndex]} (${(maxScore * 100).toStringAsFixed(2)}%)";
      }
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Leaf Detector"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickImage,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.photo_library),
        label: const Text("Pick Image"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _imagePreviewCard(),
            const SizedBox(height: 20),
            _resultCard(),
          ],
        ),
      ),
    );
  }

  Widget _imagePreviewCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.eco, size: 80, color: Colors.green),
                  SizedBox(height: 10),
                  Text("Select a leaf image", style: TextStyle(fontSize: 16)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(_image!, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _resultCard() {
    final isDetected =
        _resultText.isNotEmpty && !_resultText.contains("No leaf");

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _statusBadge(isDetected),
            const SizedBox(height: 12),
            Text(
              _resultText.isEmpty ? "Waiting for image..." : _resultText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool detected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: detected ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        detected ? "Leaf Detected" : "No Leaf",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
