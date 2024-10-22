// lib/providers/orders_provider.dart
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart'; // Import the Orders model

class OrdersNotifier extends StateNotifier<Orders> {
  final Box<Orders> _ordersBox;

  OrdersNotifier(this._ordersBox)
      : super(_ordersBox.get('orders', defaultValue: Orders(data: [])) ?? Orders());

  // Add or update an order
  Future<void> addOrUpdateOrder(SelectedOrder order) async {
    await state.addOrUpdateOrder(order);
    state = Orders(data: state.data); // Notify listeners of state change
    log('Order added/updated: ${order.orderNumber}');
  }

  // Clear all orders
  Future<void> clearOrders() async {
    await state.clearOrders();
    state = Orders(data: []); // Reset state to an empty order list
    log('All orders cleared.');
  }

  // Reload orders from Hive (optional)
  void reloadOrders() {
    state = _ordersBox.get('orders', defaultValue: Orders(data: [])) ?? Orders();
    log('Orders reloaded from Hive.');
  }
}

// Create a global provider for OrdersNotifier
final ordersProvider = StateNotifierProvider<OrdersNotifier, Orders>((ref) {
  final ordersBox = Hive.box<Orders>('orders'); // Ensure Hive box is open
  return OrdersNotifier(ordersBox);
});
