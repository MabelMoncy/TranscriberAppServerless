import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String statusMessage;

  const LoadingView({super.key, required this.statusMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(strokeWidth: 6, color: Colors.blueAccent),
        ),
        const SizedBox(height: 30),
        
        // Status Message (Dynamic Color)
        Text(
          statusMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w500, 
            color: Theme.of(context).textTheme.bodyLarge?.color // <--- FIXED
          ),
        ),
        const SizedBox(height: 10),
        
        // Subtitle (Dynamic Grey)
        Text(
          "This might take a few seconds...",
          style: TextStyle(
            fontSize: 14, 
            color: Theme.of(context).textTheme.bodyMedium?.color // <--- FIXED
          ),
        ),
      ],
    );
  }
}
