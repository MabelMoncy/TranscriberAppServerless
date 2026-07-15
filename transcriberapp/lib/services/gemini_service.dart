import 'dart:io' as io;
import 'package:googleai_dart/googleai_dart.dart';
import 'package:mime/mime.dart';
import 'api_key_manager.dart';

class GeminiService {
  final ApiKeyManager _keyManager = ApiKeyManager();

  // Ordered fallback chain: try each model in sequence.
  // 1. gemini-2.5-flash  — fast, capable primary model
  // 2. gemini-3.5-flash  — latest generation backup
  // 3. gemini-3.1-flash-lite — lightweight final fallback
  static const List<String> _models = [
    'gemini-2.5-flash',
    'gemini-3.5-flash',
    'gemini-3.1-flash-lite',
  ];

  /// Single entry point for the UI — takes a file, returns transcribed text.
  /// Handles the entire model fallback chain internally.
  Future<String> transcribeAudio(io.File audioFile) async {
    final apiKey = await _keyManager.getApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw Exception(
        'API Key missing. Please restart the app and set up your key.',
      );
    }

    // Resolve MIME type for common WhatsApp audio formats
    final mimeType = _resolveMimeType(audioFile.path);
    final bytes = await audioFile.readAsBytes();

    // Build the content payload once — reused across all model attempts
    final request = GenerateContentRequest(
      contents: [
        Content.user([
          Part.text('Transcribe this audio.'),
          Part.bytes(bytes, mimeType),
        ]),
      ],
      generationConfig: const GenerationConfig(
        temperature: 0,
        candidateCount: 1,
      ),
    );

    // Create one client with the user's API key
    final client = GoogleAIClient(
      config: GoogleAIConfig.googleAI(
        authProvider: ApiKeyProvider(apiKey),
      ),
    );

    try {
      Exception? lastError;

      for (final modelName in _models) {
        try {
          print('🚀 Trying model: $modelName');
          final response = await client.models.generateContent(
            model: modelName,
            request: request,
          );
          final text = response.text;
          if (text == null || text.isEmpty) {
            throw Exception('Empty response from $modelName');
          }
          return text; // Success — exit immediately
        } on RateLimitException catch (e) {
          // Quota / rate-limit hit — wait before trying the next model
          print('⏳ Rate limit on $modelName — waiting 2s...');
          lastError = e;
          await Future.delayed(const Duration(seconds: 2));
        } on ApiException catch (e) {
          // Region error, safety block, or other API-level failure
          print('⚠️ API error on $modelName: ${e.message}');
          lastError = e;
        } catch (e) {
          // Unexpected error — log and try next model
          print('⚠️ $modelName failed: $e');
          lastError = e is Exception ? e : Exception(e.toString());
        }
      }

      // All models exhausted
      throw lastError ??
          Exception('Transcription failed. Please check internet/key.');
    } finally {
      client.close();
    }
  }

  /// Resolves MIME type for common WhatsApp audio formats.
  /// Falls back to 'audio/mp4' if the type cannot be determined.
  String _resolveMimeType(String filePath) {
    if (filePath.endsWith('.opus')) return 'audio/ogg';
    if (filePath.endsWith('.m4a')) return 'audio/mp4';
    return lookupMimeType(filePath) ?? 'audio/mp4';
  }
}