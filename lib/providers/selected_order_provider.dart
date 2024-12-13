import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:jspos/data/menu_data.dart';
// import 'package:jspos/data/menu1_data.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

// Define SelectedOrderNotifier with StateNotifier
class SelectedOrderNotifier extends StateNotifier<SelectedOrder> {
  SelectedOrderNotifier()
      : super(SelectedOrder(
          orderNumber: "Order Number",
          tableName: "Table Name",
          orderType: "Dine-In",
          orderDate: "Today",
          orderTime: "Now",
          status: "Start Your Order",
          items: [], // Empty list or provide an initial list of items
          subTotal: 0.0,
          totalPrice: 0.0,
          paymentMethod: "Cash",
          showEditBtn: false,
          amountReceived: 0.0,
          amountChanged: 0.0,
          totalQuantity: 0,
          paymentTime: "Today",
          cancelledTime: "Today",
          discount: 0,
        ));

  // Helper Methods
  void addItem(Item item) {
    final items = List<Item>.from(state.items);

    if (item.selection) {
      var existingItem = items.firstWhereOrNull((i) {
        bool areRemarksEqual = const MapEquality().equals(i.itemRemarks, item.itemRemarks);
        bool areSidesEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedSide, item.selectedSide);
        bool areNoodlesTypeEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedNoodlesType, item.selectedNoodlesType);

        return i.name == item.name &&
            i.selectedDrink?['name'] == item.selectedDrink?['name'] &&
            i.selectedTemp?['name'] == item.selectedTemp?['name'] &&
            i.selectedChoice?['name'] == item.selectedChoice?['name'] &&
            areNoodlesTypeEqual &&
            i.selectedMeatPortion?['name'] == item.selectedMeatPortion?['name'] &&
            i.selectedMeePortion?['name'] == item.selectedMeePortion?['name'] &&
            areRemarksEqual &&
            areSidesEqual;
      });

      if (existingItem != null) {
        existingItem.quantity += 1;
      } else {
        item.id = const Uuid().v4();
        items.add(item);
      }
    } else {
      // if selection is false
      var existingItem = items.firstWhereOrNull((i) => i.name == item.name);
      // if item already in the cart
      if (existingItem != null) {
        existingItem.quantity += 1;
      } else {
        item.quantity = 1;
        items.add(item);
      }
    }

    _updateStateWithNewItems(items);
  }

  // In selected_order_provider.dart
  void initializeNewOrder() {
    state = SelectedOrder(
      orderNumber: "Order Number",
      tableName: "Table Name",
      orderType: "Dine-In",
      orderTime: "Order Time",
      orderDate: "Order Date",
      status: "Start Your Order",
      items: [],
      subTotal: 0,
      totalPrice: 0,
      paymentMethod: "Cash",
      showEditBtn: false,
      amountReceived: 0,
      amountChanged: 0,
      totalQuantity: 0,
    );
  }

  void setNewOrderInstance(SelectedOrder newOrder) {
    state = newOrder; // This updates the notifier’s state
  }

  void updateItem(Item item) {
    final items = List<Item>.from(state.items);
    var existingIndex = items.indexWhere((i) {
      bool areRemarksEqual = const MapEquality().equals(i.itemRemarks, item.itemRemarks);
      bool areSidesEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedSide, item.selectedSide);
      bool areNoodlesTypeEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedNoodlesType, item.selectedNoodlesType);

      return i.id == item.id &&
          i.name == item.name &&
          i.selectedChoice?['name'] == item.selectedChoice?['name'] &&
          areNoodlesTypeEqual &&
          i.selectedMeatPortion?['name'] == item.selectedMeatPortion?['name'] &&
          i.selectedMeePortion?['name'] == item.selectedMeePortion?['name'] &&
          areRemarksEqual &&
          areSidesEqual &&
          i.tapao == item.tapao;
    });

    if (existingIndex != -1) {
      items[existingIndex] = item;
    } else {
      items.add(item);
    }

    _updateStateWithNewItems(items);
  }

  void resetDefault() {
    state = SelectedOrder(
      orderNumber: "Order Number",
      tableName: "Table Name",
      orderType: "DineIn",
      orderDate: "Order Date",
      orderTime: "Order Time",
      status: "Start Your Order",
      items: [],
      subTotal: 0,
      totalPrice: 0,
      paymentMethod: "Cash",
      showEditBtn: false,
      amountReceived: 0,
      amountChanged: 0,
      totalQuantity: 0,
      paymentTime: "Today",
    );
  }

  void handleCancelOrder() {
    state = state.copyWith(
      status: "Cancelled",
      paymentMethod: "None",
      paymentTime: "None",
      showEditBtn: true,
    );
  }

  void updateSubTotal() {
    double total = state.items.fold(0, (total, item) => total + item.price * item.quantity);
    state = state.copyWith(subTotal: double.parse(total.toStringAsFixed(2)));
  }

  void updateTotalPrice() {
    double total = state.subTotal;
    state = state.copyWith(totalPrice: double.parse(total.toStringAsFixed(2)));
  }

  void updateStatus(String newStatus) {
    state = state.copyWith(status: newStatus);
  }

  void updateTotalCost() {
    updateSubTotal();
    updateTotalPrice();
  }

  void processPayment({
    required double amountReceived,
    required double amountChanged,
    required int discount,
    required double total,
    required double subTotal,
    required String paymentMethod,
    required String status,
    required String cancelledTime,
    required String invoiceNumber,
  }) {
    DateTime now = DateTime.now();
    String? formattedDate;
    // log('Payment Method is $paymentMethod');

    // Attempt to format the current date-time
    try {
      formattedDate = DateFormat('h:mm a, d MMMM yyyy').format(now);
      log('Formatted Payment Date: $formattedDate');
    } catch (e) {
      log('Date formatting failed: $e');
      formattedDate = now.toIso8601String(); // Fallback to ISO format
    }

    // Update the state with all values
    state = state.copyWith(
      amountReceived: amountReceived,
      amountChanged: amountChanged,
      discount: discount,
      totalPrice: total,
      subTotal: subTotal,
      paymentMethod: paymentMethod,
      status: status,
      cancelledTime: cancelledTime,
      paymentTime: formattedDate,
      invoiceNumber: invoiceNumber,
    );
  }

  void addCancelDateTime() {
    DateTime now = DateTime.now();
    state = state.copyWith(cancelledTime: DateFormat('h:mm a, d MMMM yyyy').format(now));
  }

  void updateShowEditBtn(bool editBtn) {
    state = state.copyWith(showEditBtn: editBtn);
  }

  double _calculateSubTotal() {
    return double.parse(state.items.fold(0.0, (total, item) => total + item.price * item.quantity).toStringAsFixed(2));
  }

  double _calculateTotalPrice() {
    return _calculateSubTotal();
  }

  Future<void> placeOrder(String orderNumber, String tableName) async {
    DateTime now = DateTime.now();
    calculateTotalQuantities();
    state = state.copyWith(
      orderNumber: orderNumber,
      tableName: tableName,
      subTotal: _calculateSubTotal(),
      totalPrice: _calculateTotalPrice(),
      status: 'Placed Order',
      showEditBtn: true,
      orderDate: DateFormat('d MMMM yyyy').format(now),
      orderTime: DateFormat('h:mm a').format(now),
      totalQuantity: calculateTotalQuantities()
    );
    // log('PlaceOrder called: OrderNumber: $orderNumber, TableName: $tableName, SubTotal: ${state.subTotal}, TotalPrice: ${state.totalPrice}, Status: ${state.status}, total Quantity: ${state.totalQuantity}');
  }

  int calculateTotalQuantities() {
    return state.items.fold(0, (total, item) => total + item.quantity);
  }


  void _updateStateWithNewItems(List<Item> items) {
    calculateTotalQuantities();
    state = state.copyWith(items: items);
  }

  void updateItemsFromTempCart(List<Item> tempCartItems) {
    // Copy items from tempCartItems to prevent direct state mutation
    final updatedItems = tempCartItems.map((item) => item.copyWith()).toList();

    // Update the state with the new list of items
    state = state.copyWith(items: updatedItems);

    // Recalculate items and quantities as needed
    calculateTotalQuantities();
  }

  void removeItem(Item item) {
    // Create a new list of items excluding the specified item
    final updatedItems = List<Item>.from(state.items)..remove(item);

    // Update the state with the modified items list
    _updateStateWithNewItems(updatedItems);

    // Update the subtotal and total price if needed
    updateTotalCost();
    // calculate items & quantities
    calculateTotalQuantities();
  }
}

// Provider for SelectedOrderNotifier
final selectedOrderProvider = StateNotifierProvider<SelectedOrderNotifier, SelectedOrder>((ref) {
  return SelectedOrderNotifier();
});
