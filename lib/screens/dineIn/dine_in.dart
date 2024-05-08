import 'package:flutter/material.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';

class DineInPage extends StatefulWidget {
  final void Function() toggleSideMenu;
  final Orders orders;
  const DineInPage(
      {super.key, required this.toggleSideMenu, required this.orders});
  @override
  State<DineInPage> createState() => _DineInPageState();
}

class _DineInPageState extends State<DineInPage> {
  bool isTableClicked = false;
  int orderCounter = 1;
  int? selectedTableIndex;
  String orderNumber = "";
  // String tableName
  // Create a new SelectedOrder instance
  SelectedOrder selectedOrder = SelectedOrder(
    orderNumber: "Order Number",
    tableName: "Table Name",
    orderType: "Dine-In",
    orderTime: "Order Time",
    orderDate: "Order Date",
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
    // print('Selected Table Index: $selectedTableIndex');
    // print('-------------------------');
    // print('Tables');
    // print('Table ID: ${tables!['id']}');
    // print('Table Name: ${tables!['name']}');
    // print('Occupied: ${tables!['occupied']}');
    // print('Order Number: ${tables!['orderNumber']}');
    // print('-------------------------');
    print('-------------------------');
    print('Orders');
    print('latest: ${widget.orders.toString()}');
    print('-------------------------');
    // print('-------------------------');
    // print(widget.orders.toString());
    // print('-------------------------');
    // print('-------------------------');
    // print('Pretty Print:');
    // print('SelectedOrder Number: ${selectedOrder.orderNumber}');
    // print('SelectedOrder Table Name: ${selectedOrder.tableName}');
    // print('-------------------------');
    // print('Order Type: ${selectedOrder.orderType}');
    // print('Order Time: ${selectedOrder.orderTime}');
    // print('Order Date: ${selectedOrder.orderDate}');
    // print('Order items: ${selectedOrder.items}');
    // print('Order subTotal: ${selectedOrder.subTotal}');
    // print('Status: ${selectedOrder.status}');
    // print('Items: ${selectedOrder.items}');
  }

  String generateID(String tableName) {
    final paddedCounter = orderCounter.toString().padLeft(4, '0');
    final tableNameWithoutSpace = tableName.replaceAll(RegExp(r'\s'), '');
    final orderNumber = '#$tableNameWithoutSpace-$paddedCounter';
    orderCounter++;
    return orderNumber;
  }

  // Open Menu after set table number
  void _handleSetTables(String tableName, int index) {
    setState(() {
      widget.toggleSideMenu();
      isTableClicked = !isTableClicked;
      // Set the selected table and its index
      selectedTableIndex = index;

      // Check if a table with the given index exists
      if (index != -1 && index < tables.length) {
        // If the table is not occupied, generate a new orderNumber
        if (!tables[index]['occupied']) {
          orderNumber = generateID(tableName);
          tables[index]['orderNumber'] = orderNumber;
          tables[index]['occupied'] = true;

          // Update selectedOrder
          selectedOrder.orderNumber = orderNumber;
          selectedOrder.tableName = tableName;
          selectedOrder.status = "Start Your Order";
          selectedOrder.items = [];
          selectedOrder.orderTime = "Order Time";
          selectedOrder.orderDate = "Order Date";
          updateOrderStatus();
        } else {
          // If the table is occupied, use the existing orderNumber
          orderNumber = tables[index]['orderNumber'];
          var order = widget.orders.getOrder(orderNumber);
          // print('orderNumber from tables.index: ${tables[index]["orderNumber"]}'); // successfully got the orderNumber correctly.
          // Use getOrder to find an order with the same orderNumber
          print('-------------------------');
          print('Orders');
          print('latest: ${widget.orders}');

          print('-------------------------');
          print('Tables');
          print('selected Table: ${tables[index]}');
          print('-------------------------');
          // Print the orderNumber and the order to the console
          print('SetTables');
          print('orderNumber: $orderNumber');
          print('order: $order');
          print('-------------------------');
          print('SelectedOrder');
          print('orderNumber: ${selectedOrder.orderNumber}');
          print('-------------------------');

          // If an order with the same orderNumber exists, update selectedOrder with its details
          if (order != null) {
            selectedOrder = order;
            updateOrderStatus();
          }
        }
      }
    });
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // change radius here
            side: const BorderSide(
                color: Colors.deepOrange, width: 1), // change border color here
          ),
          title: const Text(
            'Confirmation',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Do you want to "Cancel Order"?',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                setState(() {
                  orderCounter--;
                  // resetSelectedTable();
                  // selectedOrder.resetDefault();
                  updateOrderStatus();
                  widget.toggleSideMenu();
                  isTableClicked = !isTableClicked;
                  prettyPrintTable();
                });
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 6),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // side: const BorderSide(color: Colors.deepOrange, width: 1),
                ),
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetSelectedTable() {
    tables[selectedTableIndex!]['occupied'] = false;
    tables[selectedTableIndex!]['orderNumber'] = "";
  }

  void _handleCloseMenu() {
    if (selectedTableIndex != null && selectedOrder.items.isEmpty) {
      setState(() {
        orderCounter--;
        resetSelectedTable();
        selectedOrder.resetDefault();
        updateOrderStatus();
        widget.toggleSideMenu();
        isTableClicked = !isTableClicked;
        prettyPrintTable();
      });
    } else if (selectedOrder.items.isNotEmpty) {
      _showConfirmationDialog();
    }
  }

  void handlePlaceOrderBtn() {
    setState(() {
      selectedOrder.placeOrder();
      // selectedOrder.orderNumber = orderNumber;
      // selectedOrder.tableName = tableName;
      // Add a new SelectedOrder object to the orders list
      widget.orders.addOrder(SelectedOrder(
        orderNumber: selectedOrder.orderNumber,
        tableName: selectedOrder.tableName,
        orderType: selectedOrder.orderType,
        orderTime: selectedOrder.orderTime,
        orderDate: selectedOrder.orderDate,
        status: selectedOrder.status,
        items:
            List.from(selectedOrder.items), // Create a copy of the items list
        subTotal: selectedOrder.subTotal,
        serviceCharge: selectedOrder.serviceCharge,
        totalPrice: selectedOrder.totalPrice,
        quantity: selectedOrder.quantity,
        paymentMethod: selectedOrder.paymentMethod,
        remarks: selectedOrder.remarks,
        showEditBtn: selectedOrder.showEditBtn,
      ));
      updateOrderStatus();
      widget.toggleSideMenu();
      isTableClicked = !isTableClicked;
      prettyPrintTable();
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
      } else if (selectedOrder.status == "Start Your Order") {
        orderStatus = "Empty Cart";
        orderStatusColor = Colors.grey[800]!;
        handleMethod = defaultMethod; // Disabled
        orderStatusIcon = Icons.shopping_cart;
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
        orderStatus = "Paid with DuitNow";
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
                onClick: _handleCloseMenu,
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
