// import 'package:hive/hive.dart';

// // part 'menu_item.g.dart';

// @HiveType(typeId: xxxx haven't decide yet)
// class MenuItem {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final String name;
//   @HiveField(2)
//   final String category;
//   @HiveField(3)
//   final double price;
//   @HiveField(4)
//   final String image;
//   @HiveField(5)
//   final bool selection;
//   @HiveField(6)
//   final List<MenuOption>? choices;
//   @HiveField(7)
//   final List<MenuOption>? drinks;
//   @HiveField(8)
//   final List<MenuOption>? temp;
//   @HiveField(9)
//   final List<MenuOption>? soupOrKonLou;
//   @HiveField(10)
//   final List<MenuOption>? noodlesTypes;
//   @HiveField(11)
//   final List<MenuOption>? meatPortion;
//   @HiveField(12)
//   final List<MenuOption>? meePortion;
//   @HiveField(13)
//   final List<MenuOption>? sides;
//   @HiveField(14)
//   final List<MenuOption>? addOn;
//   @HiveField(15)
//   final List<MenuOption>? addMilk;

//   MenuItem({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.price,
//     required this.image,
//     this.selection = false, // Optional with default
//     this.choices,
//     this.drinks,
//     this.temp,
//     this.soupOrKonLou,
//     this.noodlesTypes,
//     this.meatPortion,
//     this.meePortion,
//     this.sides,
//     this.addOn,
//     this.addMilk,
//   });
// }

// @HiveType(typeId: 8) // Define for reusable menu options
// class MenuOption {
//   @HiveField(0)
//   final String name;
//   @HiveField(1)
//   final double price;

//   MenuOption({required this.name, required this.price});
// }
