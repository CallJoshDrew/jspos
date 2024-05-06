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
      print('Order Time: ${selectedOrder.orderTime}');
      print('Order Date: ${selectedOrder.orderDate}');
      print('Order items: ${selectedOrder.items}');
      print('Order subTotal: ${selectedOrder.subTotal}');
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

  void handlePlaceOrderBtn() {
    setState(() {
      selectedOrder.placeOrder();
      updateOrderStatus();
    });
  }

  void handleUpdateOrderBtn() {
    // ... code to handle update order button ...
  }

  void handlePaymentBtn() {
    setState(() {
      selectedOrder.makePayment();
      updateOrderStatus();  
    });
  }

  String orderStatus = "Empty Cart";
  Color orderStatusColor = Colors.grey[800]!;
  IconData orderStatusIcon = Icons.shopping_cart;

  // 
  VoidCallback? handleMethod;
   void defaultMethod() {
    // did nothing But explained here
    // when Dart creates a new object, it first initializes all the instance variables before it runs the constructor. Therefore, instance methods aren’t available yet.
    // handleMethod is initialized in the initState method, which is called exactly once and then never again for each State object. It’s the first method called after a State object is created, and it’s called before the build method
  }
   @override
  void initState() {
    super.initState();
    handleMethod = defaultMethod;
  }

  void updateOrderStatus() {
    setState(() {
      if (selectedOrder.status == "Ordering" &&
          selectedOrder.items.isNotEmpty) {
        orderStatus = "Place Order & Print";
        orderStatusColor = Colors.deepOrange;
        handleMethod = handlePlaceOrderBtn;
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Status") {
        orderStatus = "Empty Cart";
        orderStatusColor = Colors.grey[500]!;
        // handleMethod = handleInitialBtn; // Disabled
        orderStatusIcon = Icons.remove_shopping_cart;
        // } else if (selectedOrder.status == "Placed Order" && !selectedOrder.showEditBtn) {
        //   orderStatus = "Update Order & Print";
        //   orderStatusColor = isSameItems ? Colors.grey[500]! : Colors.green[800]!;
        //   handleMethod = isSameItems ? null : handleUpdateOrderBtn; // Disabled if isSameItems is true
      } else if (selectedOrder.status == "Placed Order") {
        orderStatus = "Make Payment";
        orderStatusColor = Colors.green[800]!;
        handleMethod = handlePaymentBtn;
        orderStatusIcon = Icons.monetization_on;
      } else if (selectedOrder.status == "Paid") {
        orderStatus = "COMPLETED (PAID)";
        orderStatusColor = Colors.grey[700]!;
        // handleMethod = handleCheckOutBtn;
        orderStatusIcon = Icons.check_circle;
      } else if (selectedOrder.status == "COMPLETED (PAID)") {
        orderStatus = "Cheee";
        orderStatusColor = Colors.grey[700]!;
        handleMethod = defaultMethod; // Disabled
      } else if (selectedOrder.status == "Cancelled") {
        orderStatus = "Cancelled";
        orderStatusColor = Colors.grey[500]!;
        handleMethod = defaultMethod; // Disabled
      }
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
                    selectedOrder.updateStatus("Ordering");
                    updateOrderStatus();
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
          child: OrderDetails(
            selectedOrder: selectedOrder,
            updateOrderStatus: updateOrderStatus,
            orderStatusColor: orderStatusColor,
            orderStatusIcon: orderStatusIcon,
            orderStatus: orderStatus,
            handleMethod: handleMethod,
          ),
        ),
      ],
    );
  }
}
