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
        // Animation Circle
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.mic, size: 60, color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 28),
        
        const Text(
          "Recording...",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w600,
            color: Colors.redAccent 
          ),
        ),
        const SizedBox(height: 10),
        
        // --- TIMER (Dynamic Color) ---
        Text(
          _formatDuration(duration),
          style: TextStyle(
            // Reduced from 48 → 36 to fit proportionally on OPPO A31
            fontSize: 36, 
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        
        const SizedBox(height: 36),
        
        // Stop Button
        GestureDetector(
          onTap: onStopRecording,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.stop_rounded, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Text(
                  "Stop",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}