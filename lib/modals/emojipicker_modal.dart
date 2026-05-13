import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../themes/emojilibrary.dart';

// We store the keys (String) in Hive for JournalEntry.
final Signal<List<String>> sSelectedEmojis = Signal<List<String>>(
  <String>[],
  debugLabel: 'sSelectedEmojis',
);

final Signal<List<String>> sAvailableEmojis = Signal<List<String>>(
  kEmojiMap.keys.toList(),
  debugLabel: 'sAvailableEmojis',
);

class EmojiPickerModal extends StatelessWidget {
  const EmojiPickerModal({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> availableEmojis = sAvailableEmojis.watch(context);
    final List<String> selectedEmojis = sSelectedEmojis.watch(context);

    return Column(
      children: <Widget>[
        Text('Select 1-3 emojis', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: availableEmojis.map((String emojiKey) {
            final bool isSelected = selectedEmojis.contains(emojiKey);
            return FilterChip(
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
      ],
    );
  }
}
