// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 3;

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
      drinks: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      choices: (fields[10] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      noodlesTypes: (fields[11] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      meatPortion: (fields[12] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      meePortion: (fields[13] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      sides: (fields[14] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      addOns: (fields[15] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      temp: (fields[17] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      selectedTemp: (fields[18] as Map?)?.cast<String, String>(),
      selectedNoodlesType: (fields[20] as Map?)?.cast<String, dynamic>(),
      selectedMeatPortion: (fields[21] as Map?)?.cast<String, dynamic>(),
      selectedMeePortion: (fields[22] as Map?)?.cast<String, dynamic>(),
      selectedSide: (fields[23] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toSet(),
      selectedAddOn: (fields[24] as Map?)?.cast<String, dynamic>(),
      itemRemarks: (fields[25] as Map?)?.cast<String, dynamic>(),
      originalName: fields[2] as String,
    )
      .._selectedDrink = (fields[16] as Map?)?.cast<String, dynamic>()
      .._selectedChoice = (fields[19] as Map?)?.cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(26)
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
      ..write(obj.drinks)
      ..writeByte(10)
      ..write(obj.choices)
      ..writeByte(11)
      ..write(obj.noodlesTypes)
      ..writeByte(12)
      ..write(obj.meatPortion)
      ..writeByte(13)
      ..write(obj.meePortion)
      ..writeByte(14)
      ..write(obj.sides)
      ..writeByte(15)
      ..write(obj.addOns)
      ..writeByte(16)
      ..write(obj._selectedDrink)
      ..writeByte(17)
      ..write(obj.temp)
      ..writeByte(18)
      ..write(obj.selectedTemp)
      ..writeByte(19)
      ..write(obj._selectedChoice)
      ..writeByte(20)
      ..write(obj.selectedNoodlesType)
      ..writeByte(21)
      ..write(obj.selectedMeatPortion)
      ..writeByte(22)
      ..write(obj.selectedMeePortion)
      ..writeByte(23)
      ..write(obj.selectedSide?.toList())
      ..writeByte(24)
      ..write(obj.selectedAddOn)
      ..writeByte(25)
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
