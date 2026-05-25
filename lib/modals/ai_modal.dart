import 'dart:async';

import 'package:flutter/gestures.dart';
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadSecrets());
  }

  Future<void> _loadSecrets() async {
    final String? apiKey = await aiService.getApiKey();
    final String? hfToken = await aiService.getHFToken();
    if (apiKey != null) _apiKeyController.text = apiKey;
    if (hfToken != null) _hfTokenController.text = hfToken;
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      if (sAIProvider.value == AIProvider.localGemma) {
        final bool isInstalled = await FlutterGemma.isModelInstalled(
          AIService.localModelId,
        );
        if (!isInstalled) {
          await aiService.downloadModel();
        }
      } else {
        // Mock progress for Gemini API save
        await Future<void>.delayed(const Duration(seconds: 2));
      }

      await aiService.saveApiKey(_apiKeyController.text.trim());
      await aiService.saveHFToken(_hfTokenController.text.trim());
      await settingsService.updateAIProvider(sAIProvider.value);

      ToastService.showSuccess(
        title: 'AI Settings Saved!',
        subtitle: 'Provider and key/token updated.',
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDownloading = sIsDownloading.watch(context);
    final bool isSaving = _isSaving || isDownloading;

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
            children: <Widget>[
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

          // LOCAL GEMMA.
          if (sAIProvider.watch(context) == AIProvider.localGemma)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: <InlineSpan>[
                      const TextSpan(
                        text:
                            'To use the local model, you need a HuggingFace '
                            'account and an access token.\n\n',
                      ),
                      TextSpan(
                        text: '1. Sign up or log in at huggingface.co',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                              'https://huggingface.co/join',
                            );
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          },
                      ),
                      const TextSpan(
                        text:
                            '.\n'
                            '2. Go to Settings > Access Tokens > Create New '
                            'Token.\n'
                            '3. Select "Read" permissions and save it.\n'
                            '4. Visit the model page and agree to the '
                            'conditions:\n',
                      ),
                      TextSpan(
                        text: 'Gemma 3 270m Model Page',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                              'https://huggingface.co/litert-community/gemma-3-270m-it',
                            );
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          },
                      ),
                      const TextSpan(
                        text:
                            '.\n'
                            '5. Paste your token below.',
                      ),
                      TextSpan(
                        text: '\n\nNEVER SHARE YOUR TOKEN WITH ANYONE.',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                TextField(
                  controller: _hfTokenController,
                  decoration: InputDecoration(
                    labelText: 'HuggingFace Access Token',
                    suffixIcon: IconButton(
                      icon: _isTokenVisible
                          ? IconLibrary.iconEyeShut
                          : IconLibrary.iconEyeOpen,
                      onPressed: () {
                        setState(() {
                          _isTokenVisible = !_isTokenVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isTokenVisible,
                ),
              ],
            ),
          if (sAIProvider.watch(context) == AIProvider.geminiApi)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: <InlineSpan>[
                      const TextSpan(
                        text:
                            'To use Gemini, you need a Google AI Studio '
                            'account and an API Key.\n\n',
                      ),
                      TextSpan(
                        text: '1. Sign up or log in at aistudio.google.com',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                              'https://aistudio.google.com/welcome',
                            );
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          },
                      ),
                      const TextSpan(
                        text:
                            '.\n'
                            '2. Go to Get API Key -> Create API key.\n'
                            '3. Follow instructions on creating a project.\n',
                      ),
                      const TextSpan(
                        text: '3. Paste your API Key below.',
                      ),
                      TextSpan(
                        text: '\n\nNEVER SHARE YOUR KEY WITH ANYONE.',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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
              ],
            ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: isSaving ? null : _saveSettings,
                  child: isSaving
                      ? SizedBox(
                          height: 24,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: LinearProgressIndicator(
                                  value:
                                      sAIProvider.value == AIProvider.localGemma
                                      ? sDownloadProgress.watch(context) / 100
                                      : null,
                                ),
                              ),
                              if (sAIProvider.value ==
                                  AIProvider.localGemma) ...[
                                const SizedBox(width: 8),
                                Text('${sDownloadProgress.value}%'),
                              ],
                            ],
                          ),
                        )
                      : const Text('Save Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
