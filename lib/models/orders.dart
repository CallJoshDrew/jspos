import 'package:collection/collection.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:hive/hive.dart';

part 'orders.g.dart'; // Name of the generated TypeAdapter file

@HiveType(typeId: 1)
class Orders {
  @HiveField(0)
  final List<SelectedOrder> data;

  Orders({required this.data});
  @override
  String toString() {
    return 'Orders: { $data }';
  }

  void addOrder(SelectedOrder order) {
    final existingOrderIndex = data.indexWhere((o) => o.orderNumber == order.orderNumber);
    if (existingOrderIndex != -1) {
      // Replace the existing order
      data[existingOrderIndex] = order;
    } else {
      // Add the new order
      data.add(order);
    }
  }
  
  SelectedOrder? getOrder(String orderNumber) {
    return data.firstWhereOrNull((order) => order.orderNumber == orderNumber);
  }

  void clearOrders() {
    data.clear();
  }
}

// void deleteOrder(SelectedOrder orderToDelete) {
  //   final existingOrderIndex = data.indexWhere((o) => o.orderNumber == orderToDelete.orderNumber);
  //   if (existingOrderIndex != -1) {
  //     // Remove the existing order
  //     data.removeAt(existingOrderIndex);
  //   }
  // }

  // // New method to get all orders as a list
  // List<SelectedOrder> getAllOrders() {
  //   return data;
  // }
