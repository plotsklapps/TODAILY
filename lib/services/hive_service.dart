import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/models/settings_model.dart';

class HiveService {
  /// Initializes Hive database and registers model adapters.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(JournalEntryAdapter())
      ..registerAdapter(SettingsAdapter());
  }

  static Future<void> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }
  }

  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  static Future<void> closeBox(String boxName) async {
    final Box<dynamic> box = Hive.box<dynamic>(boxName);
    await box.close();
  }

  static Future<void> deleteBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }
}
