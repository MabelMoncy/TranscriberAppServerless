import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart'; 
import 'api_key_manager.dart';

class GeminiService {
  final ApiKeyManager _keyManager = ApiKeyManager();

  // --- MODEL CONFIGURATION ---
  static const String _primaryModel = "gemini-2.5-pro";
  static const String _secondaryModel = "gemini-2.5-flash";
  static const String _tertiaryModel = "gemini-2.5-flash-lite";

  Future<String> transcribeAudio(File audioFile) async {
    final apiKey = await _keyManager.getApiKey();
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API Key missing. Please restart the app and setup your key.");
    }

    // 1. Smart Mime Type Detection
    String? mimeType = lookupMimeType(audioFile.path);
    
    // Manual overrides for common audio issues
    if (audioFile.path.endsWith('.opus')) {
      mimeType = 'audio/ogg'; // WhatsApp Voice Notes
    } else if (audioFile.path.endsWith('.m4a')) {
      mimeType = 'audio/mp4'; // iOS/Flutter Record
    }
    mimeType ??= 'audio/mp4'; 

    print("📂 File: ${audioFile.path}");
    print("🏷️ Detected Mime: $mimeType");

    final bytes = await audioFile.readAsBytes();
    
    final content = [
      Content.multi([
        TextPart("Transcribe this audio exactly word-for-word. If there is no clear speech, respond with: [NO CLEAR SPEECH]"),
        DataPart(mimeType, bytes), 
      ])
    ];

    // --- 3-LAYER FALLBACK SYSTEM ---
    
    // Level 1: Primary (Gemini 2.5 Pro)
    try {
      print("🚀 Attempting Level 1: $_primaryModel...");
      return await _tryTranscribe(apiKey, _primaryModel, content);
    } catch (e) {
      print("⚠️ $_primaryModel Failed: $e");
      
      // Level 2: Secondary (Gemini 2.5 Flash)
      try {
        print("⚡ Switching to Level 2: $_secondaryModel...");
        return await _tryTranscribe(apiKey, _secondaryModel, content);
      } catch (e2) {
        print("⚠️ $_secondaryModel Failed: $e2");

        // Level 3: Tertiary (Gemini 2.5 Flash-Lite)
        try {
          print("🛡️ Switching to Level 3: $_tertiaryModel...");
          return await _tryTranscribe(apiKey, _tertiaryModel, content);
        } catch (e3) {
          // If all 3 fail, throw the final error
          print("❌ All Models Failed.");
          throw Exception("Transcription failed on all models. Last error: $e3");
        }
      }
    }
  }

  Future<String> _tryTranscribe(String key, String modelName, List<Content> content) async {
    final model = GenerativeModel(
      model: modelName, 
      apiKey: key,
    );

    final response = await model.generateContent(content);
    
    if (response.text == null) throw Exception("Empty response from AI");
    return response.text!;
  }
}