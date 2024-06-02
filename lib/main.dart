import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/app/jpos.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OrdersAdapter()); // register the OrdersAdapter
  Hive.registerAdapter(SelectedOrderAdapter());
  Hive.registerAdapter(ItemAdapter());

  var ordersBox = await Hive.openBox('orders');
  var tablesBox = await Hive.openBox('tables');
  await Hive.openBox('selectedOrder');
  var categoriesBox = await Hive.openBox('categories');

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
}

  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  