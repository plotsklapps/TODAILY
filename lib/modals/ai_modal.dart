import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:todaily/services/ai_service.dart';
import 'package:todaily/services/settings_service.dart';
import 'package:todaily/services/signal_service.dart';
import 'package:todaily/services/toast_service.dart';
import 'package:todaily/themes/iconlibrary.dart';
import 'package:url_launcher/url_launcher.dart';

class AIModal extends StatefulWidget {
  const AIModal({super.key});

  @override
  State<AIModal> createState() {
    return _AIModalState();
  }
}

class _AIModalState extends State<AIModal> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _hfTokenController = TextEditingController();
  bool _isApiKeyVisible = false;
  bool _isTokenVisible = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadSecrets());
  }

  Future<void> _loadSecrets() async {
    final String? apiKey = await aiService.getApiKey();
    final String? hfToken = await aiService.getHuggingFaceToken();
    if (apiKey != null) _apiKeyController.text = apiKey;
    if (hfToken != null) _hfTokenController.text = hfToken;
  }

  Future<void> _saveSettings() async {
    if (sAIProvider.value == AIProvider.localGemma) {
      final bool isInstalled = await FlutterGemma.isModelInstalled(
        AIService.localModelId,
      );
      if (!isInstalled) {
        await aiService.downloadModel();
        if (sIsDownloading.value) return; // Wait for download
      }
    }

    await aiService.saveApiKey(_apiKeyController.text);
    await aiService.saveHuggingFaceToken(_hfTokenController.text);
    await settingsService.updateAIProvider(sAIProvider.value);

    ToastService.showSuccess(
      title: 'Settings Saved',
      subtitle: 'AI provider and keys updated.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'todaily keeps your AI usage private and secure. You can use your '
            'own Gemini API key, or download a compact LLM directly to your '
            'device for full offline capability.\n\n'
            'Both options ensure your data remains yours and is never stored '
            'or shared by todaily.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SegmentedButton<AIProvider>(
                  segments: <ButtonSegment<AIProvider>>[
                    ButtonSegment<AIProvider>(
                      value: AIProvider.geminiApi,
                      label: const Text('Gemini API'),
                      icon: IconLibrary.iconUpload,
                    ),
                    ButtonSegment<AIProvider>(
                      value: AIProvider.localGemma,
                      label: const Text('Local Gemma'),
                      icon: IconLibrary.iconDownload,
                    ),
                  ],
                  selected: <AIProvider>{sAIProvider.watch(context)},
                  onSelectionChanged: (Set<AIProvider> newSelection) {
                    sAIProvider.value = newSelection.first;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (sAIProvider.watch(context) == AIProvider.localGemma)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To use the local model, you need a HuggingFace access token. '
                  'Go to huggingface.co, log in, go to Settings > Access Tokens, '
                  'and create a new token with "Read" permissions.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.primary),
                  ),
                  child: sIsDownloading.watch(context)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: sDownloadProgress.watch(context) / 100,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${sDownloadProgress.value}%'),
                            ],
                          ),
                        )
                      : TextField(
                          controller: _hfTokenController,
                          decoration: InputDecoration(
                            labelText: 'HuggingFace Access Token',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isTokenVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isTokenVisible = !_isTokenVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isTokenVisible,
                        ),
                ),
              ],
            ),
          if (sAIProvider.watch(context) == AIProvider.geminiApi)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To use the Gemini API, you need an API key. '
                  'Visit ai.google.dev, log in with your Google account, '
                  'and create a new API key in the Google AI Studio.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'Gemini API Key',
                      suffixIcon: IconButton(
                        icon: _isApiKeyVisible
                            ? IconLibrary.iconEyeShut
                            : IconLibrary.iconEyeOpen,
                        onPressed: () {
                          setState(() {
                            _isApiKeyVisible = !_isApiKeyVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isApiKeyVisible,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: sIsDownloading.value ? null : _saveSettings,
                  child: Text(
                    sIsDownloading.watch(context)
                        ? 'Downloading...'
                        : 'Save Settings',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
