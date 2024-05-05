import 'package:flutter/material.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/selected_table_order.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';

class DineInPage extends StatefulWidget {
  const DineInPage({super.key});
  @override
  State<DineInPage> createState() => _DineInPageState();
}

class _DineInPageState extends State<DineInPage> {
  Map<String, dynamic>? selectedTable;
  bool isTableClicked = false;
  int orderCounter = 1;
  int? selectedTableIndex;
  String orderNumber = "";
  // Create a new SelectedTableOrder instance
  SelectedTableOrder selectedOrder = SelectedTableOrder(
    orderNumber: "Order Number",
    tableName: "Table Name",
    orderType: "Dine-In",
    status: "Start Your Order",
    items: [], // Add your items here
    subTotal: 0,
    serviceCharge: 0,
    totalPrice: 0,
    quantity: 0,
    paymentMethod: "Cash",
    remarks: "No Remarks",
    showEditBtn: false,
  );
  void prettyPrintTable() {
    if (selectedTable != null) {
      // print('Selected Table:');
      // print('Table ID: ${selectedTable!['id']}');
      // print('Table Name: ${selectedTable!['name']}');
      // print('Occupied: ${selectedTable!['occupied']}');
      // print('Order Number: ${selectedTable!['orderNumber']}');
      // print('-------------------------');

      print('Selected Order:');
      print('Order Number: ${selectedOrder.orderNumber}');
      print('Table Name: ${selectedOrder.tableName}');
      print('Order Type: ${selectedOrder.orderType}');
      print('Order Type: ${selectedOrder.orderTime}');
      print('Order Type: ${selectedOrder.orderDate}');
      print('Status: ${selectedOrder.status}');
      // print('Items: ${selectedOrder.items}');
      print('-------------------------');
    }
  }

  String generateID(String tableName) {
    final paddedCounter = orderCounter.toString().padLeft(4, '0');
    final tableNameWithoutSpace = tableName.replaceAll(RegExp(r'\s'), '');
    final orderNumber = '#$tableNameWithoutSpace-$paddedCounter';
    orderCounter++;
    return orderNumber;
  }

  void _handleSetTables(String tableName, int index) {
    setState(() {
      isTableClicked = !isTableClicked;
      orderNumber = generateID(tableName);

      tables[index]['occupied'] = true;
      tables[index]['orderNumber'] = orderNumber;

      // Set the selected table and its index
      selectedTable = tables[index];
      selectedTableIndex = index;

      // Update selectedOrder
      selectedOrder.tableName = tableName;
      selectedOrder.orderNumber = orderNumber;
    });
  }

  void _handleOpenMenu() {
    setState(() {
      if (selectedTableIndex != null) {
        orderCounter--;
        tables[selectedTableIndex!]['occupied'] = false;
        tables[selectedTableIndex!]['orderNumber'] = "";
        selectedOrder.tableName = "Table Name";
        selectedOrder.orderNumber = "Order Number";
      }
      isTableClicked = !isTableClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isTableClicked == false
            ? Expanded(
                flex: 14,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                        child: Text("Please Select Table",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            )),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          itemCount: tables.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                4, // Adjust the number of items per row
                            childAspectRatio:
                                2 / 1, // Adjust the aspect ratio of the items
                            crossAxisSpacing: 10, // Add horizontal spacing
                            mainAxisSpacing: 10, // Add vertical spacing
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Add padding to each card
                              child: ElevatedButton(
                                onPressed: () {
                                  _handleSetTables(
                                      tables[index]['name'], index);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5, // elevation of the button
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tables[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      tables[index]['occupied']
                                          ? 'Occupied'
                                          : 'Empty',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: tables[index]['occupied']
                                              ? Colors.red
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : MenuPage(
                onClick: _handleOpenMenu,
                selectedOrder: selectedOrder,
                onItemAdded: (item) {
                  setState(() {
                    // Try to find an item in selectedOrder.items with the same id as the new item
                    selectedOrder.addItem(item);
                    selectedOrder.updateTotalCost(0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green[700],
                        duration: const Duration(seconds: 1),
                        content: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(
                                  width:
                                      5), // provide some space between the icon and text
                              Text(
                                "${item.name}!",
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    Future.delayed(Duration.zero, () {
                      prettyPrintTable();
                    });
                  });
                },
              ),
        Expanded(
          flex: 6,
          child: OrderDetails(selectedOrder: selectedOrder),
        ),
      ],
    );
  }
}
