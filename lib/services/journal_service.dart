import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:todaily/models/journal_entry.dart';

class JournalService {
  late Box<JournalEntry> _journalBox;

  Future<void> init() async {
    _journalBox = await Hive.openBox<JournalEntry>('journals');
  }

  Future<void> createJournal(JournalEntry entry) async {
    await _journalBox.put(entry.dateKey, entry);
  }

  JournalEntry? readJournal(String dateKey) {
    return _journalBox.get(dateKey);
  }

  Future<void> updateJournal(JournalEntry entry) async {
    await _journalBox.put(entry.dateKey, entry);
  }

  Future<void> deleteJournal(String dateKey) async {
    await _journalBox.delete(dateKey);
  }

  String getDateKey(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }
}

final JournalService journalService = JournalService();
