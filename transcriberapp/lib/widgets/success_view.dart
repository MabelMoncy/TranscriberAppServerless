import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'gradient_button.dart';

class SuccessView extends StatelessWidget {
  final String? transcribedText;
  final VoidCallback onCopy;
  final VoidCallback onReset;

  const SuccessView({
    Key? key,
    required this.transcribedText,
    required this.onCopy,
    required this.onReset,
  }) : super(key: key);

  void _onShare() {
    if (transcribedText != null && transcribedText!.isNotEmpty) {
      Share.share(transcribedText!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Success Icon ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.green, size: 40),
        ),
        const SizedBox(height: 20),
        
        // --- The Card ---
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Transcription", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded, color: Color(0xFF448AFF)),
                    tooltip: "Copy",
                  )
                ],
              ),
              const Divider(height: 30),
              Container(
                constraints: const BoxConstraints(minHeight: 150, maxHeight: 350),
                child: SingleChildScrollView(
                  child: SelectableText(
                    transcribedText ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF2D3436)),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // --- Action Buttons ---
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("New"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF448AFF), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  foregroundColor: const Color(0xFF448AFF),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2, // Share button is bigger
              child: GradientButton(
                text: "Share",
                icon: Icons.share_rounded,
                onPressed: _onShare,
              ),
            ),
          ],
        ),
      ],
    );
  }
}