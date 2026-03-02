// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmHistoryAdapter extends TypeAdapter<AlarmHistory> {
  @override
  final int typeId = 2;

  @override
  AlarmHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmHistory(
      id: fields[0] as String,
      alarmTime: fields[1] as DateTime,
      answeredTime: fields[2] as DateTime,
      success: fields[3] as bool,
      category: fields[4] as String,
      duration: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.alarmTime)
      ..writeByte(2)
      ..write(obj.answeredTime)
      ..writeByte(3)
      ..write(obj.success)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
