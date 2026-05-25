import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:todaily/services/ai_service.dart';
import 'package:todaily/services/hive_service.dart';
import 'package:todaily/services/journal_service.dart';
import 'package:todaily/services/settings_service.dart';

class ServiceInitializer {
  /// Unifies the startup sequence of all system-level services.
  static Future<void> init() async {
    // 1. Initialize local Hive DB & Register adapters (MUST run first)
    await HiveService.init();

    // 2. Initialize Settings Service
    //    (opens 'settingsBox' and loads cached preferences into Signals)
    await settingsService.init();

    // 3. Initialize Journal Service (opens 'journalBox')
    await journalService.init();

    // 4. Initialize Local Gemma Framework
    final String? token = await aiService.getHuggingFaceToken();
    await FlutterGemma.initialize(
      huggingFaceToken: token,
    );
  }
}
