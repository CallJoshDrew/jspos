import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/client_profile.dart';
import 'package:jspos/models/shift.dart';
import 'package:jspos/models/user.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/daily_sales.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/providers/client_profile_provider.dart';
import 'package:riverpod/riverpod.dart'; 

Future<void> initializeHive() async {
  await Hive.initFlutter();

  // Register all Hive adapters
  Hive.registerAdapter(ClientProfileAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(DailySalesAdapter());
  Hive.registerAdapter(SelectedOrderAdapter());
  // Indirect Storage: Orders includes a list of SelectedOrder objects. When you save Orders to Hive, it tries to save all its properties, including SelectedOrder instances. Hive requires that all types it writes to storage have registered adapters, so even if you didn’t intend to save SelectedOrder separately, it’s indirectly required to save it as part of Orders.
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(PrinterAdapter());
  Hive.registerAdapter(ShiftAdapter());
  
  // Open required Hive boxes
  await Hive.openBox<ClientProfile>('clientProfiles');
  await Hive.openBox<User>('currentUser');
  await Hive.openBox<Orders>('orders');
  await Hive.openBox('orderCounter');
  await Hive.openBox<DailySales>('dailySalesBox');
  await Hive.openBox('tables');
  await Hive.openBox<Printer>('printersBox');
  await Hive.openBox('categories');
  // await Hive.openBox<Item>('menuBox'); Didn't load here but loaded in menu page BECAUSE OF COMPLEXITY
  await Hive.openBox<Shift>('shifts'); // Open a Hive box for shifts

  // Initialize data
  final container = ProviderContainer();
  await initializeClientProfile(container); 
  await initializeOrderCounter();
  await initializeDailySales();
  await initializeCategories();

  // Dispose the container to avoid memory leaks
  container.dispose();
}

/// Initializes the client profile if it is not already set
Future<void> initializeClientProfile(ProviderContainer container) async {
  final clientProfileNotifier = container.read(clientProfileProvider.notifier);
  await clientProfileNotifier.loadProfile();

  // Log the current client profile
  final clientProfile = container.read(clientProfileProvider);
  log('Current client profile: $clientProfile');
}

/// Initializes the order counter if it is not already set
Future<void> initializeOrderCounter() async {
  var orderCounterBox = Hive.box('orderCounter');
  if (orderCounterBox.get('orderCounter') == null) {
    await orderCounterBox.put('orderCounter', 1);
    log('Initialized orderCounter with default value: 1');
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
