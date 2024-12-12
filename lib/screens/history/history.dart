import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/providers/orders_provider.dart';
import 'package:jspos/shared/history_order.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends ConsumerState<HistoryPage> with SingleTickerProviderStateMixin {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  Orders? orders;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    orders = ref.read(ordersProvider);
    for (var order in orders!.data) {
      log('InitState - Order Number: ${order.orderNumber}, Total Quantity: ${order.totalQuantity}');
    }
    // Access OrdersNotifier and log payment times
    // ref.read(ordersProvider.notifier).logPaymentTimes();
    _sortByTransactionDate(ascending: false);
    // loadOrders();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sortByTransactionDate({required bool ascending}) {
    orders?.data.sort((a, b) {
      var aTime = (a.paymentTime != "None" && a.paymentTime.isNotEmpty) ? a.paymentTime : a.cancelledTime;
      var bTime = (b.paymentTime != "None" && b.paymentTime.isNotEmpty) ? b.paymentTime : b.cancelledTime;

      DateTime aDate;
      DateTime bDate;
      try {
        aDate = DateFormat('h:mm a, d MMMM yyyy').parse(aTime);
      } catch (e) {
        log('Date parsing error for aTime: $aTime - $e');
        aDate = DateTime(2024); // Default to a recent year
      }

      try {
        bDate = DateFormat('h:mm a, d MMMM yyyy').parse(bTime);
      } catch (e) {
        log('Date parsing error for bTime: $bTime - $e');
        bDate = DateTime(2024); // Default to a recent year
      }

      return ascending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });
  }

  Map<String, List<SelectedOrder>> groupOrdersByDate() {
    // Group orders by formatted date (e.g., "10 October 2023")
    Map<String, List<SelectedOrder>> groupedOrders = {};
    for (var order in orders!.data) {
      log('Before Grouping - Order Number: ${order.orderNumber}, Total Quantity: ${order.totalQuantity}');
      if (order.status == "Paid" || order.status == "Cancelled") {
        String dateKey = formatDateOnly(order.paymentTime != "None" ? order.paymentTime : order.cancelledTime);
        if (groupedOrders[dateKey] == null) {
          groupedOrders[dateKey] = [];
        }
        groupedOrders[dateKey]?.add(order);
      }
    }
    return groupedOrders;
  }

  String formatDateOnly(String dateTimeString) {
    try {
      if (dateTimeString.isEmpty) {
        throw const FormatException('Empty date string');
      }

      DateFormat inputFormat = DateFormat('h:mm a, d MMMM yyyy');
      DateTime dateTime = inputFormat.parse(dateTimeString);
      return DateFormat('d MMMM yyyy').format(dateTime);
    } catch (e) {
      log('Date parsing error in formatDateOnly: $e');
      return 'Invalid Date';
    }
  }

  String formatDateTime(String dateTimeString) {
    try {
      if (dateTimeString.isEmpty) {
        throw const FormatException('Empty date string');
      }

      DateFormat inputFormat = DateFormat('h:mm a, d MMMM yyyy');
      DateTime dateTime = inputFormat.parse(dateTimeString);
      return DateFormat('hh:mm a (EEEE)').format(dateTime);
    } catch (e) {
      log('Date parsing error in formatDateTime: $e');
      return 'Invalid Date';
    }
  }

  int _resolveInvoiceNumberValue(SelectedOrder order, int Function() nullHandler) {
    if (order.invoiceNumber == null) {
      return nullHandler(); // Assign a unique negative value for nulls.
    }

    // Extract the last 4 digits of the invoiceNumber.
    final match = RegExp(r'\d{4}$').firstMatch(order.invoiceNumber!);
    return match != null ? int.parse(match.group(0)!) : 0; // Default to 0 if no digits are found.
  }

  @override
  Widget build(BuildContext context) {
    // Return a loading spinner if orders are not loaded yet
    if (orders == null) {
      return Center(
        child: SpinKitCubeGrid(
          color: Colors.green,
          size: 50.0,
          controller: _controller,
        ),
      );
    }

    // Safely call groupOrdersByDate() only when orders are loaded
    Map<String, List<SelectedOrder>> groupedOrders = orders != null ? groupOrdersByDate() : {};

    // Check if there are no completed or cancelled orders
    if (groupedOrders.isEmpty) {
      return Center(
        child: Text(
          "No Completed Orders Yet",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]), // Adjust style as needed
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 100),
          child: SingleChildScrollView(
            child: Column(
              children: groupedOrders.entries.map((entry) {
                String date = entry.key;
                List<SelectedOrder> ordersForDate = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5.0), // Rounded corners (optional)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (ordersForDate.length * 52) + 40,
                        child: _buildOrdersTable(ordersForDate),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersTable(List<SelectedOrder> ordersForDate) {
    int filteredOrderIndex = 1;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: DataTable2(
        columnSpacing: 1,
        horizontalMargin: 1,
        // minWidth: 400,
        headingTextStyle: const TextStyle(fontSize: 14, color: Colors.white, inherit: false),
        dataRowHeight: 52, // Set row height (default is 48)
        headingRowHeight: 40, // Set header row height (default is 56)
        headingRowDecoration: const BoxDecoration(color: Colors.green),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        sortArrowAnimationDuration: const Duration(milliseconds: 900),
        columns: _buildColumns(),
        rows: ordersForDate.map((order) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) return Colors.white10;
              return const Color(0xff1f2029);
            }),
            cells: _buildDataCells(order, filteredOrderIndex++),
          );
        }).toList(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn2(
        label: Center(child: Text('No.')),
        size: ColumnSize.S,
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: const Center(
          child: Text(
            'Invoice Number',
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

            int nullCounter = 0; // Tracks unique negative values for nulls.

            orders?.data.sort((a, b) {
              final aValue = _resolveInvoiceNumberValue(a, () => --nullCounter);
              final bValue = _resolveInvoiceNumberValue(b, () => --nullCounter);

              return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
            });
          });
        },
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: const Center(
          child: Text(
            'Transaction',
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
        )),
      ),
    ];
  }

  List<DataCell> _buildDataCells(SelectedOrder order, int index) {
    // log('Order Number: ${order.orderNumber}, Total Quantity: ${order.totalQuantity}');
    return [
      // This will handle each order's cell data, formatting as per your original build orders table
      DataCell(Center(
        child: Text(
          index.toString(),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      )),
      DataCell(Center(
        child: Text(
          order.invoiceNumber ?? order.orderNumber,
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
          // textAlign: TextAlign.center,
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
          // textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: order.status == "Paid" ? Colors.white : Colors.red,
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
    ];
  }
}




  // Future<void> loadOrders() async {
  //   try {
  //     var ordersBox = await Hive.openBox<Orders>('orders');
  //     var ordersData = ordersBox.get('orders');

  //     setState(() {
  //       orders = ordersData ?? Orders(data: []);
  //       _sortByTransactionDate(ascending: false); // Sort by latest first
  //     });
  //   } catch (e) {
  //     log('An error occurred while loading orders: $e');
  //   }
  // }