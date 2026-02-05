import 'package:flutter/material.dart';

class FileSharedView extends StatelessWidget {
  final String fileName;
  final VoidCallback onStartTranscription;

  const FileSharedView({
    Key? key,
    required this.fileName,
    required this.onStartTranscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.audio_file, size: 80, color: Colors.blueAccent),
        const SizedBox(height: 24),
        Text(
          "File Selected",
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Text(
          fileName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: onStartTranscription,
          icon: const Icon(Icons.transcribe),
          label: const Text("Transcribe Now"),
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