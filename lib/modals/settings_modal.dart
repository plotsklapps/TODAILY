import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todaily/services/ai_service.dart';
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
    final String? key = await AIService.getApiKey();
    if (key != null) {
      _apiKeyController.text = key;
    }
  }

  Future<void> _saveKey() async {
    await AIService.saveApiKey(_apiKeyController.text);
    ToastService.showSuccess(
      title: 'Key Saved',
      subtitle: 'Gemini API key updated.',
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
                onPressed: _saveKey,
                child: const Text('Save API Key'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
