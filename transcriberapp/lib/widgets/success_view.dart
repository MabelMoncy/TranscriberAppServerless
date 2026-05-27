import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'gradient_button.dart';
import '../models/transcription_record.dart'; 

class SuccessView extends StatelessWidget {
  final List<TranscriptionRecord> results; 
  final VoidCallback onReset;

  const SuccessView({
    Key? key,
    required this.results,
    required this.onReset,
  }) : super(key: key);

  void _onShare(String text) {
    if (text.isNotEmpty) {
      SharePlus.instance.share(ShareParams(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Header ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.green, size: 40),
        ),
        const SizedBox(height: 16),
        
        // --- Count Text ---
        Text(
          "${results.length} Transcription${results.length > 1 ? 's' : ''} Complete",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            // Reduced 20 → 17 so the full text fits in one line on OPPO A31
            fontSize: 17, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).textTheme.bodyLarge?.color
          ),
        ),
        const SizedBox(height: 16),

        // --- List of Cards ---
        // Uses 50% of screen height instead of a fixed 450px to adapt
        // gracefully between small Android 9 16:9 screens and large modern
        // displays without causing pixel overflow.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.50,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: results.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final record = results[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // <--- Dynamic Card
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // <--- Dynamic Shadow
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            record.fileName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 13,
                              color: Theme.of(context).textTheme.bodyLarge?.color // <--- Dynamic
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onShare(record.transcription),
                          icon: const Icon(Icons.share_rounded, size: 20, color: Color(0xFF448AFF)),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    
                    Divider(height: 20, color: Theme.of(context).dividerColor),
                    
                    SelectableText(
                      record.transcription,
                      style: TextStyle(
                        fontSize: 16, 
                        height: 1.5, 
                        color: Theme.of(context).textTheme.bodyLarge?.color // <--- Dynamic
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: GradientButton(
            text: "Transcribe New",
            icon: Icons.refresh_rounded,
            onPressed: onReset,
          ),
        ),
      ],
    );
  }
}