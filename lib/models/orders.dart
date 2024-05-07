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
    data.add(order);
  }

  SelectedOrder? getOrder(String orderNumber) {
    return data.firstWhereOrNull((order) => order.orderNumber == orderNumber);
  }
}
