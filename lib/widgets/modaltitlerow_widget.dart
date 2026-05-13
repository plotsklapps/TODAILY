import 'package:flutter/material.dart';
import 'package:todaily/themes/iconlibrary.dart';

class ModalTitleRow extends StatelessWidget {
  const ModalTitleRow({
    required this.context,
    required this.title,
    super.key,
  });

  final BuildContext context;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 48),
            Text(title, style: theme.textTheme.titleLarge),
            IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: IconLibrary.iconClose,
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }
}
