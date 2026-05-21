// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      wakelock: fields[0] == null ? false : fields[0] as bool,
      darkMode: fields[1] == null ? false : fields[1] as bool,
      flexSchemeName: fields[2] == null ? '' : fields[2] as String,
      font: fields[3] == null ? 'Questrial' : fields[3] as String,
      aiProvider: fields[4] == null
          ? AIProvider.geminiApi
          : fields[4] as AIProvider,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.wakelock)
      ..writeByte(1)
      ..write(obj.darkMode)
      ..writeByte(2)
      ..write(obj.flexSchemeName)
      ..writeByte(3)
      ..write(obj.font)
      ..writeByte(4)
      ..write(obj.aiProvider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
