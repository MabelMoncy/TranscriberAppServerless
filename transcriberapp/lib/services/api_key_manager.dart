import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyManager {
  // SECURITY CONFIGURATION
  // We explicitly enable EncryptedSharedPreferences.
  // This forces the app to use the Android Keystore (Hardware Security).
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, 
    ),
  );
  
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