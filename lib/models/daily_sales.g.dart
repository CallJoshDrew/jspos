// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_sales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySalesAdapter extends TypeAdapter<DailySales> {
  @override
  final int typeId = 0;

  @override
  DailySales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySales(
      orders: (fields[0] as List).cast<SelectedOrder>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailySales obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.orders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
