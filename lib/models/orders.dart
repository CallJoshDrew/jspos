import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/selected_order.dart';

part 'orders.g.dart'; // Hive TypeAdapter

@HiveType(typeId: 1)
class Orders {
  @HiveField(0)
  final List<SelectedOrder> data;

  Orders({List<SelectedOrder>? data}) : data = data ?? [];

  @override
  String toString() {
    return 'Orders: { $data }';
  }

  // Add or update an order
  Future<void> addOrUpdateOrder(SelectedOrder order) async {
    log('Adding or updating order: $order');
    
    int existingOrderIndex = data.indexWhere((o) => o.orderNumber == order.orderNumber);
    
    if (existingOrderIndex != -1) {
      data[existingOrderIndex] = order;
      log('Order updated: $order');
    } else {
      data.add(order);
      log('New order added: $order');
    }

    await _saveToHive();
  }

  // Retrieve an order by order number
  SelectedOrder? getOrder(String orderNumber) {
    log('Fetching order: $orderNumber');
    return data.firstWhereOrNull((order) => order.orderNumber == orderNumber);
  }

  // Get all orders
  List<SelectedOrder> getAllOrders() {
    return List.unmodifiable(data); // Prevents external modifications
  }

  // Clear all orders
  Future<void> clearOrders() async {
    data.clear();
    await _saveToHive();
    log('All orders cleared.');
  }

  // Save the current state to Hive
  Future<void> _saveToHive() async {
    if (Hive.isBoxOpen('orders')) {
      var ordersBox = Hive.box<Orders>('orders');
      await ordersBox.put('orders', this);
      log('Orders saved to Hive.');
    } else {
      log('Hive box is not open.');
    }
  }
}


// void deleteOrder(SelectedOrder orderToDelete) {
  //   final existingOrderIndex = data.indexWhere((o) => o.orderNumber == orderToDelete.orderNumber);
  //   if (existingOrderIndex != -1) {
  //     // Remove the existing order
  //     data.removeAt(existingOrderIndex);
  //   }
  // }

  
