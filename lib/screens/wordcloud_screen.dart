import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todaily/models/journal_entry.dart';

class WordCloudScreen extends StatelessWidget {
  const WordCloudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<JournalEntry> box = Hive.box<JournalEntry>('journals');
    final Map<String, int> frequencies = <String, int>{};
    final Set<String> stopwords = <String>{
      'and',
      'the',
      'a',
      'to',
      'of',
      'in',
      'is',
      'it',
      'for',
      'but',
      'if',
      'i',
      'my',
      'that',
      'was',
    };

    for (final JournalEntry entry in box.values) {
      final String text = entry.description.toString();
      final List<String> words = text.toLowerCase().split(
        RegExp(r'\W+'),
      );
      for (final String word in words) {
        if (word.length > 2 && !stopwords.contains(word)) {
          frequencies[word] = (frequencies[word] ?? 0) + 1;
        }
      }
    }

    final List<MapEntry<String, int>> sortedWords = frequencies.entries.toList()
      ..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) =>
            b.value.compareTo(a.value),
      );
    final List<MapEntry<String, int>> topWords = sortedWords.take(100).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Word Cloud')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: topWords.map((MapEntry<String, int> entry) {
            return Text(
              entry.key,
              style: TextStyle(
                fontSize: 14 + (entry.value * 2.0).clamp(0, 30),
                fontWeight: FontWeight.bold,
                color: Colors
                    .primaries[entry.key.length % Colors.primaries.length],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
