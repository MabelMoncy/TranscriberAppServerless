import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'gradient_button.dart';

class InitialView extends StatelessWidget {
  final VoidCallback onStartRecording;

  const InitialView({Key? key, required this.onStartRecording}) : super(key: key);

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
          // Reduced from 180 → 140 to save vertical space on OPPO A31
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 30,
                spreadRadius: 10,
              )
            ],
          ),
          child: const Center(
            child: Icon(Icons.mic_none_rounded, size: 70, color: Color(0xFF448AFF)),
          ),
        ),
        const SizedBox(height: 20),
        
        // Title
        Text(
          "Transcriber",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).textTheme.bodyLarge?.color
          ),
        ),
        const SizedBox(height: 10),
        
        // Subtitle
        Text(
          "Record voice notes or share audio\nfiles from WhatsApp.",
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16, 
            color: Theme.of(context).textTheme.bodyMedium?.color,
            height: 1.5
          ),
        ),
        
        const SizedBox(height: 24),
        
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
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)
          ),
        ),
      ],
    );
  }
}