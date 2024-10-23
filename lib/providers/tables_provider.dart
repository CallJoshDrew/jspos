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
      print('Error initializing tables: $e');
    }
  }

  Future<void> updateTables(List<Map<String, dynamic>> newTables) async {
    await _tablesBox.put('tables', newTables);
    state = newTables;
  }

  // Reset tables to the default state
  void resetTables() async {
    final defaultState = defaultTables
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    state = defaultState;
    await _tablesBox.put('tables', defaultState);
  }
}

final tablesProvider = StateNotifierProvider<TablesNotifier, List<Map<String, dynamic>>>(
  (ref) {
    final box = Hive.box('tables');
    return TablesNotifier(box);
  },
);

