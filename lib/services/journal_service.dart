import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/signal_service.dart';

class JournalService {
  late Box<JournalEntry> _journalBox;

  /// Exposes the underlying Hive journal box.
  Box<JournalEntry> get box => _journalBox;

  /// Initializes the journal database, opening 'journalBox'.
  Future<void> init() async {
    _journalBox = await Hive.openBox<JournalEntry>('journalBox');
    sJournalEntries.value = _journalBox.values.toList();
    _journalBox.listenable().addListener(() {
      sJournalEntries.value = _journalBox.values.toList();
    });
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
