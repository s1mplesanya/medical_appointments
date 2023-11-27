// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 2;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      kod: fields[0] as String,
      name: fields[1] as String,
      active: fields[2] as String,
      del: fields[3] as String,
      price: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.kod)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.active)
      ..writeByte(3)
      ..write(obj.del)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
