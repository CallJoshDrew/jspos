import 'package:collection/collection.dart';
import 'package:jspos/models/selected_order.dart';

class Orders {
  final List<SelectedOrder> data;

  Orders({required this.data});
  @override
  // methods
  String toString() {
    return 'Orders: $data';
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
}
