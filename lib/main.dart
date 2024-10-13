import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:jspos/app/jpos.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/daily_sales.dart'; // Import the DailySales model
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    
    // Register all Hive adapters
    Hive.registerAdapter(OrdersAdapter());
    Hive.registerAdapter(SelectedOrderAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(PrinterAdapter());
    Hive.registerAdapter(DailySalesAdapter()); // Register the DailySales adapter
    
    // Open required Hive boxes
    await Hive.openBox<Printer>('printersBox');
    var ordersBox = await Hive.openBox('orders');
    var tablesBox = await Hive.openBox('tables');
    var categoriesBox = await Hive.openBox('categories');
    var counterBox = await Hive.openBox('orderCounter');
    var dailySalesBox = await Hive.openBox<DailySales>('dailySalesBox'); // Open dailySales box

    // Initialize orders, tables, categories, counterBox and dailySalesBox if not already present    
    Orders orders;
    Orders? ordersData = ordersBox.get('orders');
    if (ordersData != null) {
      orders = ordersData;
    } else {
      orders = Orders(data: []);
      ordersBox.put('orders', orders);
    }
    if (tablesBox.isEmpty) {
      tablesBox.put('tables', defaultTables.map((item) => Map<String, dynamic>.from(item)).toList());
    }

    List<String> categories;
    String? categoriesString = categoriesBox.get('categories');
    if (categoriesString != null) {
      categories = categoriesString.split(',');
    } else {
      categories = ["Cakes", "Dishes", "Drinks", "Add On"];
      categoriesBox.put('categories', categories.join(','));
    }

    if (counterBox.isEmpty) {
      counterBox.put('orderCounter', 1);
    }
    
     // Check and initialize dailySales for today
    String today = getCurrentDate();
    DailySales? dailySalesData = dailySalesBox.get(today);
    if (dailySalesData == null) {
      DailySales emptyDailySales = DailySales(orders: []); // Initialize with an empty list
      await dailySalesBox.put(today, emptyDailySales);
    }

    // Run the app
    runApp(ProviderScope(child: JPOSApp(orders: orders, categories: categories)));
  } catch (e) {
    log('An error occurred at Main App: $e');
  }
}

// Function to get today's date in YYYY-MM-DD format
String getCurrentDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

// Function to save today's DailySales
Future<void> saveDailySales(DailySales dailySales) async {
  var dailySalesBox = await Hive.openBox<DailySales>('dailySalesBox');
  
  // Get today's date in the format YYYY-MM-DD
  String today = getCurrentDate();
  
  // Save the daily sales data for today
  await dailySalesBox.put(today, dailySales);
}



  // await Hive.openBox('selectedOrder'); // why this got issues if openBox here? some of the fields are null it said.
  // however due to the design, selectedOrder is never to be openBox here because there will be another selecetedOrder for tapao
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  