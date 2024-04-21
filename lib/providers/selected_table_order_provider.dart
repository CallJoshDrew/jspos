// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:jspos/models/selected_table_order.dart';

// final selectedOrderProvider =
//     StateNotifierProvider<SelectedOrderNotifier, SelectedTableOrder>((ref) {
//   return SelectedOrderNotifier();
// });

// class SelectedOrderNotifier extends StateNotifier<SelectedTableOrder> {
//   SelectedOrderNotifier() : super(_initialValue());

//   static SelectedTableOrder _initialValue() {
//     // Provide an initial value for your SelectedTableOrder
//     return SelectedTableOrder(
//       orderNumber: "Order Number",
//       tableName: "Table Name",
//       orderType: "Dine-In",
//       status: "Start Your Order",
//       items: [],
//       subTotal: 0.0,
//       serviceCharge: 0.0,
//       totalPrice: 0.0,
//       quantity: 0,
//       paymentMethod: "Cash",
//       remarks: "No Remarks",
//       showEditBtn: false,
//     );
//   }

//   void addItem(Item item) {
//     state = SelectedTableOrder(
//       orderNumber: state.orderNumber,
//       tableName: state.tableName,
//       orderType: state.orderType,
//       orderTime: state.orderTime,
//       orderDate: state.orderDate,
//       status: state.status,
//       items: [...state.items, item],
//       subTotal: state.subTotal,
//       serviceCharge: state.serviceCharge,
//       totalPrice: state.totalPrice,
//       quantity: state.quantity,
//       paymentMethod: state.paymentMethod,
//       remarks: state.remarks,
//       showEditBtn: state.showEditBtn,
//     );
//   }
// }
