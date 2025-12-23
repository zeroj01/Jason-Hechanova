import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/landing_page.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BALLS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'sans-serif',
      ),
      home: const LandingPage(),
    );
  }
}

class ImageClassifier extends StatefulWidget {
  final File? initialImage; // Accept an image from the recovery process
  const ImageClassifier({super.key, this.initialImage});

  @override
  State<ImageClassifier> createState() => _ImageClassifierState();
}

class _ImageClassifierState extends State<ImageClassifier> {
  File? _image;
  List? _output;
  bool _loading = false;
  String _status = "Select an image to start";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
    // If we received an image from recovery, use it immediately
    if (widget.initialImage != null) {
      _image = widget.initialImage;
      _status = "Processing recovered image...";
      classifyImage(_image!);
    } else {
      _retrieveLostData();
    }
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty || response.file == null) return;
    
    setState(() {
      _loading = true;
      _image = File(response.file!.path);
      _output = null;
      _status = "Recovering image...";
    });
    classifyImage(_image!);
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      setState(() { _status = "Opening camera..."; });
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _loading = true;
        _image = File(image.path);
        _output = null;
        _status = "Analyzing...";
      });
      await classifyImage(_image!);
    } catch (e) {
      setState(() { _status = "Error: $e"; _loading = false; });
    }
  }

  Future<void> classifyImage(File image) async {
    try {
      setState(() { _loading = true; });
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.1,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      
      setState(() {
        _loading = false;
        _output = output;
        _status = (_output == null || _output!.isEmpty) ? "Unknown ball" : "Classification complete";
      });
      
      if (_output != null && _output!.isNotEmpty) {
        logClassification(_output![0]);
      }
    } catch (e) {
      setState(() { _status = "Classification failed"; _loading = false; });
    }
  }

  Future<void> logClassification(dynamic result) async {
    try {
      await FirebaseFirestore.instance.collection('classifications').add({
        'label': result['label'].replaceAll(RegExp(r'^[0-9]+ '), '').trim(),
        'confidence': result['confidence'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error logging to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.teal.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 300, width: 300,
                  child: _image == null
                      ? const Center(child: Icon(Icons.photo_camera_back_rounded, size: 80, color: Colors.teal))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                  : _output != null && _output!.isNotEmpty
                      ? Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Result: ${_output![0]['label'].replaceAll(RegExp(r'^[0-9]+ '), '').replaceAll('_', ' ').trim()}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                Text('Confidence: ${(_output![0]['confidence'] * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(fontSize: 16, color: Colors.teal)),
                              ],
                            ),
                          ),
                        )
                      : Center(child: Text(_status, style: const TextStyle(fontSize: 16, color: Colors.black54))),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(onPressed: () => pickImage(ImageSource.gallery), icon: Icons.image_outlined, label: 'Gallery'),
                _buildIconButton(onPressed: () => pickImage(ImageSource.camera), icon: Icons.camera_alt_outlined, label: 'Camera'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required VoidCallback onPressed, required IconData icon, required String label}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(radius: 35, backgroundColor: Colors.teal, child: Icon(icon, size: 30, color: Colors.white)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
