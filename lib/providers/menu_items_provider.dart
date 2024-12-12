import 'dart:developer';

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
    try {
      final box = await Hive.openBox<Item>('menuBox');
      // log('Box opened: ${box.isEmpty ? "empty" : "not empty"}');
      if (box.isEmpty) {
        await initializeMenu();
        log('Menu initialized.');
      } else {
        state = box.values.toList();
        // log('Menu loaded from Hive: ${state.length} items.');
      }
    } catch (e) {
      log('Error loading menu: ${e.toString()}');
    }
  }

  Future<void> initializeMenu() async {
    log('Initializing menu...');
    final items = convertMenuToItems(menu);
    log('Converted ${items.length} items from hardcoded menu.');
    await addItems(items); // Ensure this line is not skipped or throwing an error
    log('Menu initialization complete.');
  }

  Future<void> addItems(List<Item> items) async {
    final box = await Hive.openBox<Item>('menuBox');
    // log('Opened Hive box for adding items.');
    for (final item in items) {
      try {
        // log('Adding item to box: ${item.name}');
        await box.put(item.id, item);
        // log('Item added: ${item.name}');
      } catch (e) {
        log('Error adding item: ${e.toString()}');
      }
    }
    state = [...state, ...items];
    // log('Items added to Hive box. Total items: ${box.length}');
  }

  Future<void> clearMenu() async {
    final box = await Hive.openBox<Item>('menuBox');
    await box.clear(); // Clear all items from the box
    state = []; // Reset the state to an empty list
    log('menu cleared from Hive.');
  }

  List<Item> convertMenuToItems(List<Map<String, dynamic>> menu) {
    return menu.map((data) {
      // log('Converting item: ${data['name']}');
      return Item(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        price: data['price'],
        image: data['image'],
        selection: data['selection'] ?? false, // Default to false if missing
        quantity: 0,
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
        tapao: data['tapao'] ?? false, // Default to false if missing
        originalName: data['name'],
      );
    }).toList();
  }
}
