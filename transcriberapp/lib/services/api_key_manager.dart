import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyManager {
  final _storage = const FlutterSecureStorage();
  
  static const _keyName = "USER_GEMINI_API_KEY";

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyName, value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: _keyName);
  }

  Future<void> deleteKey() async {
    await _storage.delete(key: _keyName);
  }
}