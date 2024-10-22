import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/shared/history_order.dart';
import 'package:data_table_2/data_table_2.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  Orders? orders;

  @override
  void initState() {
    super.initState();
    loadOrders();
    // printOrders();
  }

  Future<void> loadOrders() async {
    try {
      var ordersBox = await Hive.openBox<Orders>('orders');
      var ordersData = ordersBox.get('orders');

      setState(() {
        orders = ordersData ?? Orders(data: []); // Initialize with an empty list if null
      });
    } catch (e) {
      log('An error occurred while loading orders: $e');
    }
  }

  // void printOrders() async {
  //   try {
  //     if (Hive.isBoxOpen('orders')) {
  //       var ordersBox = await Hive.openBox('orders');
  //       var ordersData = ordersBox.get('orders');

  //       if (ordersData != null) {
  //         var orders = ordersData as Orders;
  //         // Print out all orders
  //         for (var order in orders.data) {
  //           log('Order Number: ${order.orderNumber}, Status: ${order.status}');
  //         }
  //         // Print out only 'Paid' orders
  //         var paidOrders = orders.data.where((order) => order.status == 'Paid');
  //         for (var order in paidOrders) {
  //           log('Paid Order Number: ${order.orderNumber}');
  //         }
  //       } else {
  //         log('No orders found in the orders box.');
  //       }
  //     }
  //     // log('Orders from History: ${orders.toString()}');
  //   } catch (e) {
  //     log('An error occurred while printing orders: $e');
  //   }
  // }

  String formatDateTime(String dateTimeString) {
    // Parse the string into a DateTime object
    DateFormat inputFormat = DateFormat('h:mm a, d MMMM yyyy');
    DateTime dateTime = inputFormat.parse(dateTimeString);

    // Format the DateTime object
    return DateFormat('hh:mm a (EEEE)').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (orders == null) {
      // Show loading indicator while orders are being loaded
      return const Center(child: CircularProgressIndicator());
    }

    return _buildOrdersTable(); // Build the table once orders are loaded
  }

  Widget _buildOrdersTable() {
    int filteredOrderIndex = 1;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      // margin: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: DataTable2(
          columnSpacing: 8,
          horizontalMargin: 8,
          minWidth: 800,
          headingTextStyle: const TextStyle(color: Colors.white, inherit: false),
          headingRowDecoration: const BoxDecoration(color: Colors.green),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          sortArrowBuilder: (bool sorted, bool ascending) {
            if (sorted && _sortColumnIndex == 0) {
              // Check if this is the sorted column
              return Icon(
                ascending ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                color: Colors.white,
                size: 0,
              );
            } else {
              return Container(); // No icon when not sorted or not the sorted column
            }
          },
          sortArrowAnimationDuration: const Duration(milliseconds: 900),
          columns: <DataColumn>[
            const DataColumn2(
              label: Center(child: Text('No.', style: TextStyle(fontSize: 14, color: Colors.white))),
              size: ColumnSize.S,
            ),
            DataColumn2(
              size: ColumnSize.L,
              label: const Center(
                child: Text(
                  'Order Number',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) => int.parse(a.orderNumber.split('-')[1]).compareTo(int.parse(b.orderNumber.split('-')[1])));
                  } else {
                    orders?.data.sort((a, b) => int.parse(b.orderNumber.split('-')[1]).compareTo(int.parse(a.orderNumber.split('-')[1])));
                  }
                });
              },
            ),
            DataColumn2(
              size: ColumnSize.L,
              label: const Center(
                child: Text(
                  'Transaction',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) {
                      var aTime = a.paymentTime != "None" ? a.paymentTime : a.cancelledTime;
                      var bTime = b.paymentTime != "None" ? b.paymentTime : b.cancelledTime;
                      return aTime.compareTo(bTime);
                    });
                  } else {
                    orders?.data.sort((a, b) {
                      var aTime = a.paymentTime != "None" ? a.paymentTime : a.cancelledTime;
                      var bTime = b.paymentTime != "None" ? b.paymentTime : b.cancelledTime;
                      return bTime.compareTo(aTime);
                    });
                  }
                });
              },
            ),
            DataColumn2(
              label: const Center(
                  child: Text(
                'Qty',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
              size: ColumnSize.S,
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) => a.totalQuantity.compareTo(b.totalQuantity));
                  } else {
                    orders?.data.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));
                  }
                });
              },
            ),
            DataColumn2(
              label: const Center(
                  child: Text(
                'Status',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) => a.status.compareTo(b.status));
                  } else {
                    orders?.data.sort((a, b) => b.status.compareTo(a.status));
                  }
                });
              },
            ),
            DataColumn2(
              label: const Center(
                  child: Text(
                'Payment',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) => a.paymentMethod.compareTo(b.paymentMethod));
                  } else {
                    orders?.data.sort((a, b) => b.paymentMethod.compareTo(a.paymentMethod));
                  }
                });
              },
            ),
            DataColumn2(
              label: const Center(
                  child: Text(
                'Sales(RM)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  if (ascending) {
                    orders?.data.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
                  } else {
                    orders?.data.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
                  }
                });
              },
            ),
            const DataColumn2(
              label: Center(
                  child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
            ),
          ],
          rows: (orders?.data.asMap().entries
        .where((entry) {
          log('Orders data: ${orders?.data}');
          SelectedOrder order = entry.value;
          return (order.status == "Paid" || order.status == "Cancelled");
        })
        .map((entry) {
          SelectedOrder order = entry.value;

          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) return Colors.white10;
              return const Color(0xff1f2029);
            }),
            cells: <DataCell>[
              DataCell(Center(
                child: Text(
                  (filteredOrderIndex++).toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.status == "Paid" ? formatDateTime(order.paymentTime) : formatDateTime(order.cancelledTime),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.totalQuantity.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.paymentMethod,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: Text(
                  order.totalPrice.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )),
              DataCell(Center(
                child: IconButton(
                  icon: const Icon(Icons.file_open, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryOrderPage(
                          historyOrder: order,
                        ),
                      ),
                    );
                  },
                ),
              )),
            ],
          );
        }).toList()) ?? [], // Fallback to an empty list if orders is null

        ),
      ),
    );
  }
}
