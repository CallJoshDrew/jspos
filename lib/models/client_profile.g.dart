// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientProfileAdapter extends TypeAdapter<ClientProfile> {
  @override
  final int typeId = 5;

  @override
  ClientProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientProfile(
      name: fields[0] as String,
      businessRegistrationNumber: fields[1] as String,
      tinNumber: fields[2] as String,
      address1: fields[3] as String,
      address2: fields[4] as String?,
      postcode: fields[5] as String,
      state: fields[6] as String,
      contactNumber: fields[7] as String,
      logoPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.businessRegistrationNumber)
      ..writeByte(2)
      ..write(obj.tinNumber)
      ..writeByte(3)
      ..write(obj.address1)
      ..writeByte(4)
      ..write(obj.address2)
      ..writeByte(5)
      ..write(obj.postcode)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.contactNumber)
      ..writeByte(8)
      ..write(obj.logoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
