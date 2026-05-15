import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AIService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _apiKeyKey = 'gemini_api_key';

  static Future<void> saveApiKey(String key) async {
    await _storage.write(key: _apiKeyKey, value: key);
  }

  static Future<String?> getApiKey() {
    return _storage.read(key: _apiKeyKey);
  }

  static Future<String> generateText(String prompt) async {
    final String? apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key not found');
    }

    // Use Gemini 3.1 Flash Lite for now to keep costs low and speed high.
    final GenerativeModel model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
    );

    final GenerateContentResponse response = await model.generateContent(
      <Content>[Content.text(prompt)],
    );

    return response.text ?? 'No response';
  }
}
