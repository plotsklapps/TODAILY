import 'package:hive_ce/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  JournalEntry({
    required this.dateKey,
    required this.description,
    this.imagePaths = const <String>[],
    this.emojis = const <String>[],
    this.tags = const <String>[],
  });
  @HiveField(0)
  final String dateKey; // yyyyMMdd

  @HiveField(1)
  final List<dynamic> description;

  @HiveField(2)
  final List<String> imagePaths;

  @HiveField(3)
  final List<String> emojis;

  @HiveField(4)
  final List<String> tags;
}
