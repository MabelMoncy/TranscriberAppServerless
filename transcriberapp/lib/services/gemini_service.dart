import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart'; 
import 'api_key_manager.dart';

class GeminiService {
  final ApiKeyManager _keyManager = ApiKeyManager();

  // Models
  static const String _primaryModel = "gemini-2.5-pro";
  static const String _secondaryModel = "gemini-2.5-flash";
  static const String _tertiaryModel = "gemini-2.5-flash-lite";

  Future<String> transcribeAudio(File audioFile) async {
    final apiKey = await _keyManager.getApiKey();
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API Key missing. Please restart the app and setup your key.");
    }

    // Smart Mime Type
    String? mimeType = lookupMimeType(audioFile.path);
    if (audioFile.path.endsWith('.opus')) {
      mimeType = 'audio/ogg'; 
    } else if (audioFile.path.endsWith('.m4a')) {
      mimeType = 'audio/mp4'; 
    }
    mimeType ??= 'audio/mp4'; 

    final bytes = await audioFile.readAsBytes();
    
    final content = [
      Content.multi([
        // Simple prompt: Allows the AI to handle grammar/summarization naturally
        TextPart("Transcribe this audio."),
        DataPart(mimeType, bytes), 
      ])
    ];

    // Fallback System
    try {
      print("🚀 Level 1: $_primaryModel");
      return await _tryTranscribe(apiKey, _primaryModel, content);
    } catch (e) {
      print("⚠️ $_primaryModel Failed: $e");
      // Backoff: If quota/rate-limit error, give the API a 2-second
      // breathing window before hammering the next tier.
      final isQuotaError = e.toString().contains("Quota exceeded") ||
          e.toString().contains("429");
      if (isQuotaError) {
        print("⏳ Quota hit — waiting 2s before Level 2...");
        await Future.delayed(const Duration(seconds: 2));
      }
      try {
        print("⚡ Level 2: $_secondaryModel");
        return await _tryTranscribe(apiKey, _secondaryModel, content);
      } catch (e2) {
        print("⚠️ $_secondaryModel Failed: $e2");
        try {
          print("🛡️ Level 3: $_tertiaryModel");
          return await _tryTranscribe(apiKey, _tertiaryModel, content);
        } catch (e3) {
          print("⚠️ $_tertiaryModel Failed: $e3");
          throw Exception("Transcription failed. Please check internet/key.");
        }
      }
    }
  }

  Future<String> _tryTranscribe(String key, String modelName, List<Content> content) async {
    final model = GenerativeModel(
      model: modelName, 
      apiKey: key,
      // We keep temperature 0 to prevent hallucinations (making up fake text),
      // but we removed the strict prompt constraints so it flows naturally.
      generationConfig: GenerationConfig(
        temperature: 0,
        candidateCount: 1,
      ),
    );

    final response = await model.generateContent(content);
    if (response.text == null) throw Exception("Empty response from AI");
    return response.text!;
  }
}