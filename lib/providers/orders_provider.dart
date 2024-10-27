import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
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
  // Method to find and update an existing order
  Future<void> updateOrder(SelectedOrder updatedOrder) async {
    final indexToUpdate = state.data.indexWhere((order) => order.orderNumber == updatedOrder.orderNumber);

    if (indexToUpdate != -1) {
      // Update the order in the list
      final updatedOrders = List<SelectedOrder>.from(state.data);
      updatedOrders[indexToUpdate] = updatedOrder;

      // Update the state and Hive box
      state = Orders(data: updatedOrders);
      await _ordersBox.put('orders', state); // Save the updated orders list to Hive
      log('Order updated: ${updatedOrder.orderNumber}');
    } else {
      log('Order not found: ${updatedOrder.orderNumber}');
    }
  }
  // Method to cancel an order
  Future<void> cancelOrder(String orderNumber, List<String> categories) async {
    final indexToUpdate = state.data.indexWhere((order) => order.orderNumber == orderNumber);

    if (indexToUpdate != -1) {
      var orderCopy = state.data[indexToUpdate].copyWith();

      // Set cancellation details
      orderCopy = orderCopy.copyWith(
        status: "Cancelled",
        cancelledTime: DateFormat('h:mm a, d MMMM yyyy').format(DateTime.now()),
        paymentTime: "None",
        paymentMethod: "None",
      );

      final updatedOrders = List<SelectedOrder>.from(state.data);
      updatedOrders[indexToUpdate] = orderCopy;

      // Update the state and Hive box
      state = Orders(data: updatedOrders);
      await _ordersBox.put('orders', state);

      log('Order cancelled: ${orderCopy.orderNumber}');
    } else {
      log('Order not found for cancellation: $orderNumber');
    }
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
