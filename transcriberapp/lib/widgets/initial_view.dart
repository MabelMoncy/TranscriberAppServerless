import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'gradient_button.dart';

class InitialView extends StatelessWidget {
  final VoidCallback onStartRecording;

  const InitialView({super.key, required this.onStartRecording});

  Future<void> _openWhatsApp() async {
    try {
      await LaunchApp.openApp(
        androidPackageName: 'com.whatsapp',
        iosUrlScheme: 'whatsapp://',
      );
    } catch (e) {
      debugPrint("Could not open WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Soft Circle Background
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // <--- Dynamic
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor, // <--- Dynamic
                blurRadius: 30,
                spreadRadius: 10,
              )
            ],
          ),
          child: const Center(
            child: Icon(Icons.mic_none_rounded, size: 90, color: Color(0xFF448AFF)),
          ),
        ),
        const SizedBox(height: 30),
        
        // Title
        Text(
          "Transcriber",
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).textTheme.bodyLarge?.color // <--- Dynamic
          ),
        ),
        const SizedBox(height: 10),
        
        // Subtitle
        Text(
          "Record voice notes or share audio\nfiles from WhatsApp.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16, 
            color: Theme.of(context).textTheme.bodyMedium?.color, // <--- Dynamic (Grey)
            height: 1.5
          ),
        ),
        
        const SizedBox(height: 40),
        
        GradientButton(
          text: "Start Recording",
          icon: Icons.mic_rounded,
          onPressed: onStartRecording,
        ),

        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: _openWhatsApp,
          icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green),
          label: const Text("Open WhatsApp"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: Colors.green, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            foregroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        
        const SizedBox(height: 10),
        Text(
          "(Select audio in WhatsApp -> Share -> Transcriber)",
          style: TextStyle(
            fontSize: 12, 
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
          ),
        ),
      ],
    );
  }
}
