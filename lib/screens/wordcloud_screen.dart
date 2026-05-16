import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/themes/iconlibrary.dart';
import 'package:todaily/themes/stopwordslibrary.dart';

enum TimeRange { last30Days, last3Months, last6Months, lastYear, allTime }

class WordCloudScreen extends StatefulWidget {
  const WordCloudScreen({super.key});

  @override
  State<WordCloudScreen> createState() {
    return _WordCloudScreenState();
  }
}

class _WordCloudScreenState extends State<WordCloudScreen> {
  TimeRange _selectedRange = TimeRange.allTime;

  Map<String, int> _getFrequencies(Box<JournalEntry> box) {
    final Map<String, int> frequencies = <String, int>{};
    final List<String> currentStopwords = stopwords.value;
    final DateTime now = DateTime.now();

    DateTime? cutoff;
    switch (_selectedRange) {
      case TimeRange.last30Days:
        cutoff = now.subtract(const Duration(days: 30));
      case TimeRange.last3Months:
        cutoff = now.subtract(const Duration(days: 90));
      case TimeRange.last6Months:
        cutoff = now.subtract(const Duration(days: 180));
      case TimeRange.lastYear:
        cutoff = now.subtract(const Duration(days: 365));
      case TimeRange.allTime:
        cutoff = null;
    }

    for (final JournalEntry entry in box.values) {
      final DateTime entryDate = DateTime.parse(entry.dateKey);
      if (cutoff != null && entryDate.isBefore(cutoff)) continue;

      final String text = entry.description.toString();
      final List<String> words = text.toLowerCase().split(RegExp(r'\W+'));
      for (final String word in words) {
        if (word.length > 2 && !currentStopwords.contains(word)) {
          frequencies[word] = (frequencies[word] ?? 0) + 1;
        }
      }
    }
    return frequencies;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Box<JournalEntry> box = Hive.box<JournalEntry>('journals');
    final Map<String, int> frequencies = _getFrequencies(box);

    final List<MapEntry<String, int>> sortedWords = frequencies.entries.toList()
      ..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) {
          return b.value.compareTo(a.value);
        },
      );
    final List<MapEntry<String, int>> topWords = sortedWords.take(250).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'wordcloud',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: topWords.map((MapEntry<String, int> entry) {
              final double size =
                  12 + (entry.value.toDouble() * 1.5).clamp(0, 40);
              return Text(
                entry.key,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  color: <Color>[
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary,
                  ][entry.key.length % 3],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _selectedRange = TimeRange
                .values[(_selectedRange.index + 1) % TimeRange.values.length];
          });
        },
        label: Row(
          children: <Widget>[
            IconLibrary.iconInifity,
            const SizedBox(width: 8),
            Text(_rangeToString(_selectedRange)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: IconLibrary.iconBack,
            ),
          ],
        ),
      ),
    );
  }

  String _rangeToString(TimeRange range) {
    switch (range) {
      case TimeRange.last30Days:
        return '30 Days';
      case TimeRange.last3Months:
        return '3 Months';
      case TimeRange.last6Months:
        return '6 Months';
      case TimeRange.lastYear:
        return '1 Year';
      case TimeRange.allTime:
        return 'All Time';
    }
  }
}
