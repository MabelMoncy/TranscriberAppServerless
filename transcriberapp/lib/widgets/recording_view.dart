import 'package:flutter/material.dart';

class RecordingView extends StatelessWidget {
  final int duration;
  final VoidCallback onStopRecording;

  const RecordingView({
    Key? key,
    required this.duration,
    required this.onStopRecording,
  }) : super(key: key);

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Recording...",
          style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          _formatDuration(duration),
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w300,
            color: Colors.black, // Dark numbers
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: onStopRecording,
          icon: const Icon(Icons.stop),
          label: const Text("Stop & Transcribe"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}