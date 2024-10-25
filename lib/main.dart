import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; 
import 'package:jspos/app/jpos.dart';
import 'package:jspos/models/client_profile.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/daily_sales.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    // Register all Hive adapters
    Hive
      ..registerAdapter(OrdersAdapter())
      ..registerAdapter(SelectedOrderAdapter())
      ..registerAdapter(ItemAdapter())
      ..registerAdapter(PrinterAdapter())
      ..registerAdapter(DailySalesAdapter())
      ..registerAdapter(ClientProfileAdapter());

    // Open all necessary Hive boxes
    final ordersBox = await Hive.openBox<Orders>('orders');
    final printersBox = await Hive.openBox<Printer>('printersBox');
    final orderCounterBox = await Hive.openBox('orderCounter');
    final dailySalesBox = await Hive.openBox<DailySales>('dailySalesBox');
    final tablesBox = await Hive.openBox('tables');
    final categoriesBox = await Hive.openBox('categories');

    // Initialize order counter if not present
    if (orderCounterBox.get('orderCounter') == null) {
      await orderCounterBox.put('orderCounter', 1);
      log('Initialized orderCounter with default value: 1');
    }

    // Initialize categories if not present
    List<String> categories = categoriesBox.get('categories')?.split(',') ?? [
      "Cakes",
      "Dishes",
      "Drinks",
      "Special",
      "Add On"
    ];
    if (categoriesBox.get('categories') == null) {
      await categoriesBox.put('categories', categories.join(','));
    }

    // Initialize today's DailySales if not present
    String today = getCurrentDate();
    if (dailySalesBox.get(today) == null) {
      await dailySalesBox.put(today, DailySales(orders: []));
    }

    // Run the app with ProviderScope
    runApp(ProviderScope(child: JPOSApp(categories: categories)));
  } catch (e) {
    log('An error occurred at Main App: $e');
  }
}

// Helper function to get today's date in YYYY-MM-DD format
String getCurrentDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

// Function to save today's DailySales
Future<void> saveDailySales(DailySales dailySales) async {
  final dailySalesBox = await Hive.openBox<DailySales>('dailySalesBox');
  await dailySalesBox.put(getCurrentDate(), dailySales);
}



// Main color green
// const Color.fromRGBO(46, 125, 50, 1)
// Second Color
// Colors.deepOrangeAccent



  // await Hive.openBox('selectedOrder'); // why this got issues if openBox here? some of the fields are null it said.
  // however due to the design, selectedOrder is never to be openBox here because there will be another selecetedOrder for tapao
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  