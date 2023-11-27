// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorAdapter extends TypeAdapter<Doctor> {
  @override
  final int typeId = 1;

  @override
  Doctor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Doctor(
      kod: fields[0] as String,
      name: fields[1] as String,
      filial: fields[2] as String,
      dolzhnost: fields[3] as String,
      img: fields[4] as String,
      active: fields[5] as String,
      del: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.kod)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.filial)
      ..writeByte(3)
      ..write(obj.dolzhnost)
      ..writeByte(4)
      ..write(obj.img)
      ..writeByte(5)
      ..write(obj.active)
      ..writeByte(6)
      ..write(obj.del);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
