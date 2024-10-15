import 'package:hive/hive.dart';
import 'package:jspos/models/selected_order.dart';

part 'daily_sales.g.dart'; // Name of the generated TypeAdapter file

@HiveType(typeId: 0)
class DailySales {
  @HiveField(0)
  List<SelectedOrder> orders;

  DailySales({required this.orders});
}


// DailySales - HiveType(typeId: 0)
// Orders - HiveType(typeId: 1)
// SelectedOrder - HiveType(typeId: 2)
// Item - HiveType(typeId: 3)
// Printer - HiveType(typeId: 4)
// Client Profile - HiveType(typeId: 5)


// // SalesData class to hold yearly data
// @HiveType(typeId: 0)
// class SalesData {
//   @HiveField(0)
//   Map<String, YearlyData> yearlyData;

//   SalesData({required this.yearlyData});
// }

// // YearlyData class to hold monthly data
// @HiveType(typeId: 1)
// class YearlyData {
//   @HiveField(0)
//   Map<String, MonthlyData> monthlyData;

//   YearlyData({required this.monthlyData});
// }

// // MonthlyData class to hold the orders
// @HiveType(typeId: 2)
// class MonthlyData {
//   @HiveField(0)
//   List<SelectedOrder> orders;

//   MonthlyData({required this.orders});
// }
