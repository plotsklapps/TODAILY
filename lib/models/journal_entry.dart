import 'package:hive_ce/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  JournalEntry({
    required this.dateKey,
    required this.description,
    required this.imagePaths,
    required this.emojis,
    this.tags = const <String>[],
    this.aiTitle,
  });

  @HiveField(0)
  final String dateKey;

  @HiveField(1)
  final List<dynamic> description;

  @HiveField(2)
  final List<String> imagePaths;

  @HiveField(3)
  final List<String> emojis;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final String? aiTitle;
}
