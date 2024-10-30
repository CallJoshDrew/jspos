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
    Hive.registerAdapter(OrdersAdapter());
    Hive.registerAdapter(SelectedOrderAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(PrinterAdapter());
    Hive.registerAdapter(DailySalesAdapter());
    Hive.registerAdapter(ClientProfileAdapter());

    // Open required Hive boxes
    await Hive.openBox<Orders>('orders');
    await Hive.openBox<Printer>('printersBox');
    var orderCounterBox = await Hive.openBox('orderCounter');
    await Hive.openBox<DailySales>('dailySalesBox');
    await Hive.openBox('tables');

    // Initialize the order counter if not present
    if (orderCounterBox.get('orderCounter') == null) {
      await orderCounterBox.put('orderCounter', 1);
      log('Initialized orderCounter with default value: 1');
    }

    var categoriesBox = await Hive.openBox('categories');
    // Initialize categories
    
    List<String> categories;
    String? categoriesString = categoriesBox.get('categories');
    if (categoriesString != null) {
      categories = categoriesString.split(',');
    } else {
      categories = ["Cakes", "Dishes", "Drinks", "Special", "Add On"];
      categoriesBox.put('categories', categories.join(','));
    }

    // Initialize DailySales for today
    String today = getCurrentDate();
    var dailySalesBox = Hive.box<DailySales>('dailySalesBox');
    DailySales? dailySalesData = dailySalesBox.get(today);
    if (dailySalesData == null) {
      DailySales emptyDailySales = DailySales(orders: []);
      await dailySalesBox.put(today, emptyDailySales);
    }

    // Run the app with ProviderScope
    runApp(ProviderScope(child: JPOSApp(categories: categories)));
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
  String today = getCurrentDate();
  await dailySalesBox.put(today, dailySales);
}


// Main color green
// const Color.fromRGBO(46, 125, 50, 1)
// Second Color
// Colors.deepOrangeAccent
// Nice Color Blue
// Colors.blueGrey
// Black Color
// const Color(0xff1f2029),



  // await Hive.openBox('selectedOrder'); // why this got issues if openBox here? some of the fields are null it said.
  // however due to the design, selectedOrder is never to be openBox here because there will be another selecetedOrder for tapao
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  