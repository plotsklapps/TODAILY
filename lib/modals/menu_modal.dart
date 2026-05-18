import 'package:flutter/material.dart';
import 'package:todaily/modals/settings_modal.dart';
import 'package:todaily/modals/themesettings_modal.dart';
import 'package:todaily/screens/wordcloud_screen.dart';
import 'package:todaily/services/modal_service.dart';
import 'package:todaily/themes/iconlibrary.dart';

class MenuModal extends StatelessWidget {
  const MenuModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () async {
            await ModalService.showModal(
              context: context,
              child: const AIModal(),
              title: 'AI Features',
            );
          },
          leading: IconLibrary.iconAIBrain,
          title: const Text('AI SERVICE'),
          subtitle: const Text('Use a LLM within todaily'),
          trailing: IconLibrary.iconNext,
        ),
        ListTile(
          onTap: () async {
            await ModalService.showModal(
              context: context,
              child: const ThemeSettingsModal(),
              title: 'Theme Settings',
            );
          },
          leading: IconLibrary.iconPalette,
          title: const Text('THEME SETTINGS'),
          subtitle: const Text('Change app preferences'),
          trailing: IconLibrary.iconNext,
        ),
        ListTile(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return const WordCloudScreen();
                },
              ),
            );
          },
          leading: IconLibrary.iconCloud,
          title: const Text('WORD CLOUD'),
          subtitle: const Text('See your most frequent used words'),
          trailing: IconLibrary.iconNext,
        ),
      ],
    );
  }
}
