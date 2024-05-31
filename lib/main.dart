import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  // var selectedOrderBox = await Hive.openBox('selectedOrder');
  var tablesBox = await Hive.openBox('tables');
  
  if (tablesBox.isEmpty) {
    tablesBox.put('tables', defaultTables.map((item) => Map<String, dynamic>.from(item)).toList());
  }

  Orders? ordersData = ordersBox.get('orders');
  Orders orders;
  if (ordersData != null) {
    orders = ordersData;
  } else {
    // Initialize 'orders' with an empty list of SelectedOrder
    orders = Orders(data: []);
    ordersBox.put('orders', orders);
  }
  runApp(ProviderScope(child: JPOSApp(orders: orders)));
}
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  