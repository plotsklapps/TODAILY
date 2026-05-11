// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      dateKey: fields[0] as String,
      description: (fields[1] as List).cast<dynamic>(),
      imagePaths: fields[2] == null
          ? const <String>[]
          : (fields[2] as List).cast<String>(),
      emojis: fields[3] == null
          ? const <String>[]
          : (fields[3] as List).cast<String>(),
      tags: fields[4] == null
          ? const <String>[]
          : (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imagePaths)
      ..writeByte(3)
      ..write(obj.emojis)
      ..writeByte(4)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
