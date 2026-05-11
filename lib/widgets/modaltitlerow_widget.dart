import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ModalTitleRow extends StatelessWidget {
  const ModalTitleRow({
    required this.title,
    super.key,
  });

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
            Text(title, style: theme.textTheme.headlineSmall),
            IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: () {},
              icon: const Icon(LucideIcons.circleX),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }
}
