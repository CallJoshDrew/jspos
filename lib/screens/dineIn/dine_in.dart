import 'package:flutter/material.dart';
import 'package:jspos/data/tables_data.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';

class DineInPage extends StatefulWidget {
  final void Function() freezeSideMenu;
  final Orders orders;
  const DineInPage(
      {super.key, required this.freezeSideMenu, required this.orders});
  @override
  State<DineInPage> createState() => _DineInPageState();
}

class _DineInPageState extends State<DineInPage> {
  bool showMenu = false;
  int orderCounter = 1;
  int? selectedTableIndex;
  String orderNumber = "";
  List<Item> tempCartItems = [];
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
    // print('-------------------------');
    // print('PrettyPrint Orders: ${widget.orders.toString()}');
    // print('-------------------------');
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

  int pressedButtonIndex = -1;
  // Open Menu after set table number
  void _handleSetTables(String tableName, int index) {
    setState(() {
      // Set the selected table and its index
      selectedTableIndex = index;

      // Check if a table with the given index exists
      if (index != -1 && index < tables.length) {
        // If the table is not occupied, generate a new orderNumber
        if (!tables[index]['occupied']) {
          handlefreezeMenu();
          orderNumber = generateID(tableName);
          tables[index]['orderNumber'] = orderNumber;
          tables[index]['occupied'] = true;

          // Generate a new instance of selectedOrder first, and then only assign it's fields and details to the selectedOrder
          selectedOrder = selectedOrder.newInstance();
          selectedOrder.orderNumber = orderNumber;
          selectedOrder.tableName = tableName;
          selectedOrder.updateStatus("Ordering");

          tempCartItems = [];
          // below these are important updates for the UI, have to manually update it to cause rerender in orderDetails page.
          orderStatus = "Empty Cart";
          orderStatusColor = Colors.grey[700]!;
          orderStatusIcon = Icons.shopping_cart;
          // Print orderNumber and selectedOrder details to the console
          // print('New orderNumber: $orderNumber');
          // print('selectedOrder details: $selectedOrder');
        } else {
          // If the table is occupied, use the existing orderNumber
          orderNumber = tables[index]['orderNumber'];
          var order = widget.orders.getOrder(orderNumber);

          // If an order with the same orderNumber exists, update selectedOrder with its details
          if (order != null) {
            order.showEditBtn = true;
            selectedOrder = order;
            tempCartItems = List.from(selectedOrder.items);
            // tempCartItems = selectedOrder.items.map((item) => item.copyWith()).toList(); use this if above got issue of references.

            // Print orderNumber and selectedOrder details to the console
            // print('Existing orderNumber: $orderNumber');
            // print('selectedOrder details: $selectedOrder');
            // print('tempCartItems: $tempCartItems');
          }
        }
      }
    });

    // Call updateOrderStatus() after the state has been updated
    updateOrderStatus();
  }

  void onItemAdded(Item item) {
  setState(() {
    // Try to find an item in selectedOrder.items with the same id as the new item
    addItemtoCart(item);
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
              const SizedBox(width: 5), // provide some space between the icon and text
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
    // Future.delayed(Duration.zero, () {
    //   prettyPrintTable();
    // });
  });
}

  void addItemtoCart(item) {
    selectedOrder.addItem(item);
    selectedOrder.updateTotalCost(0);
    print("selectedOrder.items: ${selectedOrder.items}");
    print("tempCartItems: $tempCartItems");
    // print("selectedOrder.status: ${selectedOrder.status}");
    // print("selectedOrder.showEditBtn: ${selectedOrder.showEditBtn}");
    if (selectedOrder.status == "Placed Order" &&
        selectedOrder.showEditBtn == false &&
        !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      orderStatusColor = Colors.green[800]!;
      handleMethod = handleUpdateOrderBtn;
    }
    updateOrderStatus();
  }

  void resetSelectedTable() {
    tables[selectedTableIndex!]['occupied'] = false;
    tables[selectedTableIndex!]['orderNumber'] = "";
  }

  bool areItemListsEqual(List<Item> list1, List<Item> list2) {
    // If the lengths of the lists are not equal, the lists are not equal
    if (list1.length != list2.length) {
      return false;
    }
    // Sort the lists by item id
    list1.sort((a, b) => a.id.compareTo(b.id));
    list2.sort((a, b) => a.id.compareTo(b.id));
    // Compare the items in the sorted lists
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id ||
          list1[i].name != list2[i].name ||
          list1[i].quantity !=
              list2[i]
                  .quantity /* add other property comparisons as needed */) {
        return false;
      }
    }
    // If no differences were found, the lists are equal
    return true;
  }

  void _handleCloseMenu() {
    if (selectedOrder.status == "Ordering" && selectedOrder.items.isEmpty) {
      setState(() {
        orderCounter--;
        resetSelectedTable();
        selectedOrder.resetDefault();
        updateOrderStatus();
        handlefreezeMenu();
        prettyPrintTable();
      });
    } else if (selectedOrder.status == "Ordering" &&
        selectedOrder.items.isNotEmpty) {
      _showConfirmationDialog();
    } else if (selectedOrder.status == "Placed Order" &&
        areItemListsEqual(tempCartItems, selectedOrder.items)) {
      handlefreezeMenu();
      selectedOrder.updateShowEditBtn(true);
      orderStatus = "Make Payment";
      orderStatusColor = Colors.green[800]!;
      orderStatusIcon = Icons.monetization_on;
    } else if (selectedOrder.status == "Placed Order" &&
        !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      _showConfirmationDialog();
    }
  }

  void handleYesButtonPress() {
    print(
        'Button pressed. Current selectedOrder status: ${selectedOrder.status}');
    if (selectedOrder.status == "Ordering") {
      setState(() {
        orderCounter--;
        resetSelectedTable();
        selectedOrder.resetDefault();
      });
      print(
          'Reset selected table and order. New selectedOrder status: ${selectedOrder.status}');
    } else if (selectedOrder.status == "Placed Order" &&
        !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      selectedOrder.updateShowEditBtn(true);
      selectedOrder.items =
          tempCartItems.map((item) => item.copyWith()).toList();
    } else if (selectedOrder.status == "Placed Order") {
      selectedOrder.updateShowEditBtn(true);
      print(
          'Menu closed. Current selectedOrder status: ${selectedOrder.status}');
    }
    handlefreezeMenu();
    updateOrderStatus();
  }

  void handlefreezeMenu() {
    widget.freezeSideMenu();
    showMenu = !showMenu;
  }

  void handlePlaceOrderBtn() {
    setState(() {
      selectedOrder.placeOrder();
      tempCartItems =
          selectedOrder.items.map((item) => item.copyWith()).toList();
      // Add a new SelectedOrder object to the orders list
      widget.orders.addOrder(selectedOrder.copyWith());
      updateOrderStatus();
      handlefreezeMenu();
      prettyPrintTable();
    });
  }

  void handleUpdateOrderBtn() {
    setState(() {
      selectedOrder.placeOrder();
      tempCartItems =
          selectedOrder.items.map((item) => item.copyWith()).toList();
      // Add a new SelectedOrder object to the orders list
      widget.orders.addOrder(selectedOrder.copyWith());
      updateOrderStatus();
      handlefreezeMenu();
      prettyPrintTable();
    });
  }

  void handlePaymentBtn() {
    setState(() {
      selectedOrder.makePayment();
      updateOrderStatus();
    });
  }

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
          content: Text(
            selectedOrder.status == "Placed Order"
                ? "Do you want to 'Cancel Changes'?"
                : "Do you want to 'Cancel Order'?",
            style: const TextStyle(
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
                  handleYesButtonPress();
                  Navigator.of(context).pop();
                }),
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

  String orderStatus = "Empty Cart";
  Color orderStatusColor = Colors.grey[700]!;
  IconData orderStatusIcon = Icons.shopping_cart;

  void updateOrderStatus() {
    // print("selectedOrder items:${selectedOrder.items}");
    // print("tempCartItems :$tempCartItems");
    // print("updateOrderStatus :${selectedOrder.status}");

    setState(() {
      if (selectedOrder.status == "Start Your Order") {
        orderStatus = "Empty Cart";
        orderStatusColor = Colors.grey[700]!;
        handleMethod = defaultMethod; // Disabled
        orderStatusIcon = Icons.shopping_cart;
        // } else if (selectedOrder.status == "Placed Order" && !selectedOrder.showEditBtn) {
        //   orderStatus = "Update Order & Print";
        //   orderStatusColor = isSameItems ? Colors.grey[500]! : Colors.green[800]!;
        //   handleMethod = isSameItems ? null : handleUpdateOrderBtn; // Disabled if isSameItems is true
      } else if (selectedOrder.status == "Ordering" &&
          selectedOrder.items.isNotEmpty) {
        orderStatus = "Place Order & Print";
        orderStatusColor = Colors.deepOrange;
        handleMethod = handlePlaceOrderBtn;
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" &&
          selectedOrder.showEditBtn == false) {
        orderStatus = "Update Orders & Print";
        orderStatusColor = areItemListsEqual(tempCartItems, selectedOrder.items)
            ? Colors.grey[700]!
            : Colors.green[800]!;
        handleMethod = areItemListsEqual(tempCartItems, selectedOrder.items)
            ? defaultMethod
            : handleUpdateOrderBtn; // Disabled
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" &&
          selectedOrder.showEditBtn == true) {
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
        orderStatusColor = Colors.red[500]!;
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
        showMenu == false
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
                                  setState(() {
                                    pressedButtonIndex = index;
                                    _handleSetTables(
                                        tables[index]['name'], index);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: pressedButtonIndex == index
                                      ? Colors.deepOrangeAccent
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5, // elevation of the button
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tables[index]['name'],
                                      style: TextStyle(
                                          fontSize: pressedButtonIndex == index ? 28 : 22,
                                          fontWeight: FontWeight.bold,
                                          color: pressedButtonIndex == index
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    const SizedBox(width: 10),
                                    if (tables[index]['occupied'])
                                      Icon(
                                        Icons.dining,
                                        color: pressedButtonIndex == index
                                            ? Colors.white
                                            : Colors.deepOrangeAccent,
                                        size: pressedButtonIndex == index ? 46 : 40,
                                      ),

                                    // if (tables[index]['occupied'])
                                    //   Text(
                                    //     'Seated',
                                    //     style: TextStyle(
                                    //         fontSize: 22,
                                    //         color: pressedButtonIndex == index ? Colors.white: Colors.deepOrange),
                                    //   ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            : MenuPage(
                onClick: _handleCloseMenu,
                selectedOrder: selectedOrder,
                onItemAdded: onItemAdded,
              ),
        Expanded(
          flex: 6,
          child: OrderDetails(
            selectedOrder: selectedOrder,
            orderStatusColor: orderStatusColor,
            orderStatusIcon: orderStatusIcon,
            orderStatus: orderStatus,
            handleMethod: handleMethod,
            handlefreezeMenu: handlefreezeMenu,
            updateOrderStatus: updateOrderStatus,
            onItemAdded: onItemAdded,
          ),
        ),
      ],
    );
  }
}
