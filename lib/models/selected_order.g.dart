// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedOrderAdapter extends TypeAdapter<SelectedOrder> {
  @override
  final int typeId = 2;

  @override
  SelectedOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectedOrder(
      orderNumber: fields[0] as String,
      tableName: fields[1] as String,
      orderType: fields[2] as String,
      orderDate: fields[3] as String,
      orderTime: fields[4] as String,
      status: fields[5] as String,
      items: (fields[6] as List).cast<Item>(),
      subTotal: fields[7] as double,
      serviceCharge: fields[8] as double,
      totalPrice: fields[9] as double,
      paymentMethod: fields[10] as String,
      showEditBtn: fields[11] as bool,
      categoryList: (fields[19] as List).cast<String>(),
      amountReceived: fields[13] as double,
      amountChanged: fields[14] as double,
      roundingAdjustment: fields[15] as double,
      totalQuantity: fields[16] as int,
      paymentTime: fields[17] as String,
      cancelledTime: fields[18] as String,
      discount: fields[20] as int,
    )..categories = (fields[12] as Map).map((dynamic k, dynamic v) =>
        MapEntry(k as String, (v as Map).cast<String, int>()));
  }

  @override
  void write(BinaryWriter writer, SelectedOrder obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.orderNumber)
      ..writeByte(1)
      ..write(obj.tableName)
      ..writeByte(2)
      ..write(obj.orderType)
      ..writeByte(3)
      ..write(obj.orderDate)
      ..writeByte(4)
      ..write(obj.orderTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.items)
      ..writeByte(7)
      ..write(obj.subTotal)
      ..writeByte(8)
      ..write(obj.serviceCharge)
      ..writeByte(9)
      ..write(obj.totalPrice)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.showEditBtn)
      ..writeByte(12)
      ..write(obj.categories)
      ..writeByte(13)
      ..write(obj.amountReceived)
      ..writeByte(14)
      ..write(obj.amountChanged)
      ..writeByte(15)
      ..write(obj.roundingAdjustment)
      ..writeByte(16)
      ..write(obj.totalQuantity)
      ..writeByte(17)
      ..write(obj.paymentTime)
      ..writeByte(18)
      ..write(obj.cancelledTime)
      ..writeByte(19)
      ..write(obj.categoryList)
      ..writeByte(20)
      ..write(obj.discount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
