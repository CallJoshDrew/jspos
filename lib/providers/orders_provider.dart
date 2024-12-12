import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';

class OrdersNotifier extends StateNotifier<Orders> {
  final Box<Orders> _ordersBox;

  OrdersNotifier(this._ordersBox) : super(_ordersBox.get('orders', defaultValue: Orders(data: [])) ?? Orders());

  // Method to get an order by order number
  SelectedOrder? getOrder(String orderNumber) {
    return state.data.firstWhereOrNull((order) => order.orderNumber == orderNumber);
  }

  // Get all orders (immutable copy)
  List<SelectedOrder> getAllOrders() {
    return List.unmodifiable(state.data); // Prevents external modifications
  }

  // Group orders by date
  Map<String, List<SelectedOrder>> get ordersGroupedByDate {
    Map<String, List<SelectedOrder>> groupedOrders = {};
    for (var order in state.data) {
      if (groupedOrders.containsKey(order.orderDate)) {
        groupedOrders[order.orderDate]!.add(order);
      } else {
        groupedOrders[order.orderDate] = [order];
      }
    }
    return groupedOrders;
  }

  // Add or update an order
  Future<void> addOrUpdateOrder(SelectedOrder order) async {
    final updatedOrders = List<SelectedOrder>.from(state.data);

    final existingOrderIndex = updatedOrders.indexWhere((o) => o.orderNumber == order.orderNumber);
    if (existingOrderIndex != -1) {
      updatedOrders[existingOrderIndex] = order;
      // log('Order updated before Hive save: ${order.orderNumber}, Total Quantity: ${order.items.fold(0, (sum, item) => sum + item.quantity)}');
    } else {
      updatedOrders.add(order);
      // log('New order added before Hive save: ${order.orderNumber}, Total Quantity: ${order.items.fold(0, (sum, item) => sum + item.quantity)}');
    }

    // Update state
    state = Orders(data: updatedOrders);

    // Persist changes to Hive
    await _saveToHive();
    log('Orders saved to Hive: ${state.data}');
  }

  // Delete an order
  Future<void> deleteOrder(String orderNumber) async {
    final updatedOrders = state.data.where((order) => order.orderNumber != orderNumber).toList();

    if (updatedOrders.length == state.data.length) {
      log('Order not found for deletion: $orderNumber');
      return;
    }

    // Update state and save to Hive
    state = Orders(data: updatedOrders);
    await _saveToHive();
    log('Order deleted: $orderNumber');
  }

  // Total price of orders with status "Placed Order"
  double get totalOrdersPrice {
    return state.data.where((order) => order.status == "Placed Order").fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  // Method to cancel an order
  Future<void> cancelOrder(String orderNumber) async {
    final indexToUpdate = state.data.indexWhere((order) => order.orderNumber == orderNumber);

    if (indexToUpdate != -1) {
      var orderCopy = state.data[indexToUpdate].copyWith(
        status: "Cancelled",
        cancelledTime: DateFormat('h:mm a, d MMMM yyyy').format(DateTime.now()),
        paymentTime: "None",
        paymentMethod: "None",
      );

      final updatedOrders = List<SelectedOrder>.from(state.data);
      updatedOrders[indexToUpdate] = orderCopy;

      // Update state and save to Hive
      state = Orders(data: updatedOrders);
      await _saveToHive();
      log('Order cancelled: ${orderCopy.orderNumber}');
    } else {
      log('Order not found for cancellation: $orderNumber');
    }
  }

  // Clear all orders
  Future<void> clearOrders() async {
    state = Orders(data: []);
    await _ordersBox.clear(); // Clear the Hive box
    log('All orders cleared.');
  }

  // Helper method to save current state to Hive
  Future<void> _saveToHive() async {
    await _ordersBox.put('orders', state);
    // log('Orders saved to Hive.');
  }
}

// Provider for OrdersNotifier
final ordersProvider = StateNotifierProvider<OrdersNotifier, Orders>((ref) {
  final ordersBox = Hive.box<Orders>('orders'); // Ensure the box is open
  return OrdersNotifier(ordersBox);
});
