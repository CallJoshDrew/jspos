import 'package:jspos/models/selected_order.dart';

mixin TotalQuantityCalculator {
  int calculateTotalQuantityByCategory(SelectedOrder selectedOrder, String category) {
    int totalQuantity = 0;

    // Loop through selectedOrder items and sum quantities for the specified category
    for (var item in selectedOrder.items) {
      if (item.category == category) {
        totalQuantity += item.quantity;
      }
    }

    return totalQuantity;
  }
}
