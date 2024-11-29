// import 'dart:convert';
// import 'package:intl/intl.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
// import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/print_jobs.dart';
import 'package:jspos/providers/orders_provider.dart';
import 'package:jspos/providers/tables_provider.dart';
import 'package:jspos/providers/order_counter_provider.dart';
import 'package:jspos/providers/selected_order_provider.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';
import 'package:jspos/shared/make_payment.dart';
import 'package:jspos/data/menu1_data.dart';
// import 'package:jspos/data/menu_data.dart';
import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:jspos/shared/print_items.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// SpinningLines, FoldingCube,  DancingSquare
// return Container();
// const SpinKitChasingDots(
//   color: Colors.white,
//   size: 100.0,
// );
class DineInPage extends ConsumerStatefulWidget {
  final void Function() freezeSideMenu;
  const DineInPage({
    super.key,
    required this.freezeSideMenu,
  });
  @override
  DineInPageState createState() => DineInPageState();
}

class DineInPageState extends ConsumerState<DineInPage> {
  late Orders orders;
  List<Map<String, dynamic>> tables = [];
  late int orderCounter;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Initialize orders and other data synchronously
    orders = ref.read(ordersProvider);
    orderCounter = ref.read(orderCounterProvider); // Directly read initial order counter

    tables = ref.read(tablesProvider); // Directly read initial tables data
    Future.microtask(() {
      ref.read(selectedOrderProvider.notifier).initializeNewOrder(categories);
    });

    isLoading = false; // Set loading flag to false if needed
    handleMethod = defaultMethod;
  }
  // Unified function to load tables and order counter

  bool isTableSelected = false;

  bool showMenu = false;

  late int selectedTableIndex;
  String orderNumber = "";
  List<Item> tempCartItems = [];

  String generateID(String tableName, WidgetRef ref) {
    // Access the current orderCounter from the provider
    final currentOrderCounter = ref.read(orderCounterProvider);

    // Properly format the counter with 4 digits (0001, 0002, etc.)
    final paddedCounter = currentOrderCounter.toString().padLeft(4, '0');

    // Remove any whitespace in the table name
    final tableNameWithoutSpace = tableName.replaceAll(RegExp(r'\s+'), '');

    // Construct the order number correctly
    final orderNumber = '#$tableNameWithoutSpace-$paddedCounter';

    // Increment the counter
    final updatedOrderCounter = currentOrderCounter + 1;

    // Update the orderCounter in the provider and then save it to Hive
    ref.read(orderCounterProvider.notifier).updateOrderCounter(updatedOrderCounter);

    // Log the generated order number for debugging
    // log('Generated order number: $orderNumber');
    // log('Updated orderCounter to: $updatedOrderCounter');

    return orderNumber;
  }

  int pressedButtonIndex = -1;
  void _handleSetTables(String tableName, int index) {
    // Log the entry into the function with the table name and index
    // log('Entering _handleSetTables with $tableName at index: $index');
    try {
      setState(() {
        // Retrieve the latest tables data from the provider
        final tablesData = ref.read(tablesProvider);
        var currentTable = tablesData[index];
        log('Current table data: $currentTable');

        // Update the selected table index
        selectedTableIndex = index;
        log('the index is $index and selectedtableIndex is $selectedTableIndex');

        // Access the selected order provider to manage the current order status
        final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
        final selectedOrder = ref.read(selectedOrderProvider);

        // Check if the selected table is unoccupied
        if (!currentTable['occupied']) {
          log('current selectedOrder is: $selectedOrder');
          // Determine if the 'occupied' field is false (table is unoccupied)
          bool isOccupied = currentTable['occupied'] == true;
          if (!isOccupied) {
            log('Table is not occupied, creating new order.');
          }
          handlefreezeMenu();
          // Initialize a new order instance for the table
          selectedOrderNotifier.initializeNewOrder(categories);
          // Set order status to 'Ordering' as no items are yet selected
          selectedOrderNotifier.updateStatus("Ordering");
          // Clear any existing items in the temporary cart
          tempCartItems = [];
          // Update UI elements related to order status for an empty cart
          orderStatus = "Empty Cart";
          orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
          orderStatusIcon = Icons.shopping_cart;
          handleMethod = defaultMethod;
          isTableSelected = false;
        } else {
          // If the table is already occupied, retrieve the list of occupied tables
          var occupiedTables = tablesData.where((table) => table['occupied'] == true).toList();
          log('Occupied Tables are : $occupiedTables');
          isTableSelected = true;
          // Retrieve the current table's order number and use it to locate the existing order
          var orderNumber = currentTable['orderNumber'].toString();
          final ordersNotifier = ref.read(ordersProvider.notifier);
          var order = ordersNotifier.getOrder(orderNumber);

          // If an existing order is found with the same order number
          if (order != null) {
            order.showEditBtn = true;
            // Log the selectedOrder data and the found order
            log('selectedOrder data and time are: ${selectedOrderProvider}');
            log('Order Found is: $order');
            // Set the found order as the current order instance in the provider
            selectedOrderNotifier.setNewOrderInstance(order);
            // Clone the existing order's items into tempCartItems, preserving item remarks
            tempCartItems = order.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
            // Recalculate quantities or other item properties if necessary
            selectedOrderNotifier.calculateItemsAndQuantities();
          } else {
            log('Order not found for order number: $orderNumber');
          }
        }
      });
    } catch (e, stack) {
      // Log any errors that occur within the try block, along with the stack trace for debugging
      log('Error in _handleSetTables: $e\n$stack');
    }
    updateOrderStatus();
  }

  void onItemAdded(Item item) {
    setState(() {
      // Try to find an item in selectedOrder.items with the same id as the new item
      addItemtoCart(item);
      _showCherryToast(
        'check_circle', // Pass the icon key as a string
        '${item.name} (RM ${item.price.toStringAsFixed(2)})', // Interpolated title text
        1500, // Toast duration in milliseconds
        200, // Animation duration in milliseconds
      );
    });
  }

  IconData _getIconData(String iconText) {
    const iconMap = {'check_circle': Icons.check_circle, 'info': Icons.info, 'cancel': Icons.cancel};

    return iconMap[iconText] ?? Icons.info; // Default to 'help' if not found
  }

  void _showCherryToast(
    String iconText,
    String titleText,
    int toastDu, // Changed to int for duration
    int animateDu,
  ) {
    CherryToast(
      icon: _getIconData(iconText), // Retrieve the corresponding icon
      iconColor: Colors.green,
      themeColor: const Color.fromRGBO(46, 125, 50, 1),
      backgroundColor: Colors.white,
      title: Text(
        titleText,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      toastPosition: Position.top,
      toastDuration: Duration(milliseconds: toastDu), // Use the passed duration
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: animateDu), // Use the passed animation duration
      autoDismiss: true,
      displayCloseButton: false,
    ).show(context);
  }

  void addItemtoCart(item) {
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    // Add the item and update the total cost
    selectedOrderNotifier.addItem(item);
    selectedOrderNotifier.updateTotalCost();
    // Access the current state of selectedOrder
    final selectedOrder = ref.read(selectedOrderProvider);
    if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == false && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
      handleMethod = handleUpdateOrderBtn;
    }
    updateOrderStatus();
  }

  void resetSelectedTable(WidgetRef ref) {
    var resetOrderNumber = "";
    // Check if the selected table index is valid
    if (selectedTableIndex != -1 && selectedTableIndex < tables.length) {
      // Reset the table's orderNumber and occupied status in the provider
      ref.read(tablesProvider.notifier).updateSelectedTable(selectedTableIndex, resetOrderNumber, false);

      log('Table ${tables[selectedTableIndex]['name']} has been reset.');
    } else {
      log('Invalid table index, reset failed.');
    }
  }

  bool areItemListsEqual(List<Item> list1, List<Item> list2) {
    // If the lengths of the lists are not equal, the lists are not equal
    if (list1.length != list2.length) {
      log('Lists are not equal: Different lengths');
      return false;
    }
    // Create new lists that are sorted copies of the original lists
    List<Item> sortedList1 = List.from(list1)..sort((a, b) => a.name.compareTo(b.name));
    List<Item> sortedList2 = List.from(list2)..sort((a, b) => a.name.compareTo(b.name));
    // Compare the items in the sorted lists
    for (int i = 0; i < sortedList1.length; i++) {
      log('Comparing items: ${sortedList1[i].name}, Tapao in list1: ${sortedList1[i].tapao}, Tapao in list2: ${sortedList2[i].tapao}');
      Map<String, dynamic> remarks1 = sortedList1[i].itemRemarks ?? {};
      Map<String, dynamic> remarks2 = sortedList2[i].itemRemarks ?? {};

      if (sortedList1[i].name != sortedList2[i].name ||
          sortedList1[i].quantity != sortedList2[i].quantity ||
          sortedList1[i].tapao != sortedList2[i].tapao ||
          !const MapEquality().equals(remarks1, remarks2) ||
          !const MapEquality().equals(sortedList1[i].selectedDrink, sortedList2[i].selectedDrink) ||
          !const MapEquality().equals(sortedList1[i].selectedTemp, sortedList2[i].selectedTemp) ||
          !const SetEquality<Map<String, dynamic>>(MapEquality()).equals(sortedList1[i].selectedNoodlesType, sortedList2[i].selectedNoodlesType) ||
          !const MapEquality().equals(sortedList1[i].selectedChoice, sortedList2[i].selectedChoice) ||
          !const MapEquality().equals(sortedList1[i].selectedMeePortion, sortedList2[i].selectedMeePortion) ||
          !const MapEquality().equals(sortedList1[i].selectedMeatPortion, sortedList2[i].selectedMeatPortion) ||
          !const SetEquality<Map<String, dynamic>>(MapEquality()).equals(sortedList1[i].selectedSide, sortedList2[i].selectedSide)) {
        log('Lists are not equal: Item difference found');
        return false;
      }
    }
    // If no differences were found, the lists are equal
    log('Lists are equal');
    return true;
  }

  void _handleCloseMenu() {
    final selectedOrder = ref.read(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    // log('_handleCloseMenu called');
    // log('selectedOrder.status before: ${selectedOrder.status}');
    // log('selectedOrder.items before: ${selectedOrder.items}');
    // log('tempCartItems before: $tempCartItems');
    if (selectedOrder.status == "Ordering" && selectedOrder.items.isEmpty) {
      setState(() {
        resetSelectedTable(ref);
        selectedOrderNotifier.resetDefault();
        updateOrderStatus();
        handlefreezeMenu();
      });
    } else if (selectedOrder.status == "Ordering" && selectedOrder.items.isNotEmpty) {
      _showConfirmationCancelDialog();
    } else if (selectedOrder.status == "Placed Order" && areItemListsEqual(tempCartItems, selectedOrder.items)) {
      handlefreezeMenu();
      selectedOrderNotifier.updateShowEditBtn(true);
      orderStatus = "Make Payment";
      orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
      orderStatusIcon = Icons.monetization_on;
      handleMethod = () {
        handlePaymentBtn(context, ref);
      };
    } else if (selectedOrder.status == "Placed Order" && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      _showConfirmationCancelDialog();
    }
    // log('selectedOrder.status after: ${selectedOrder.status}');
    // log('selectedOrder.items after: ${selectedOrder.items}');
    // log('tempCartItems after: $tempCartItems');
  }

  void handleCancelBtn() {
    final selectedOrder = ref.read(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    final currentOrderCounter = ref.read(orderCounterProvider);
    log('handel Cancel: $currentOrderCounter');
    // yes to cancel orders or cancel changes
    if (selectedOrder.status == "Ordering") {
      setState(() {
        // reset selected table and the selected order
        resetSelectedTable(ref);
        selectedOrderNotifier.resetDefault();
      });
    } else if (selectedOrder.status == "Placed Order" && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      setState(() {
        final currentCounterValue = ref.read(orderCounterProvider); // gives the current state value
        log('Order Counter when status is Placed Order but cancel update: $currentCounterValue');

        selectedOrderNotifier.updateShowEditBtn(true);
        // Use the new method to update items safely
        selectedOrderNotifier.updateItemsFromTempCart(tempCartItems);
      });
    } else if (selectedOrder.status == "Placed Order") {
      setState(() {
        selectedOrderNotifier.updateShowEditBtn(true);
      });
    }
    handlefreezeMenu();
    updateOrderStatus();
  }

  void handlefreezeMenu() {
    widget.freezeSideMenu();
    showMenu = !showMenu;
  }

  // void printOrders() async {
  //   try {
  //     if (Hive.isBoxOpen('orders')) {
  //       var ordersBox = Hive.box('orders');
  //       var orders = ordersBox.get('orders');
  //       // log('Orders: $orders');
  //     }
  //   } catch (e) {
  //     log('An error occurred at DineIn Page void printOrders: $e');
  //   }
  // }

  void handlePlaceOrderBtn() {
    _showComfirmPlaceOrdersDialog();
  }

  void handleUpdateOrderBtn() {
    final selectedOrder = ref.read(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    try {
      setState(() {
        // Use SelectedOrderNotifier to update status, items, and showEditBtn
        selectedOrderNotifier.placeOrder(selectedOrder.orderNumber, selectedOrder.tableName);
        tempCartItems = ref.read(selectedOrderProvider).items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
        // Add or update order in OrdersNotifier
        ref.read(ordersProvider.notifier).addOrUpdateOrder(ref.read(selectedOrderProvider).copyWith());
        updateOrderStatus();
        handlefreezeMenu();
      });
    } catch (e) {
      log('An error occurred in handleUpdateOrderBtn: $e');
    }
  }

  void handlePaymentBtn(BuildContext context, WidgetRef ref) {
    // // Use the provider to access the current orders state
    // final orders = ref.read(ordersProvider);

    // // Log the selectedOrder with pretty-printed JSON
    // var encoder = const JsonEncoder.withIndent('  ');
    // log('The Selected Order Details in Payment Page is:\n${encoder.convert(selectedOrder.toJson())}');

    // // Log the current orders state (via Riverpod, instead of direct Hive access)
    // log('Stored orders from provider: ${orders.getAllOrders()}');

    // Navigate to the payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakePaymentPage(
          updateOrderStatus: updateOrderStatus,
          tables: tables,
          selectedTableIndex: selectedTableIndex,
          isTableInitiallySelected: isTableSelected,
        ),
      ),
    );
  }

  void handlePrintItems(BuildContext context, WidgetRef ref) {
    final selectedOrder = ref.read(selectedOrderProvider);
    // Navigate to the Print Items page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintItemsPage(
          selectedOrder: selectedOrder,
          updateOrderStatus: updateOrderStatus,
          tables: tables,
          selectedTableIndex: selectedTableIndex,
          isTableInitiallySelected: isTableSelected,
        ),
      ),
    );
  }

  VoidCallback? handleMethod;
  void defaultMethod() {
    log('handleMethod is disabled');
    // did nothing But explained here
    // when Dart creates a new object, it first initializes all the instance variables before it runs the constructor. Therefore, instance methods aren’t available yet.
    // handleMethod is initialized in the initState method, which is called exactly once and then never again for each State object. It’s the first method called after a State object is created, and it’s called before the build method
  }

  Future<void> _showConfirmationCancelDialog() async {
    final selectedOrder = ref.read(selectedOrderProvider);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // change radius here
            side: const BorderSide(color: Colors.deepOrange, width: 1), // change border color here
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
              maxHeight: 80,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Are you sure?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      selectedOrder.status == "Placed Order" ? "Do you want to cancel changes?" : "Do you want to cancel order?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  handleCancelBtn();
                  Navigator.of(context).pop();
                }),
            const SizedBox(width: 2),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
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

  Future<void> _showComfirmPlaceOrdersDialog() async {
    final selectedOrder = ref.read(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    final tables = ref.read(tablesProvider);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // change radius here
            side: const BorderSide(color: Colors.green, width: 1), // change border color here
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 100,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'We’re about to proceed with printing.',
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Please confirm all items are correct',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'before proceed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                // Show CherryToast before any navigation or other tasks
                if (selectedTableIndex >= 0 && selectedTableIndex < tables.length) {
                  _showCherryToast(
                    'info', // Pass the icon key as a string
                    'Please press `Table ${tables[selectedTableIndex]['name']}` for printing.',
                    2000, // Toast duration in milliseconds
                    1500, // Animation duration in milliseconds
                  );
                } else {
                  log('Invalid selectedTableIndex: $selectedTableIndex or tables list is empty.');
                  // Handle the invalid state (e.g., show a default message or an error)
                  _showCherryToast(
                    'error',
                    'No table selected or table list is empty.',
                    2000,
                    1500,
                  );
                }

                try {
                  // Step 1: Fetch updated tables data
                  final updatedTables = ref.read(tablesProvider);

                  // Check if the current table already has an order number
                  final currentOrderNumber = updatedTables[selectedTableIndex]['orderNumber'];
                  if (currentOrderNumber == null || currentOrderNumber.isEmpty) {
                    // Generate a new order number if it doesn't exist
                    orderNumber = generateID(updatedTables[selectedTableIndex]['name'], ref);
                    log('Generated orderNumber: $orderNumber');

                    // Update the table provider and Hive with the new order number
                    ref.read(tablesProvider.notifier).updateSelectedTable(selectedTableIndex, orderNumber, true);
                  } else {
                    // Use the existing order number from the provider
                    orderNumber = currentOrderNumber;
                  }

                  // Step 2: Place the order with the updated order number
                  await selectedOrderNotifier.placeOrder(orderNumber, tables[selectedTableIndex]['name']);

                  // Log and prepare the updated selected order
                  final updatedSelectedOrder = ref.read(selectedOrderProvider); // Read the updated state
                  log('Updated selectedOrder after placeOrder: $updatedSelectedOrder');

                  // Step 3: Add or update the order in ordersProvider
                  ref.read(ordersProvider.notifier).addOrUpdateOrder(updatedSelectedOrder);

                  // Store the current items in the temporary cart
                  tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
                  // Check if the selectedOrder's orderNumber exists in the orders list and log it if found.
                  // final matchingOrder = ref.read(ordersProvider.notifier).getOrder(selectedOrder.orderNumber);
                  // if (matchingOrder != null) {
                  //   log('Matching orderNumber found: ${matchingOrder.orderNumber}');
                  // } else {
                  //   log('No matching order found.');
                  // }
                  // Update UI state in a separate setState call
                  setState(() {
                    isTableSelected = true;
                  });

                  // Additional UI updates
                  updateOrderStatus();
                  handlefreezeMenu();

                  // Close the dialog after a delay
                  Navigator.of(context).pop();
                } catch (e) {
                  log('An error occurred while placing order & printing: $e');
                }
              },
            ),
            const SizedBox(width: 2),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.green,
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
    final selectedOrder = ref.read(selectedOrderProvider);
    setState(() {
      if (selectedOrder.status == "Start Your Order") {
        orderStatus = "Empty Cart";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
        handleMethod = defaultMethod; // Disabled
        orderStatusIcon = Icons.shopping_cart;
      } else if (selectedOrder.status == "Ordering" && selectedOrder.items.isNotEmpty) {
        orderStatus = "Place Order";
        orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = handlePlaceOrderBtn;
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == false) {
        orderStatus = "Update Orders";
        orderStatusColor = areItemListsEqual(tempCartItems, selectedOrder.items) ? const Color.fromRGBO(97, 97, 97, 1) : const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = areItemListsEqual(tempCartItems, selectedOrder.items) ? defaultMethod : handlePlaceOrderBtn; // Disabled
        orderStatusIcon = Icons.print;
      } else if (selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == true) {
        orderStatus = "Make Payment";
        orderStatusColor = const Color.fromRGBO(46, 125, 50, 1);
        handleMethod = () {
          handlePaymentBtn(context, ref);
        };
        orderStatusIcon = Icons.monetization_on;
      } else if (selectedOrder.status == "Paid") {
        orderStatus = "COMPLETED (PAID)";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
        handleMethod = defaultMethod;
        orderStatusIcon = Icons.check_circle;
      } else if (selectedOrder.status == "Cancelled") {
        orderStatus = "Cancelled";
        orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
        orderStatusIcon = Icons.cancel;
        handleMethod = defaultMethod; // Disabled
      }
    });
  }

  Widget buildPrintButton(String label, String area, BuildContext context, WidgetRef ref) {
    final selectedOrder = ref.read(selectedOrderProvider);
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        handlePrintingJobs(context, ref, selectedOrder: selectedOrder, specificArea: area);
        _showCherryToast(
          'info', // Pass the icon key as a string
          'Printing ${selectedOrder.orderNumber} is in the process',
          2000, // Toast duration in milliseconds
          1000, // Animation duration in milliseconds
        );
        Navigator.of(context).pop();
      },
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.watch() to listen to tablesProvider for changes
    final tables = ref.watch(tablesProvider);
    log('The tables from widget build are :$tables');
    // Future need to display the price of each table
    // final totalOrdersPrice = ref.watch(ordersProvider.notifier).totalOrdersPrice;

    // final groupedOrders = ref.watch(ordersProvider.notifier).ordersGroupedByDate;

    // for (var date in groupedOrders.keys) {
    //   log('Orders for $date:');
    //   for (var order in groupedOrders[date]!) {
    //     log(order.toString());
    //   }
    // }
    final selectedOrder = ref.watch(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);
    // Display a loading indicator if data is still being fetched
    if (isLoading && tables.isEmpty) {
      // log('Show info: $tables');
      return const Center(child: CircularProgressIndicator());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showMenu == false
            ? Expanded(
                flex: 12,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
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
                            // Get the matching order for the current table
                            // final matchingOrder = ref.read(ordersProvider.notifier).getOrder(tables[index]['orderNumber']);

                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pressedButtonIndex = index;

                                  // log('Before updating tables: ${tables.where((table) => table['occupied'] == true).toList()}');
                                  // log('Table Name is: ${tables[index]['name']}');

                                  // final tablesData = ref.read(tablesProvider);
                                  // log('Provider tables data before update: $tablesData');

                                  _handleSetTables(tables[index]['name'], index);

                                  // log('After updating tables: ${tables.where((table) => table['occupied'] == true).toList()}');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: pressedButtonIndex == index ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
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
                                        '${tables[index]['name']}',
                                        style: TextStyle(
                                            fontSize: pressedButtonIndex == index ? 14 : 12,
                                            fontWeight: FontWeight.bold,
                                            color: pressedButtonIndex == index ? Colors.white : Colors.black),
                                      ),
                                      if (tables[index]['occupied'])
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Add space around the text
                                          decoration: BoxDecoration(
                                            color: pressedButtonIndex == index ? Colors.white : Colors.green,
                                            borderRadius: BorderRadius.circular(5.0), // Rounded corners (optional)
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                // Show Seated
                                                'SEATED',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: pressedButtonIndex == index ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
                                                ),
                                              ),
                                              // Text(
                                              //   // Show matchingOrder's totalPrice if found, otherwise fallback to selectedOrder's totalPrice
                                              //   'RM ${(matchingOrder != null ? matchingOrder.totalPrice : selectedOrder.totalPrice).toStringAsFixed(2)}',
                                              //   style: TextStyle(
                                              //     fontSize: 10,
                                              //     fontWeight: FontWeight.bold,
                                              //     color: pressedButtonIndex == index ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  //
                                  // if (tables[index]['occupied'])
                                  //   Icon(
                                  //     Icons.dining,
                                  //     color: pressedButtonIndex == index ? Colors.white : const Color.fromRGBO(46, 125, 50, 1),
                                  //     size: pressedButtonIndex == index ? 32 : 24,
                                  //   ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Collect Money
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 1,
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xff1f2029), // Background color
                      //           border: Border.all(
                      //             color: Colors.white10,
                      //           ), // Border color and width
                      //           borderRadius: BorderRadius.circular(5), // Optional rounded corners
                      //         ),
                      //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             // const Icon(Icons.monetization_on_rounded, size: 20, color: Colors.green),
                      //             // const SizedBox(width: 8),
                      //             Text(
                      //               'To Collect RM ${totalOrdersPrice.toStringAsFixed(2)}',
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 // fontWeight: FontWeight.bold,
                      //                 color: Colors.white, // Text color to match border or your preferred color
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      if (isTableSelected) const SizedBox(height: 16),
                      Row(
                        children: [
                          // Clear Local Data
                          isTableSelected
                              ? Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        final categoriesBox = Hive.isBoxOpen('categories') ? Hive.box('categories') : await Hive.openBox('categories');
                                        // final printersBox =
                                        //     Hive.isBoxOpen('printersBox') ? Hive.box<Printer>('printersBox') : await Hive.openBox<Printer>('printersBox');

                                        // Step 1: Reset providers
                                        await ref.read(tablesProvider.notifier).resetTables();
                                        await ref.read(orderCounterProvider.notifier).resetOrderCounter(); // Reset orderCounter to 1
                                        await ref.read(ordersProvider.notifier).clearOrders(); // Clears both state and ordersBox
                                        log('Providers have been reset.');

                                        // Step 2: Clear Hive boxes
                                        await categoriesBox.clear();
                                        // await printersBox.clear();
                                        log('Hive boxes have been cleared.');

                                        // Step 3: Update UI after clearing and resetting
                                        setState(() {
                                          selectedOrderNotifier.resetDefault();
                                        });

                                        log('UI has been updated after resetting the data.');
                                      } catch (e) {
                                        log('An error occurred while clearing Hive data: $e');
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cancel, size: 20),
                                          SizedBox(width: 10),
                                          Text(
                                            'Clear',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(width: 10),
                          // Cancel and Remove and Delete Selected Order
                          (isTableSelected && selectedOrder.status == "Placed Order" && selectedOrder.showEditBtn == true)
                              ? Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: const BorderSide(color: Colors.green, width: 1),
                                            ),
                                            content: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 300,
                                                maxHeight: 90,
                                              ),
                                              child: const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Wrap(
                                                    alignment: WrapAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Are you sure?',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        'Please note, once cancelled,',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        'the action is irreversible.',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0, left: 40, right: 40),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 2, 12, 2)),
                                                      ),
                                                      onPressed: () {
                                                        resetSelectedTable(ref);

                                                        // Cancel the order through ordersProvider
                                                        ref.read(ordersProvider.notifier).cancelOrder(selectedOrder.orderNumber);

                                                        log('Order from order details page cancelled: ${selectedOrder.orderNumber}');

                                                        setState(() {
                                                          selectedOrderNotifier.handleCancelOrder();
                                                          updateOrderStatus();
                                                        });
                                                        _showCherryToast(
                                                          'cancel',
                                                          'The order has being cancelled!',
                                                          2000, // Toast duration in milliseconds
                                                          200, // Animation duration in milliseconds
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 2, 12, 2)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete_forever, size: 22),
                                          SizedBox(width: 8),
                                          Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(width: 10),
                          isTableSelected
                              ? Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      handlePrintItems(context, ref);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromRGBO(46, 125, 50, 1),
                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.print_rounded, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Print',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          // buildPrintButton('Cashier', 'Cashier', context, ref),
                          // const SizedBox(width: 2),
                          // buildPrintButton('Kitchen', 'Kitchen', context, ref),
                          // const SizedBox(width: 2),
                          // buildPrintButton('Beverage', 'Beverage', context, ref),
                          // const SizedBox(width: 2),
                          // buildCancelButton(context),
                        ],
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
            resetSelectedTable: () => resetSelectedTable(ref),
            tempCartItems: tempCartItems,
            areItemListsEqual: areItemListsEqual,
          ),
        ),
      ],
    );
  }
}

class HiveBoxes {
  static Box<Orders>? _ordersBox;

  static Future<Box<Orders>> getOrdersBox() async {
    if (_ordersBox != null && _ordersBox!.isOpen) {
      return _ordersBox!;
    }
    _ordersBox = await Hive.openBox<Orders>('orders');
    return _ordersBox!;
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
