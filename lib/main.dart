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
  Hive.registerAdapter(OrdersAdapter()); // register the OrdersAdapter: Orders must be the same name class and file name.
  Hive.registerAdapter(SelectedOrderAdapter()); 
  Hive.registerAdapter(ItemAdapter()); 
  Hive.openBox('orders');
  var tablesBox = await Hive.openBox('tables');
  tablesBox.put('tables', tables); 
  runApp(const ProviderScope(child: JPOSApp()));
}

