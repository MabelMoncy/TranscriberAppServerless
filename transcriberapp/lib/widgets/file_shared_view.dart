import 'package:flutter/material.dart';

class FileSharedView extends StatelessWidget {
  final String fileName;
  final VoidCallback onStartTranscription;

  const FileSharedView({
    super.key,
    required this.fileName,
    required this.onStartTranscription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.audio_file, size: 80, color: Colors.blueAccent),
        const SizedBox(height: 24),
        
        // "File Selected" Label
        Text(
          "File Selected",
          style: TextStyle(
            fontSize: 18, 
            color: Theme.of(context).textTheme.bodyMedium?.color // <--- FIXED
          ),
        ),
        const SizedBox(height: 8),
        
        // File Name (Dynamic)
        Text(
          fileName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).textTheme.bodyLarge?.color // <--- FIXED
          ),
        ),
        const SizedBox(height: 40),
        
        ElevatedButton.icon(
          onPressed: onStartTranscription,
          icon: const Icon(Icons.transcribe),
          label: const Text("Start Transcription"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}
