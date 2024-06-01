import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';
import 'package:jspos/shared/make_payment.dart';
import 'package:jspos/data/menu_data.dart';
import 'dart:developer';
import 'package:jspos/data/tables_data.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// SpinningLines, FoldingCube,  DancingSquare
          // return Container();
          // const SpinKitChasingDots(
          //   color: Colors.white,
          //   size: 100.0,
          // ); 

class DineInPage extends StatefulWidget {
  final void Function() freezeSideMenu;
  final Orders orders;
  const DineInPage({super.key, required this.freezeSideMenu, required this.orders});
  @override
  State<DineInPage> createState() => _DineInPageState();
}

class _DineInPageState extends State<DineInPage> {
  List<Map<String, dynamic>> tables = [];

  @override
  void initState() {
    super.initState();
    loadTables();
    handleMethod = defaultMethod;
  }

  void loadTables() async {
    var tablesBox = Hive.box('tables');
    var data = tablesBox.get('tables');
    if (data != null) {
      tables = (data as List).map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      // Handle the case where 'tables' is not in the box
      // For example, you might want to initialize 'tables' with default values
    }
    setState(() {}); // Call setState to trigger a rebuild of the widget
  }

  bool showMenu = false;
  int orderCounter = 1;
  late int selectedTableIndex;
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
    paymentMethod: "Cash",
    showEditBtn: false,
    categoryList: categories,
    amountReceived: 0,
    amountChanged: 0,
    roundingAdjustment: 0,
    totalQuantity: 0,
  );
  // quantity: 0,
  // remarks: "No Remarks",
  // itemCounts: {},
  // itemQuantities: {},
  // totalItems: 0,

  String generateID(String tableName) {
    final paddedCounter = orderCounter.toString().padLeft(4, '0');
    final tableNameWithoutSpace = tableName.replaceAll(RegExp(r'\s'), '');
    final orderNumber = '#Table$tableNameWithoutSpace-$paddedCounter';
    orderCounter++;
    return orderNumber;
  }

  void printTables() {
    // Get the 'tables' box
    var tablesBox = Hive.box('tables');

    List<Map<String, dynamic>> tables = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();

    // Print the tables list to the console
    log('Tables: $tables');
  }

  void updateTables(int index, String orderNumber, bool isOccupied) async {
    try {
      if (Hive.isBoxOpen('tables')) {
        // Get the 'tables' box
        var tablesBox = Hive.box('tables');
        var rawTables = tablesBox.get('tables');
        if (rawTables != null) {
          // Get the tables list from the box and cast it to the correct type
          List<Map<String, dynamic>> tables = (rawTables as List).map((item) => Map<String, dynamic>.from(item)).toList();
          tables[index]['orderNumber'] = orderNumber;
          tables[index]['occupied'] = isOccupied;
          // Write the updated tables list back to the box
          tablesBox.put('tables', tables);
          printTables();
        } else {
          log('DINEIN Page: Tables data is null');
        }
      }
    } catch (e) {
      log('DINEIN Page: Failed to update tables in Hive: $e');
      // Handle the exception as appropriate for your app
    }
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
          var isOccupied = true;
          handlefreezeMenu();
          orderNumber = generateID(tableName);
          tables[index]['orderNumber'] = orderNumber;
          tables[index]['occupied'] = isOccupied;
          updateTables(index, orderNumber, isOccupied);

          // Generate a new instance of selectedOrder first, and then only assign it's fields and details to the selectedOrder
          selectedOrder = selectedOrder.newInstance(categories);
          selectedOrder.orderNumber = orderNumber;
          selectedOrder.tableName = tableName;
          selectedOrder.updateStatus("Ordering");
          tempCartItems = [];
          // below these are important updates for the UI, have to manually update it to cause rerender in orderDetails page.
          orderStatus = "Empty Cart";
          orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
          orderStatusIcon = Icons.shopping_cart;
        } else {
          // If the table is occupied, use the existing orderNumber
          orderNumber = tables[index]['orderNumber'];
          var order = widget.orders.getOrder(orderNumber);

          // If an order with the same orderNumber exists, update selectedOrder with its details
          if (order != null) {
            order.showEditBtn = true;
            selectedOrder = order;
            tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
            selectedOrder.calculateItemsAndQuantities();
          }
        }
      }
    });
    printTables();
    saveSelectedOrderToHive();
    updateOrderStatus();
  }

  void printSelectedOrders() {
    var selectedOrderBox = Hive.box('selectedOrder');
    var selectedOrder = selectedOrderBox.get('selectedOrder');
    log('selectedOrder: $selectedOrder');
  }

  void saveSelectedOrderToHive() async {
    try {
      if (Hive.isBoxOpen('tables')) {
        var selectedOrderBox = Hive.box('selectedOrder');
        await selectedOrderBox.put('selectedOrder', selectedOrder);
        // printSelectedOrders();
      }
    } catch (e) {
      log('DINEIN Page: Failed to save selectedOrder to Hive: $e');
    }
  }

  void onItemAdded(Item item) {
    setState(() {
      // Try to find an item in selectedOrder.items with the same id as the new item
      addItemtoCart(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[700],
          duration: const Duration(milliseconds: 300),
          content: Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  // Icons.check_circle,
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5), // provide some space between the icon and text
                Text(
                  "RM ${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void addItemtoCart(item) {
    selectedOrder.addItem(item);
    selectedOrder.updateTotalCost(0);
    if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == false && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
      handleMethod = handleUpdateOrderBtn;
    }
    updateOrderStatus();
  }

  void resetSelectedTable() {
    var resetOrderNumber = "";
    tables[selectedTableIndex]['occupied'] = false;
    tables[selectedTableIndex]['orderNumber'] = resetOrderNumber;
    updateTables(selectedTableIndex, resetOrderNumber, false);
  }

  void resetTables() async {
    for (var table in defaultTables) {
      table['occupied'] = false;
      table['orderNumber'] = '';
    }

    // Get the 'tables' box
    var tablesBox = Hive.box('tables');

    // Write the updated defaultTables list back to the box
    await tablesBox.put('tables', defaultTables);
  }
//   void resetSelectedTable(String orderNumber) {
//   final existingTableIndex = data.indexWhere((t) => t.orderNumber == orderNumber);
//   if (existingTableIndex != -1) {
//     // Reset the existing table
//     data[existingTableIndex].occupied = false;
//     data[existingTableIndex].orderNumber = '';
//   }
// }


  bool areItemListsEqual(List<Item> list1, List<Item> list2) {
    // If the lengths of the lists are not equal, the lists are not equal
    if (list1.length != list2.length) {
      // print('Lists have different lengths');
      return false;
    }
    // Create new lists that are sorted copies of the original lists
    List<Item> sortedList1 = List.from(list1)..sort((a, b) => a.name.compareTo(b.name));
    List<Item> sortedList2 = List.from(list2)..sort((a, b) => a.name.compareTo(b.name));
    // Compare the items in the sorted lists
    for (int i = 0; i < sortedList1.length; i++) {
      // print('Comparing item ${i + 1}');
      // print('List 1 item: ${sortedList1[i].name}, quantity: ${sortedList1[i].quantity}');
      // print('List 2 item: ${sortedList2[i].name}, quantity: ${sortedList2[i].quantity}');
      if (sortedList1[i].name != sortedList2[i].name) {
        // print('Items have different names');
        return false;
      }
      if (sortedList1[i].quantity != sortedList2[i].quantity) {
        // print('Items have different quantities');
        return false;
      }
      if (sortedList1[i].itemRemarks != sortedList2[i].itemRemarks) {
        // print('Items have different itemRemarks');
        return false;
      }
    }
    // If no differences were found, the lists are equal
    // print('No differences found, lists are equal');
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
      });
      saveSelectedOrderToHive();
    } else if (selectedOrder.status == "Ordering" && selectedOrder.items.isNotEmpty) {
      _showConfirmationDialog();
    } else if (selectedOrder.status == "Placed Order" && areItemListsEqual(tempCartItems, selectedOrder.items)) {
      handlefreezeMenu();
      selectedOrder.updateShowEditBtn(true);
      orderStatus = "Make Payment";
      orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
      orderStatusIcon = Icons.monetization_on;
      handleMethod = handlePaymentBtn;
      saveSelectedOrderToHive();
    } else if (selectedOrder.status == "Placed Order" && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      _showConfirmationDialog();
    }
  }

  void handleYesButtonPress() {
    // yes to cancel orders or cancel changes
    // print('Button pressed. Current selectedOrder status: ${selectedOrder.status}');
    if (selectedOrder.status == "Ordering") {
      setState(() {
        orderCounter--;
        resetSelectedTable();
        selectedOrder.resetDefault();
      });
      // print('Reset selected table and order. New selectedOrder status: ${selectedOrder.status}');
    } else if (selectedOrder.status == "Placed Order" && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      selectedOrder.updateShowEditBtn(true);
      selectedOrder.items = tempCartItems.map((item) => item.copyWith()).toList();
    } else if (selectedOrder.status == "Placed Order") {
      selectedOrder.updateShowEditBtn(true);
      // print('Menu closed. Current selectedOrder status: ${selectedOrder.status}');
    }
    handlefreezeMenu();
    updateOrderStatus();
  }

  void handlefreezeMenu() {
    widget.freezeSideMenu();
    showMenu = !showMenu;
  }

  void printOrders() async {
    if (Hive.isBoxOpen('orders')) {
      var ordersBox = Hive.box('orders');
      var orders = ordersBox.get('orders');
      log('Orders: $orders');
    }
  }

  void handlePlaceOrderBtn() async {
    setState(() {
      selectedOrder.placeOrder();
      tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
      // Add a new SelectedOrder object to the orders list
      widget.orders.addOrder(selectedOrder.copyWith(categories));
    });
    // Save the updated orders object to Hive
    if (Hive.isBoxOpen('orders')) {
      var ordersBox = Hive.box('orders');
      ordersBox.put('orders', widget.orders);
      printOrders();
    }
    // Wait for the next frame so that setState has a chance to rebuild the widget
    await Future.delayed(Duration.zero);
    updateOrderStatus();
    handlefreezeMenu();
  }

  void handleUpdateOrderBtn() {
    setState(() {
      selectedOrder.placeOrder();
      tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
      // Add a new SelectedOrder object to the orders list
      widget.orders.addOrder(selectedOrder.copyWith(categories));
      // Save the updated orders object to Hive
      if (Hive.isBoxOpen('orders')) {
        var ordersBox = Hive.box('orders');
        ordersBox.put('orders', widget.orders);
        printOrders();
      }
      updateOrderStatus();
      handlefreezeMenu();
    });
  }

  void handlePaymentBtn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakePaymentPage(
          selectedOrder: selectedOrder,
          updateOrderStatus: updateOrderStatus,
          orders: widget.orders,
          tables: tables,
          selectedTableIndex: selectedTableIndex,
          updateTables: updateTables,
        ),
      ),
    );
  }

  // setState(() {
  //   selectedOrder.makePayment();
  //   updateOrderStatus();
  // }); Need to put this in the Payment Page after confirm payment.

  //
  VoidCallback? handleMethod;
  void defaultMethod() {
    // did nothing But explained here
    // when Dart creates a new object, it first initializes all the instance variables before it runs the constructor. Therefore, instance methods aren’t available yet.
    // handleMethod is initialized in the initState method, which is called exactly once and then never again for each State object. It’s the first method called after a State object is created, and it’s called before the build method
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // change radius here
            side: const BorderSide(color: Colors.deepOrange, width: 1), // change border color here
          ),
          title: const Text(
            'Confirmation',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          content: Text(
            selectedOrder.status == "Placed Order" ? "Do you want to 'Cancel Changes'?" : "Do you want to 'Cancel Order'?",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  handleYesButtonPress();
                  Navigator.of(context).pop();
                }),
            const SizedBox(width: 2),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 14,
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
  Color orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
  IconData orderStatusIcon = Icons.shopping_cart;

  void updateOrderStatus() {
    setState(() {
      if (selectedOrder.status == "Start Your Order") {
        orderStatus = "Empty Cart";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
        handleMethod = defaultMethod; // Disabled
        orderStatusIcon = Icons.shopping_cart;
        // } else if (selectedOrder.status == "Placed Order" && !selectedOrder.showEditBtn) {
        //   orderStatus = "Update Order & Print";
        //   orderStatusColor = isSameItems ? Colors.grey[500]! : const Color.fromRGBO(46, 125, 50, 1);
        //   handleMethod = isSameItems ? null : handleUpdateOrderBtn; // Disabled if isSameItems is true
      } else if (selectedOrder.status == "Ordering" && selectedOrder.items.isNotEmpty) {
        orderStatus = "Place Order & Print";
        orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = handlePlaceOrderBtn;
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == false) {
        orderStatus = "Update Orders & Print";
        orderStatusColor = areItemListsEqual(tempCartItems, selectedOrder.items) ? const Color.fromRGBO(97, 97, 97, 1) : const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = areItemListsEqual(tempCartItems, selectedOrder.items) ? defaultMethod : handleUpdateOrderBtn; // Disabled
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == true) {
        orderStatus = "Make Payment";
        orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = handlePaymentBtn;
        orderStatusIcon = Icons.monetization_on;
      } else if (selectedOrder.status == "Paid") {
        orderStatus = "COMPLETED (PAID)";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
        handleMethod = defaultMethod;
        orderStatusIcon = Icons.check_circle;
      } else if (selectedOrder.status == "COMPLETED (PAID)") {
        orderStatus = "Paid with DuitNow";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
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
                flex: 12,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text("Please Select Table",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                      ),
                      //Table UI
                      Expanded(
                        child: GridView.builder(
                          itemCount: tables.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Adjust the number of items per row
                            childAspectRatio: 1.8 / 1, // The width will be twice of its height
                            crossAxisSpacing: 10, // Add horizontal spacing
                            mainAxisSpacing: 10, // Add vertical spacing
                          ),
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pressedButtonIndex = index;
                                  _handleSetTables(tables[index]['name'], index);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: pressedButtonIndex == index ? Colors.deepOrangeAccent : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 5, // elevation of the button
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Table',
                                        style: TextStyle(
                                            fontSize: pressedButtonIndex == index ? 12 : 12,
                                            fontWeight: FontWeight.bold,
                                            color: pressedButtonIndex == index ? Colors.white : Colors.black),
                                      ),
                                      Text(
                                        tables[index]['name'],
                                        style: TextStyle(
                                            fontSize: pressedButtonIndex == index ? 12 : 12,
                                            fontWeight: FontWeight.bold,
                                            color: pressedButtonIndex == index ? Colors.white : Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 3),
                                  if (tables[index]['occupied'])
                                    Icon(
                                      Icons.dinner_dining_rounded,
                                      color: pressedButtonIndex == index ? Colors.white : Colors.deepOrangeAccent,
                                      size: pressedButtonIndex == index ? 30 : 30,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          var ordersBox = Hive.box('orders');
                          var tablesBox = Hive.box('tables');
                          await ordersBox.clear();
                          await tablesBox.clear();
                          log('All data in orders box has been cleared.');

                          setState(() {
                            widget.orders.clearOrders();
                            resetTables();
                            selectedOrder.resetDefault();
                          });

                          if (tablesBox.isEmpty) {
                            tablesBox.put('tables', defaultTables.map((item) => Map<String, dynamic>.from(item)).toList());
                          }

                          log('Tables data has been reset to the default values.');
                          log('tables $tables');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Clear Local Storage Data',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                flex: 12,
                child: MenuPage(
                  onClick: _handleCloseMenu,
                  selectedOrder: selectedOrder,
                  onItemAdded: onItemAdded,
                ),
              ),
        Expanded(
          flex: 8,
          child: OrderDetails(
            selectedOrder: selectedOrder,
            orderStatusColor: orderStatusColor,
            orderStatusIcon: orderStatusIcon,
            orderStatus: orderStatus,
            handleMethod: handleMethod,
            handlefreezeMenu: handlefreezeMenu,
            updateOrderStatus: updateOrderStatus,
            onItemAdded: onItemAdded,
            resetSelectedTable: resetSelectedTable,
          ),
        ),
      ],
    );
  }
}

// close it when you seldom use it, in our case, we need it because of consistently write and read. 
// @override
// void dispose() {
//   Hive.box('orders').close();
//   super.dispose();
// }

// void prettyPrintTable() {
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

// print("selecteded item: $item");
// print("tempCartItems: $tempCartItems");
// print("selectedOrder.status: ${selectedOrder.status}");
// print("selectedOrder.showEditBtn: ${selectedOrder.showEditBtn}");
// print('Selected Table: ');
// print('selectedOrder items: ${selectedOrder.items}');
// print('tempCartItems: $tempCartItems');
// print('-------------------------');
// }
