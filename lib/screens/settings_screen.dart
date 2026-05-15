import 'package:flutter/material.dart';
import 'package:todaily/services/ai_service.dart';
import 'package:todaily/services/toast_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKey();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(labelText: 'Gemini API Key'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _saveKey, child: const Text('Save Key')),
          ],
        ),
      ),
    );
  }
}
