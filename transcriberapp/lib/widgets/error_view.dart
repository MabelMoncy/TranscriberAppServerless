import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String? errorMessage;
  final bool isAccidental;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.errorMessage,
    required this.isAccidental,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAccidental ? Icons.mic_off : Icons.error_outline,
            size: 80,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          
          // Title (Dynamic)
          Text(
            isAccidental ? "No Speech Detected" : "Something Went Wrong",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Theme.of(context).textTheme.bodyLarge?.color // <--- FIXED
            ),
          ),
          const SizedBox(height: 10),
          
          // Error Message (Dynamic)
          Text(
            errorMessage ?? "An unknown error occurred.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, 
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8) // <--- FIXED
            ),
          ),
          const SizedBox(height: 40),
          
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}