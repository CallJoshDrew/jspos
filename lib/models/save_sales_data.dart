import 'package:jspos/models/selected_order.dart';

Map<String, dynamic> salesData = {};

void saveOrderToSalesData(SelectedOrder order) {
  // Extract year, month, and day from the orderDate
  DateTime date = DateTime.parse(order.orderDate); // Assuming orderDate is in "yyyy-MM-dd" format
  String year = date.year.toString();
  String month = getMonthName(date.month);
  String day = "${date.day}/${date.month}/${date.year.toString().substring(2)}";

  // Initialize year if it doesn't exist
  if (!salesData.containsKey(year)) {
    salesData[year] = {};
  }

  // Initialize month if it doesn't exist
  if (!salesData[year].containsKey(month)) {
    salesData[year][month] = [];
  }

  // Check if the date already exists in the month
  Map<String, dynamic>? existingDateData = salesData[year][month].firstWhere(
      (data) => data['date'] == day,
      orElse: () => null);

  if (existingDateData != null) {
    // If date exists, add the new order
    existingDateData['orders'].add(order.toJson()); // Convert SelectedOrder to JSON
  } else {
    // Create new date entry with the order
    salesData[year][month].add({
      'date': day,
      'orders': [order.toJson()]
    });
  }
}

// Utility function to convert month number to name
String getMonthName(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[month - 1];
}
