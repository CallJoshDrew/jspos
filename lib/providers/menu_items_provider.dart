import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/data/menu_data.dart';
import 'package:jspos/models/item.dart';

final menuProvider = StateNotifierProvider<MenuNotifier, List<Item>>((ref) {
  return MenuNotifier();
});

class MenuNotifier extends StateNotifier<List<Item>> {
  MenuNotifier() : super([]);

  Future<void> loadMenu() async {
    final box = await Hive.openBox<Item>('menuBox');
    if (box.isEmpty) {
      // Initialize with the hardcoded menu if the box is empty
      await initializeMenu();
    } else {
      // Load existing items from the box
      state = box.values.toList();
    }
  }

  Future<void> initializeMenu() async {
    // Convert the imported hardcoded menu into a list of `Item` objects
    final items = convertMenuToItems(menu); 
    await addItems(items);
  }

  Future<void> addItems(List<Item> items) async {
    final box = await Hive.openBox<Item>('menuBox');
    for (final item in items) {
      await box.put(item.id, item);
    }
    state = [...state, ...items];
  }

  List<Item> convertMenuToItems(List<Map<String, dynamic>> menu) {
    return menu.map((data) {
      return Item(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        price: data['price'],
        image: data['image'],
        quantity: 0, // Default to 0 initially
        drinks: data['drinks'] ?? [],
        choices: data['choices'] ?? [],
        noodlesTypes: data['noodlesTypes'] ?? [],
        meatPortion: data['meat portion'] ?? [],
        meePortion: data['mee portion'] ?? [],
        sides: data['sides'] ?? [],
        addMilk: data['addMilk'] ?? [],
        addOns: data['add on'] ?? [],
        temp: data['temp'] ?? [],
        soupOrKonLou: data['soupOrKonLou'] ?? [],
        originalName: data['name'],
      );
    }).toList();
  }
}
