// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrinterAdapter extends TypeAdapter<Printer> {
  @override
  final int typeId = 3;

  @override
  Printer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Printer(
      name: fields[0] as String,
      macAddress: fields[1] as String,
      isConnected: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Printer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.macAddress)
      ..writeByte(2)
      ..write(obj.isConnected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
