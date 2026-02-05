import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyManager {
  // We use the secure storage to encrypt the data
  final _storage = const FlutterSecureStorage();
  static const _keyName = "USER_GEMINI_API_KEY";

  // Save Key
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyName, value: apiKey);
  }

  // Get Key
  Future<String?> getApiKey() async {
    return await _storage.read(key: _keyName);
  }

  // Reset (for when user wants to change key or logout)
  Future<void> deleteKey() async {
    await _storage.delete(key: _keyName);
  }
}