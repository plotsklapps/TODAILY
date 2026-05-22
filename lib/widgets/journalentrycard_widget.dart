import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/screens/journaleditor_screen.dart';
import 'package:todaily/themes/emojilibrary.dart';
import 'package:todaily/utils/extensions.dart';
import 'package:todaily/widgets/journalimagesrow_widget.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    required this.entry,
    super.key,
  });

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime entryDate = DateTime.parse(entry.dateKey);
    final String descriptionText = Document.fromJson(
      entry.description,
    ).toPlainText();

    // AI Title Logic
    final String displayTitle = entry.aiTitle ?? 'Generating title...';
    final bool isAiTitleLoading = entry.aiTitle == null;

    return Card(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                text: entryDate.day.ordinalSuffix,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: entry.emojis.take(3).map((
                            String emojiKey,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: getEmojiWidget(emojiKey),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      displayTitle,
                      maxLines: 2,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    if (isAiTitleLoading)
                      const SizedBox(
                        height: 2,
                        width: 50,
                        child: LinearProgressIndicator(),
                      ),

                    Text(
                      descriptionText,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                    JournalImagesRow(
                      imagePaths: entry.imagePaths,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
