import 'package:flutter/material.dart';
import 'package:todaily/services/signal_service.dart';
import 'package:todaily/services/toast_service.dart';
import 'package:todaily/themes/emojilibrary.dart';

class EmojiPickerModal extends StatefulWidget {
  const EmojiPickerModal({
    required this.onNext,
    super.key,
  });
  final VoidCallback onNext;

  @override
  State<EmojiPickerModal> createState() {
    return _EmojiPickerModalState();
  }
}

class _EmojiPickerModalState extends State<EmojiPickerModal> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> availableEmojis = sAvailableEmojis.watch(context);
    final List<String> selectedEmojis = sSelectedEmojis.watch(context);

    return Column(
      children: <Widget>[
        Text(
          'Please choose 1 to 3 emojis to express how your '
          'day felt.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: availableEmojis.map((String emojiKey) {
            final bool isSelected = selectedEmojis.contains(emojiKey);
            return ChoiceChip(
              label: getEmojiWidget(emojiKey),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (bool selected) {
                final List<String> current = List<String>.from(
                  sSelectedEmojis.value,
                );
                if (selected) {
                  if (current.length < 3) {
                    current.add(emojiKey);
                    sSelectedEmojis.value = current;
                  }
                } else {
                  current.remove(emojiKey);
                  sSelectedEmojis.value = current;
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton(
                onPressed: () {
                  if (selectedEmojis.isEmpty) {
                    ToastService.showWarning(
                      title: 'Select an Emoji',
                      subtitle: 'Choose at least one emoji to continue.',
                    );
                    return;
                  } else {
                    widget.onNext();
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
