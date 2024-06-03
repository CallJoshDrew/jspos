import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/app/jpos.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(OrdersAdapter()); // register the OrdersAdapter
    Hive.registerAdapter(SelectedOrderAdapter());
    Hive.registerAdapter(ItemAdapter());

    var ordersBox = await Hive.openBox('orders');
    var tablesBox = await Hive.openBox('tables');
    var categoriesBox = await Hive.openBox('categories');
    var counterBox = await Hive.openBox('orderCounter');

    if (counterBox.isEmpty) {
      counterBox.put('orderCounter', 1);
    }
    if (tablesBox.isEmpty) {
      tablesBox.put('tables', defaultTables.map((item) => Map<String, dynamic>.from(item)).toList());
    }
    Orders? ordersData = ordersBox.get('orders');
    Orders orders;
    if (ordersData != null) {
      orders = ordersData;
    } else {
      orders = Orders(data: []);
      ordersBox.put('orders', orders);
    }
    String? categoriesString = categoriesBox.get('categories');
    List<String> categories = categoriesString != null ? categoriesString.split(',') : ["Cakes", "Dishes", "Drinks"];
    log('$categoriesString');
    runApp(JPOSApp(orders: orders, categories: categories));
  } catch (e) {
    log('An error occurred at Main App: $e');
  }
}


  // await Hive.openBox('selectedOrder'); // why this got issues if openBox here? some of the fields are null it said.
  // however due to the design, selectedOrder is never to be openBox here because there will be another selecetedOrder for tapao
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  