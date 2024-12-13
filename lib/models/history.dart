// import 'package:jspos/models/selected_order.dart';

// class History {
//   final Map<String, Map<String, List<SelectedOrder>>> data;

//   History({required this.data});

//   void addOrdersForDay(String year, String month, List<SelectedOrder> orders) {
//     if (!data.containsKey(year)) {
//       data[year] = {};
//     }
//     data[year]![month] = orders;
//   }

//   List<SelectedOrder>? getOrdersForMonth(String year, String month) {
//     return data[year]?[month];
//   }
// }

// // // Create a new history
// // History history = History(data: {});

// // // Add orders to the history
// // history.addOrdersForDay("2024", "January", orders);

// // // Get orders from the history
// // List<SelectedOrder>? ordersForMonth = history.getOrdersForMonth("2024", "January");

