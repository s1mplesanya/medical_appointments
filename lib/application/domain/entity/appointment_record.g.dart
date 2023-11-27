// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentRecordAdapter extends TypeAdapter<AppointmentRecord> {
  @override
  final int typeId = 3;

  @override
  AppointmentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentRecord(
      selectedDoctor: fields[0] as Doctor,
      selectedServices: (fields[1] as List).cast<Service>(),
      selectedDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.selectedDoctor)
      ..writeByte(1)
      ..write(obj.selectedServices)
      ..writeByte(2)
      ..write(obj.selectedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
