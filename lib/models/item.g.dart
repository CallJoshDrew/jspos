// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 2;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[5] as double,
      category: fields[3] as String,
      quantity: fields[4] as int,
      image: fields[7] as String,
      selection: fields[8] as bool,
      choices: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      types: (fields[10] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      meatPortion: (fields[11] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      meePortion: (fields[12] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      addOn: (fields[14] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      selectedChoice: (fields[15] as Map?)?.cast<String, dynamic>(),
      selectedType: (fields[16] as Map?)?.cast<String, dynamic>(),
      selectedMeatPortion: (fields[17] as Map?)?.cast<String, dynamic>(),
      selectedMeePortion: (fields[18] as Map?)?.cast<String, dynamic>(),
      selectedAddOn: (fields[19] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toSet(),
      itemRemarks: (fields[20] as Map?)?.cast<String, dynamic>(),
      originalName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.originalName)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.originalPrice)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.selection)
      ..writeByte(9)
      ..write(obj.choices)
      ..writeByte(10)
      ..write(obj.types)
      ..writeByte(11)
      ..write(obj.meatPortion)
      ..writeByte(12)
      ..write(obj.meePortion)
      ..writeByte(14)
      ..write(obj.addOn)
      ..writeByte(15)
      ..write(obj.selectedChoice)
      ..writeByte(16)
      ..write(obj.selectedType)
      ..writeByte(17)
      ..write(obj.selectedMeatPortion)
      ..writeByte(18)
      ..write(obj.selectedMeePortion)
      ..writeByte(19)
      ..write(obj.selectedAddOn?.toList())
      ..writeByte(20)
      ..write(obj.itemRemarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
