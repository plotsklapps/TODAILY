import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/hive_service.dart';

class JournalService {
  static final Box<JournalEntry> _journalBox = HiveService.getBox<JournalEntry>(
    'journals',
  );

  static Future<void> createJournal(JournalEntry entry) async {
    await _journalBox.put(entry.dateKey, entry);
  }

  static JournalEntry? readJournal(String dateKey) {
    return _journalBox.get(dateKey);
  }

  static Future<void> updateJournal(JournalEntry entry) async {
    await _journalBox.put(entry.dateKey, entry);
  }

  static Future<void> deleteJournal(String dateKey) async {
    await _journalBox.delete(dateKey);
  }

  static String getDateKey(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }
}
