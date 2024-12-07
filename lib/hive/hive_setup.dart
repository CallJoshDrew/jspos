import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/user.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/models/daily_sales.dart';
import 'package:jspos/models/client_profile.dart';

Future<void> initializeHive() async {
  await Hive.initFlutter();

  // Register all Hive adapters
  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(SelectedOrderAdapter());
   // Indirect Storage: Orders includes a list of SelectedOrder objects. When you save Orders to Hive, it tries to save all its properties, including SelectedOrder instances. Hive requires that all types it writes to storage have registered adapters, so even if you didn’t intend to save SelectedOrder separately, it’s indirectly required to save it as part of Orders.
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(PrinterAdapter());
  Hive.registerAdapter(DailySalesAdapter());
  Hive.registerAdapter(ClientProfileAdapter());
  Hive.registerAdapter(UserAdapter());

  // Open required Hive boxes
  await Hive.openBox<Orders>('orders');
  await Hive.openBox<Printer>('printersBox');
  await Hive.openBox('orderCounter');
  await Hive.openBox<DailySales>('dailySalesBox');
  await Hive.openBox('tables');
  await Hive.openBox<User>('currentUser');
  await Hive.openBox('categories');

  // Initialize data
  await initializeOrderCounter();
  await initializeCategories();
  await initializeDailySales();
}

/// Initializes the order counter if it is not already set
Future<void> initializeOrderCounter() async {
  var orderCounterBox = Hive.box('orderCounter');
  if (orderCounterBox.get('orderCounter') == null) {
    await orderCounterBox.put('orderCounter', 1);
    log('Initialized orderCounter with default value: 1');
  }
}

/// Initializes default categories if not already set
Future<void> initializeCategories() async {
  var categoriesBox = Hive.box('categories');
  String? categoriesString = categoriesBox.get('categories');
  if (categoriesString == null) {
    List<String> defaultCategories = ["Cakes", "Dishes", "Drinks", "Special", "Add On"];
    await categoriesBox.put('categories', defaultCategories.join(','));
    log('Initialized default categories: $defaultCategories');
  }
}

/// Initializes DailySales for today if not already set
Future<void> initializeDailySales() async {
  String today = getCurrentDate();
  var dailySalesBox = Hive.box<DailySales>('dailySalesBox');
  DailySales? dailySalesData = dailySalesBox.get(today);
  if (dailySalesData == null) {
    DailySales emptyDailySales = DailySales(orders: []);
    await dailySalesBox.put(today, emptyDailySales);
    log('Initialized empty DailySales for today: $today');
  }
}

/// Gets today's date in YYYY-MM-DD format
String getCurrentDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}
