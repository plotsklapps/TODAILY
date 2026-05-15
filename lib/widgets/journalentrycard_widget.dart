import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/screens/journaleditor_screen.dart';
import 'package:todaily/themes/emojilibrary.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    required this.entry,
    super.key,
  });

  final JournalEntry entry;

  String _getOrdinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime entryDate = DateTime.parse(entry.dateKey);
    // Removed unused formattedDate as it is now constructed inline.
    final String descriptionText = Document.fromJson(
      entry.description,
    ).toPlainText();
    final List<String> words = descriptionText.trim().split(RegExp(r'\s+'));
    final String title =
        words.take(4).join(' ') + (words.length > 4 ? '...' : '');

    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Card(
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) {
                  return JournalEditorScreen(
                    date: DateTime.parse(entry.dateKey),
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                // EMOJI'S.
                if (entry.emojis.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: entry.emojis.take(3).map((String emojiKey) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: getEmojiWidget(emojiKey),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(width: 12),
                // JOURNAL ENTRY.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${entryDate.day}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: _getOrdinal(entryDate.day),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        descriptionText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // IMAGES.
                if (entry.imagePaths.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 120,
                      height: 100,
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: entry.imagePaths.take(6).map((String path) {
                          final double itemWidth = entry.imagePaths.length > 1
                              ? (120 / 2 - 2)
                              : 120;
                          final double itemHeight = entry.imagePaths.length > 2
                              ? (100 / 3 - 2)
                              : (entry.imagePaths.length > 1 ? 100 : 100);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              width: itemWidth,
                              height: itemHeight,
                              child: Image.file(
                                File(path),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
