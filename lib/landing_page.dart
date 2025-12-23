import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/main_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkRecovery();
  }

  Future<void> _checkRecovery() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (!response.isEmpty && response.file != null) {
      if (mounted) {
        // Retrieve the file and pass it to the MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              initialIndex: 1, 
              initialImage: File(response.file!.path),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                child: Icon(Icons.sports_soccer_rounded, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 40),
              const Text('Sports Ball Classifier',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 20),
              const Text('Use your camera or gallery to identify different kinds of sports balls in real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54)),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
