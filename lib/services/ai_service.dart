import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/models/settings_model.dart';

enum AIProvider {
  geminiApi,
  localGemma,
}

final Signal<AIProvider> sAIProvider = Signal<AIProvider>(
  AIProvider.geminiApi,
  debugLabel: 'sAIProvider',
);

final Signal<bool> sIsDownloading = Signal<bool>(
  false,
  debugLabel: 'sIsDownloading',
);
final Signal<int> sDownloadProgress = Signal<int>(
  0,
  debugLabel: 'sDownloadProgress',
);

class AIService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _apiKeyKey = 'gemini_api_key';
  static const String localModelId = 'gemma3-270m-it-q8.litertlm';
  static const String localModelUrl =
      'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.litertlm';

  static Future<void> downloadModel() async {
    sIsDownloading.value = true;
    sDownloadProgress.value = 0;

    try {
      const String token = String.fromEnvironment('HUGGINGFACE_TOKEN');
      await FlutterGemma.installModel(
            modelType: ModelType.gemmaIt,
          )
          .fromNetwork(localModelUrl, token: token.isNotEmpty ? token : null)
          .withProgress((progress) {
            sDownloadProgress.value = progress;
          })
          .install();
    } finally {
      sIsDownloading.value = false;
    }
  }

  static Future<void> saveApiKey(String key) async {
    await _storage.write(key: _apiKeyKey, value: key);
  }

  static Future<String?> getApiKey() {
    return _storage.read(key: _apiKeyKey);
  }

  static Future<String> generateText(String prompt) async {
    final Settings settings = Hive.box<Settings>('settings').get(0)!;

    if (settings.aiProvider == AIProvider.localGemma) {
      final model = await FlutterGemma.getActiveModel(maxTokens: 2048);
      final chat = await model.createChat();
      await chat.addQuery(Message.text(text: prompt, isUser: true));
      final response = await chat.generateChatResponse();
      if (response is TextResponse) {
        return response.token;
      }
      return 'No response';
    }

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

  static Future<String> generateTitle(String description) async {
    const String prompt =
        'Write a descriptive title for this journal entry. '
        'Output ONLY the title, 3-10 words max, no other text.';

    // Pass the description as part of the prompt
    return generateText('$prompt\n\n$description');
  }
}
