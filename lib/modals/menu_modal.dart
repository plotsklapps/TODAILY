import 'package:flutter/material.dart';
import 'package:todaily/modals/settings_modal.dart';
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
              child: const SettingsModal(),
              title: 'AI Features',
            );
          },
          leading: IconLibrary.iconSettings,
          title: const Text('SETTINGS'),
          subtitle: const Text('Change app preferences'),
          trailing: IconLibrary.iconNext,
        ),
      ],
    );
  }
}
