// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdersAdapter extends TypeAdapter<Orders> {
  @override
  final int typeId = 1;

  @override
  Orders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Orders(
      data: (fields[0] as List?)?.cast<SelectedOrder>(),
    );
  }

  @override
  void write(BinaryWriter writer, Orders obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
