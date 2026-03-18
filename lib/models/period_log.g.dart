// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeriodLogAdapter extends TypeAdapter<PeriodLog> {
  @override
  final int typeId = 0;

  @override
  PeriodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeriodLog(
      startDate: fields[0] as DateTime,
      duration: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PeriodLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
