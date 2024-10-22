import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';

// OrdersNotifier manages state using Orders
class OrdersNotifier extends StateNotifier<Orders> {
  final Box<Orders> _ordersBox;

  OrdersNotifier(this._ordersBox)
      : super(_ordersBox.get('orders', defaultValue: Orders(data: [])) ?? Orders());

  // Add or update an order
  Future<void> addOrUpdateOrder(SelectedOrder order) async {
    await state.addOrUpdateOrder(order);
    state = Orders(data: state.data); // Notify listeners
    await _ordersBox.put('orders', state); // Save to Hive
    log('Order added/updated: ${order.orderNumber}');
  }

  // Clear all orders
  Future<void> clearOrders() async {
    state = Orders(data: []); // Reset state
    await _ordersBox.clear(); // Clear the Hive box
    log('All orders cleared.');
  }
}

// Provider for OrdersNotifier
final ordersProvider = StateNotifierProvider<OrdersNotifier, Orders>((ref) {
  final ordersBox = Hive.box<Orders>('orders'); // Ensure the box is open
  return OrdersNotifier(ordersBox);
});
