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
  bool _isApiKeyVisible = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadKey());
  }

  Future<void> _loadKey() async {
    final String? key = await aiService.getApiKey();
    if (key != null) {
      _apiKeyController.text = key;
    }
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
    await settingsService.updateAIProvider(sAIProvider.value);

    ToastService.showSuccess(
      title: 'Settings Saved',
      subtitle: 'AI provider and API key updated.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'todaily lets you use your own Gemini API key for text generation, '
          'journal insights, and chat features.\n\nYour data is sent directly '
          'to Google’s Gemini API and is never stored or shared by todaily.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SegmentedButton<AIProvider>(
          segments: const <ButtonSegment<AIProvider>>[
            ButtonSegment<AIProvider>(
              value: AIProvider.geminiApi,
              label: Text('Gemini API'),
              icon: Icon(Icons.cloud),
            ),
            ButtonSegment<AIProvider>(
              value: AIProvider.localGemma,
              label: Text('Local Gemma'),
              icon: Icon(Icons.smartphone),
            ),
          ],
          selected: <AIProvider>{sAIProvider.watch(context)},
          onSelectionChanged: (Set<AIProvider> newSelection) {
            sAIProvider.value = newSelection.first;
          },
        ),
        const SizedBox(height: 24),
        if (sAIProvider.watch(context) == AIProvider.localGemma)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  '⚠️ Large Download',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Downloading the local Gemma model requires ~300MB of data. '
                  'Please use Wi-Fi if possible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                if (sIsDownloading.watch(context)) ...<Widget>[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: sDownloadProgress.watch(context) / 100,
                  ),
                  const SizedBox(height: 8),
                  Text('${sDownloadProgress.value}%'),
                ],
              ],
            ),
          ),
        const SizedBox(height: 24),
        if (sAIProvider.watch(context) == AIProvider.geminiApi)
          TextField(
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
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://ai.google.dev/gemini-api/docs/api-key',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('Get API Key'),
              ),
            ),
            const SizedBox(width: 8),
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
    );
  }
}
