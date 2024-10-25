import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/data/tables_data.dart';

// Assuming defaultTables is imported from here
class TablesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Box _tablesBox;

  TablesNotifier(this._tablesBox) : super([]) {
    _initializeTables();
  }

  Future<void> _initializeTables() async {
    try {
      // Check if tables data exists, otherwise set the default tables
      final data = _tablesBox.get('tables');
      if (data != null) {
        // Safely cast dynamic data to List<Map<String, dynamic>>
        state = List<Map<String, dynamic>>.from(
          (data as List).map((item) => Map<String, dynamic>.from(item)),
        );
      } else {
        // Save default tables to Hive and update state
        await _tablesBox.put('tables', defaultTables);
        state = defaultTables;
      }
    } catch (e) {
      log('Error initializing tables: $e');
    }
  }

  // Method to update a specific table and save to Hive
  Future<void> updateSelectedTable(int index, String orderNumber, bool isOccupied) async {
    var beforeUpdateTables = state.where((table) => table['occupied'] == true).toList();
    log('From Tables Provider - Before updating tables: $beforeUpdateTables');
    if (index >= 0 && index < state.length) {
      // Update the table in state
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) {...state[i], 'orderNumber': orderNumber, 'occupied': isOccupied} else state[i]
      ];
      // Save the updated state to Hive
      await _tablesBox.put('tables', state);

      var afterUpdatedTables = state.where((table) => table['occupied'] == true).toList();
      log('From Tables Provider - After updating tables: $afterUpdatedTables');
      log('Table ${index + 1} has been updated and saved to Hive.');
    }
  }

  // Future<void> updateTables(List<Map<String, dynamic>> newTables) async {
  //   await _tablesBox.put('tables', newTables);
  //   state = newTables;
  // }

  void resetTables() async {
    log('Resetting tables to default state.');

    final defaultState = defaultTables.map((item) => Map<String, dynamic>.from(item)).toList();

    state = defaultState;
    await _tablesBox.put('tables', defaultState);

    log('Tables have been reset and saved to Hive.');
  }
}

final tablesProvider = StateNotifierProvider<TablesNotifier, List<Map<String, dynamic>>>(
  (ref) {
    final box = Hive.box('tables');
    return TablesNotifier(box);
  },
);
