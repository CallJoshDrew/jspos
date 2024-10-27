import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/print_jobs.dart';
import 'package:jspos/providers/orders_provider.dart';
import 'package:jspos/providers/tables_provider.dart';
import 'package:jspos/providers/order_counter_provider.dart';
import 'package:jspos/screens/menu/menu.dart';
import 'package:jspos/shared/order_details.dart';
import 'package:jspos/shared/make_payment.dart';
import 'package:jspos/data/menu1_data.dart';
// import 'package:jspos/data/menu_data.dart';
import 'dart:developer';
import 'package:jspos/data/tables_data.dart';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:jspos/shared/printItems.dart';

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
  List<Map<String, dynamic>> tables = [];

  late Orders orders;
  late int orderCounter;
  bool isLoading = true; // Track loading state
  @override
  void initState() {
    super.initState();
    // Access orders provider in initState, but leave tables to the build method
    orders = ref.read(ordersProvider);
    log('Initial Orders: ${orders.getAllOrders()}');
    loadData();
    handleMethod = defaultMethod;
  }

  // Unified function to load tables and order counter
  Future<void> loadData() async {
    try {
      // Load the data for tables from Hive or API
      final tablesData = ref.read(tablesProvider);
      final orderCounterData = ref.read(orderCounterProvider);

      // Once the data is fetched, update state
      setState(() {
        tables = tablesData;
        orderCounter = orderCounterData;
        isLoading = false; // Data loaded, stop the loading spinner
      });

      log('Loaded tables: $tables');

      log('Loaded orderCounter: $orderCounter');
    } catch (e) {
      log('Error loading tables: $e');
      setState(() {
        isLoading = false; // Stop loading in case of an error as well
      });
    }
  }
  // Unified function to load tables and order counter

  bool isTableSelected = false;

  bool showMenu = false;

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
  String generateID(String tableName, WidgetRef ref) {
    // Access the current orderCounter from the provider
    final currentOrderCounter = ref.read(orderCounterProvider);

    // Properly format the counter with 4 digits (0001, 0002, etc.)
    final paddedCounter = currentOrderCounter.toString().padLeft(4, '0');

    // Remove any whitespace in the table name
    final tableNameWithoutSpace = tableName.replaceAll(RegExp(r'\s+'), '');

    // Construct the order number correctly
    final orderNumber = '#Table$tableNameWithoutSpace-$paddedCounter';

    // Increment the counter
    final updatedOrderCounter = currentOrderCounter + 1;

    // Update the orderCounter in the provider and then save it to Hive
    ref.read(orderCounterProvider.notifier).updateOrderCounter(updatedOrderCounter);

    // Log the generated order number for debugging
    log('Generated order number: $orderNumber');
    log('Updated orderCounter to: $updatedOrderCounter');

    return orderNumber;
  }

  // void printTables() {
  //   // Get the 'tables' box
  //   var tablesBox = Hive.box('tables');

  //   List<Map<String, dynamic>> tables = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();

  //   // Print the tables list to the console
  //   log('Tables: $tables');
  // }

  void updateTables(int index, String orderNumber, bool isOccupied) async {
    try {
      // Step 1: Update the 'tables' box in Hive
      var tablesBox = Hive.box('tables');
      var rawTables = tablesBox.get('tables');

      if (rawTables != null) {
        List<Map<String, dynamic>> tables = (rawTables as List).map((item) => Map<String, dynamic>.from(item)).toList();

        // Update the table data in Hive
        tables[index]['orderNumber'] = orderNumber;
        tables[index]['occupied'] = isOccupied;
        tablesBox.put('tables', tables);
        log('DINEIN Page: Updated tables in Hive.');
      } else {
        log('DINEIN Page: Tables data is null in Hive.');
      }

      // Step 2: Update the provider state
      ref.read(tablesProvider.notifier).updateSelectedTable(index, orderNumber, isOccupied);
      log('DINEIN Page: Updated tables in Provider.');
    } catch (e) {
      log('DINEIN Page: Failed to update tables: $e');
      // Handle the exception as appropriate for your app
    }
  }

  int pressedButtonIndex = -1;
  // Open Menu after set table number
  // Update in _handleSetTables function when a new order is created
  void _handleSetTables(String tableName, int index) {
    log('Entering _handleSetTables with table: $tableName, index: $index');
    try {
      setState(() {
        // Set the selected table and its index
        // log('The table is table $tableName at index $index');
        // Filter and log only the tables that are occupied
        // log('tables from DINE IN now is $tables');
        final tablesData = ref.read(tablesProvider);
        // var occupiedTables = tablesData.where((table) => table['occupied'] == true).toList();
        var currentTable = tablesData[index];
        log('Current table data: $currentTable');

        selectedTableIndex = index;

        log('Selected index: $index');

        // If the table is not occupied, generate a new orderNumber
        if (!currentTable['occupied']) {
          log('Occupied field type: ${currentTable['occupied'].runtimeType}');
          bool isOccupied = currentTable['occupied'] == true;
          if (!isOccupied) {
            log('Table is not occupied, creating new order.');
          }
          handlefreezeMenu();
          // Generate a new instance of selectedOrder first, and then only assign it's fields and details to the selectedOrder
          selectedOrder = selectedOrder.newInstance(categories);
          selectedOrder.updateStatus("Ordering");
          tempCartItems = [];
          // below these are important updates for the UI, have to manually update it to cause rerender in orderDetails page.
          orderStatus = "Empty Cart";
          orderStatusColor = const Color.fromRGBO(97, 97, 97, 1);
          orderStatusIcon = Icons.shopping_cart;
          handleMethod = defaultMethod;
          isTableSelected = false;
        } else {
          isTableSelected = true;
          // If the table is occupied, use the existing orderNumber
          var orderNumber = currentTable['orderNumber'].toString();
          var order = orders.getOrder(orderNumber);

          log('The selected Order Number is: $orderNumber');
          // log('Exisiting order number is $orderNumber');
          // log('Current orders: ${orders.getAllOrders}');
          // If an order with the same orderNumber exists, update selectedOrder with its details
          if (order != null) {
            log('Order Found is: $orderNumber');
            order.showEditBtn = true;
            selectedOrder = order;
            tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
            selectedOrder.calculateItemsAndQuantities();
            log('The selected Order is: $selectedOrder');
            // _showCherryToast(
            //   'info', // Pass the icon key as a string
            //   'You have selected TABLE ${tables[index]['name']}.', // Interpolated title text
            //   1000, // Toast duration in milliseconds
            //   200, // Animation duration in milliseconds
            // );
          } else {
            log('Order not found for order number: $orderNumber');
          }
        }
      });
    } catch (e, stack) {
      log('Error in _handleSetTables: $e\n$stack');
    }
    // printTables();
    // saveSelectedOrderToHive();
    updateOrderStatus();
  }

  // // log Hive for selectedOrder
  // void logSelectedOrders() async {
  //   try {
  //     if (Hive.isBoxOpen('tables')) {
  //       var selectedOrderBox = await Hive.openBox('selectedOrder');
  //       var selectedOrder = selectedOrderBox.get('selectedOrder');
  //       log('selectedOrder: $selectedOrder');
  //     }
  //   } catch (e) {
  //     log('An error occurred at DineIn Page void logSelectedOrders: $e');
  //   }
  // }

  // void saveSelectedOrderToHive() async {
  //   try {
  //     if (Hive.isBoxOpen('tables')) {
  //       var selectedOrderBox = Hive.box('selectedOrder');
  //       await selectedOrderBox.put('selectedOrder', selectedOrder);
  //       // logSelectedOrders();
  //     }
  //   } catch (e) {
  //     log('DineIn Page: Failed to save selectedOrder to Hive: $e');
  //   }
  // }

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
    selectedOrder.addItem(item);
    selectedOrder.updateTotalCost(0);
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

      // Optionally, save the updated tables state to Hive (not needed if updateTable handles it)
      // ref.read(tablesProvider.notifier).updateTables(tables);

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
      Map<String, dynamic> remarks1 = sortedList1[i].itemRemarks ?? {};
      Map<String, dynamic> remarks2 = sortedList2[i].itemRemarks ?? {};

      if (sortedList1[i].name != sortedList2[i].name ||
          sortedList1[i].quantity != sortedList2[i].quantity ||
          !const MapEquality().equals(remarks1, remarks2) ||
          !const MapEquality().equals(sortedList1[i].selectedDrink, sortedList2[i].selectedDrink) ||
          !const MapEquality().equals(sortedList1[i].selectedTemp, sortedList2[i].selectedTemp) ||
          !const MapEquality().equals(sortedList1[i].selectedNoodlesType, sortedList2[i].selectedNoodlesType) ||
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
    // log('_handleCloseMenu called');
    // log('selectedOrder.status before: ${selectedOrder.status}');
    // log('selectedOrder.items before: ${selectedOrder.items}');
    // log('tempCartItems before: $tempCartItems');
    if (selectedOrder.status == "Ordering" && selectedOrder.items.isEmpty) {
      setState(() {
        resetSelectedTable(ref);
        selectedOrder.resetDefault();
        updateOrderStatus();
        handlefreezeMenu();
      });
    } else if (selectedOrder.status == "Ordering" && selectedOrder.items.isNotEmpty) {
      _showConfirmationCancelDialog();
    } else if (selectedOrder.status == "Placed Order" && areItemListsEqual(tempCartItems, selectedOrder.items)) {
      handlefreezeMenu();
      selectedOrder.updateShowEditBtn(true);
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
    // log('handleCancelBtn called');
    // log('selectedOrder.status before: ${selectedOrder.status}');
    // log('selectedOrder.items before: ${selectedOrder.items}');
    // log('tempCartItems before: $tempCartItems');
    final currentOrderCounter = ref.read(orderCounterProvider);
    // log('selectedOrder.items before copyWith: ${selectedOrder.items}');
    log('handel Cancel: $currentOrderCounter');
    // yes to cancel orders or cancel changes
    if (selectedOrder.status == "Ordering") {
      setState(() {
        // reset selected table and the selected order
        resetSelectedTable(ref);
        selectedOrder.resetDefault();
      });
      // log('Reset selected table and order. New selectedOrder status: ${selectedOrder.status}');
    } else if (selectedOrder.status == "Placed Order" && !areItemListsEqual(tempCartItems, selectedOrder.items)) {
      setState(() {
        final currentCounterValue = ref.read(orderCounterProvider); // gives the current state value
        log('Order Counter when status is Placed Order but cancel update: $currentCounterValue');

        selectedOrder.updateShowEditBtn(true);
        selectedOrder.items = tempCartItems.map((item) => item.copyWith()).toList();
      });
    } else if (selectedOrder.status == "Placed Order") {
      setState(() {
        selectedOrder.updateShowEditBtn(true);
      });
      // log('Menu closed. Current selectedOrder status: ${selectedOrder.status}');
    }
    log('selectedOrder.items after copyWith: ${selectedOrder.items}');
    log('tempCartItems copyWith: $tempCartItems');
    handlefreezeMenu();
    updateOrderStatus();
  }

  void handlefreezeMenu() {
    widget.freezeSideMenu();
    showMenu = !showMenu;
  }

  void printOrders() async {
    try {
      if (Hive.isBoxOpen('orders')) {
        var ordersBox = Hive.box('orders');
        var orders = ordersBox.get('orders');
        log('Orders: $orders');
      }
    } catch (e) {
      log('An error occurred at DineIn Page void printOrders: $e');
    }
  }

  void handlePlaceOrderBtn() {
    _showComfirmPlaceOrdersDialog();
  }

  void handleUpdateOrderBtn() {
    try {
      setState(() {
        selectedOrder.placeOrder();
        tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();
        // Add a new SelectedOrder object to the orders list
        orders.addOrUpdateOrder(selectedOrder.copyWith()); // this already include saving to hive
        updateOrderStatus();
        handlefreezeMenu();
      });
    } catch (e) {
      log('An error occurred in handleUpdateOrderBtn: $e');
    }
  }

  void handlePaymentBtn(BuildContext context, WidgetRef ref) {
    // Use the provider to access the current orders state
    final orders = ref.read(ordersProvider);

    // Log the selectedOrder with pretty-printed JSON
    var encoder = const JsonEncoder.withIndent('  ');
    log('The Selected Order Details in Payment Page is:\n${encoder.convert(selectedOrder.toJson())}');

    // Log the current orders state (via Riverpod, instead of direct Hive access)
    log('Stored orders from provider: ${orders.getAllOrders()}');

    // Navigate to the payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakePaymentPage(
          selectedOrder: selectedOrder,
          updateOrderStatus: updateOrderStatus,
          tables: tables,
          selectedTableIndex: selectedTableIndex,
          updateTables: updateTables,
          isTableInitiallySelected: isTableSelected,
        ),
      ),
    );
  }

  void handlePrintItems(BuildContext context, WidgetRef ref) {
    // Use the provider to access the current orders state
    final orders = ref.read(ordersProvider);

    // Log the selectedOrder with pretty-printed JSON
    var encoder = const JsonEncoder.withIndent('  ');
    log('The Selected Order Details in Payment Page is:\n${encoder.convert(selectedOrder.toJson())}');

    // Log the current orders state (via Riverpod, instead of direct Hive access)
    log('Stored orders from provider: ${orders.getAllOrders()}');

    // Navigate to the payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintItemsPage(
          selectedOrder: selectedOrder,
          updateOrderStatus: updateOrderStatus,
          tables: tables,
          selectedTableIndex: selectedTableIndex,
          updateTables: updateTables,
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
                log('$selectedTableIndex');
                _showCherryToast(
                  'info', // Pass the icon key as a string
                  'Please press `Table ${tables[selectedTableIndex]['name']}` for printing.',
                  2000, // Toast duration in milliseconds
                  1500, // Animation duration in milliseconds
                );

                // log('Table is table ${tables[selectedTableIndex]['name']}');

                try {
                  // Place the order and update UI state inside setState.
                  setState(() {
                    log('Tables data: $tables');
                    log('Selected table index: $selectedTableIndex');
                    final updatedTables = ref.read(tablesProvider);
                    log('Updated tables: $updatedTables');
                    log('Selected table: ${updatedTables[selectedTableIndex]}');

                    // Step 1: Check if the current table already has an order number from the provider.
                    final currentOrderNumber = updatedTables[selectedTableIndex]['orderNumber'];
                    // log('Current orderNumber: ${tables[selectedTableIndex]['orderNumber']}');
                    // log('Current orderNumber: $currentOrderNumber');

                    if (currentOrderNumber == null || currentOrderNumber.isEmpty) {
                      // Step 2: Generate a new order number if it doesn't exist.
                      orderNumber = generateID(updatedTables[selectedTableIndex]['name'], ref);
                      log('Generated orderNumber: $orderNumber');

                      // Update the table provider and Hive with the new order number.
                      updateTables(selectedTableIndex, orderNumber, true);
                    } else {
                      // Use the existing order number from the provider.
                      orderNumber = currentOrderNumber;
                      log('Using existing orderNumber: $orderNumber');
                    }

                    // Step 3: Update the selected order details with the correct order number.
                    selectedOrder.orderNumber = orderNumber;
                    selectedOrder.tableName = tables[selectedTableIndex]['name'];
                    selectedOrder.placeOrder();

                    // Store the current items in the temporary cart.
                    tempCartItems = selectedOrder.items.map((item) => item.copyWith(itemRemarks: item.itemRemarks)).toList();

                    // Add or update the order in the orders list.
                    orders.addOrUpdateOrder(selectedOrder.copyWith());
                    log('Order added: ${selectedOrder.orderNumber}');
                  });

                  isTableSelected = true;

                  // Update UI elements and order status
                  updateOrderStatus();
                  handlefreezeMenu();

                  // Close the dialog after a delay to allow toast display
                  Navigator.of(context).pop();
                  await Future.delayed(const Duration(seconds: 10));
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
    // Display a loading indicator if data is still being fetched
    if (isLoading) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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

                                  log('Before updating tables: ${tables.where((table) => table['occupied'] == true).toList()}');
                                  log('Table Name is: ${tables[index]['name']}');

                                  final tablesData = ref.read(tablesProvider);
                                  log('Provider tables data before update: $tablesData');

                                  _handleSetTables(tables[index]['name'], index);

                                  log('After updating tables: ${tables.where((table) => table['occupied'] == true).toList()}');
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
                                        'Table ${tables[index]['name']}',
                                        style: TextStyle(
                                            fontSize: pressedButtonIndex == index ? 16 : 12,
                                            fontWeight: FontWeight.bold,
                                            color: pressedButtonIndex == index ? Colors.white : Colors.black),
                                      ),
                                      if (tables[index]['occupied'] && pressedButtonIndex != index)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Add space around the text
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5.0), // Rounded corners (optional)
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'SEATED',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: pressedButtonIndex == index ? Colors.white : Colors.white,
                                                ),
                                              ),
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
                      Row(
                        children: [
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
                                          selectedOrder.resetDefault();
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
                          (isTableSelected && selectedOrder.status != "Start Your Order" && selectedOrder.status != "Ordering")
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
                                                        ref.read(ordersProvider.notifier).cancelOrder(selectedOrder.orderNumber, categories);

                                                        log('Order from order details page cancelled: ${selectedOrder.orderNumber}');

                                                        setState(() {
                                                          selectedOrder.handleCancelOrder();
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
            onItemAdded: onItemAdded,
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
