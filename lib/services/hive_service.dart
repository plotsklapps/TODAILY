import 'package:hive_ce/hive.dart';

class HiveService {
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
