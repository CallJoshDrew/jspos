import 'package:hive/hive.dart';

// part 'menu_item.g.dart';

@HiveType(typeId: 7)
class MenuItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final bool selection;
  @HiveField(6)
  final List<MenuOption> choices;
  @HiveField(7)
  final List<MenuOption> drinks;
  @HiveField(8)
  final List<MenuOption> temp;
  @HiveField(9)
  final List<MenuOption> soupOrKonLou;
  @HiveField(10)
  final List<MenuOption> noodlesTypes;
  @HiveField(11)
  final List<MenuOption> meatPortion;
  @HiveField(12)
  final List<MenuOption> meePortion;
  @HiveField(13)
  final List<MenuOption> sides;
  @HiveField(14)
  final List<MenuOption> addOn;
  @HiveField(15)
  final List<MenuOption> addMilk;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.selection,
    required this.choices,
    required this.drinks,
    required this.temp,
    required this.soupOrKonLou,
    required this.noodlesTypes,
    required this.meatPortion,
    required this.meePortion,
    required this.sides,
    required this.addOn,
    required this.addMilk,
  });
}

@HiveType(typeId: 8) // Define for reusable menu options
class MenuOption {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double price;

  MenuOption({required this.name, required this.price});
}
