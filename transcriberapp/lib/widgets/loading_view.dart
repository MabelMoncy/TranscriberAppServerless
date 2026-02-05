import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String statusMessage;

  const LoadingView({Key? key, required this.statusMessage}) : super(key: key);

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
        Text(
          statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          "This might take a few seconds...",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}