import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/models/selected_table_order.dart';
// Replace with the actual path

final selectedTableOrderProvider =
    StateNotifierProvider<SelectedTableOrder, SelectedTableOrder>((ref) {
  return SelectedTableOrder(
    orderNumber: 'Order Number',
    tableName: 'Table Name',
    orderType: 'Dine-In',
    status: 'Status',
    items: [],
    subTotal: 0,
    serviceCharge: 0,
    totalPrice: 0,
    quantity: 0,
    paymentMethod: '',
    remarks: 'No Remarks',
    showEditBtn: false,
  );
});
