import 'package:flutter/material.dart';
import 'gradient_button.dart'; // Import the new button

class InitialView extends StatelessWidget {
  final VoidCallback onStartRecording;

  const InitialView({Key? key, required this.onStartRecording}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- Big Soft Circle Background ---
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 10,
              )
            ],
          ),
          child: const Center(
            child: Icon(Icons.mic_none_rounded, size: 100, color: Color(0xFF448AFF)),
          ),
        ),
        const SizedBox(height: 40),
        
        const Text(
          "Ready to Transcribe",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          "Record voice notes or share audio\nfiles from other apps.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
        ),
        
        const SizedBox(height: 50),
        
        // --- New Gradient Button ---
        GradientButton(
          text: "Start Recording",
          icon: Icons.mic,
          onPressed: onStartRecording,
        ),
      ],
    );
  }
}