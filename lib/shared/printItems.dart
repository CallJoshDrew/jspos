import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:jspos/data/menu_data.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/providers/orders_provider.dart';

class PrintItemsPage extends ConsumerStatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback? updateOrderStatus;

  final List<Map<String, dynamic>> tables;
  final int selectedTableIndex;
  final void Function(int index, String orderNumber, bool isOccupied) updateTables;
  final bool isTableInitiallySelected;

  const PrintItemsPage({
    super.key,
    required this.selectedOrder,
    required this.updateOrderStatus,
    required this.tables,
    required this.selectedTableIndex,
    required this.updateTables,
    required this.isTableInitiallySelected,
  });

  @override
  PrintItemsPageState createState() => PrintItemsPageState();
}

class PrintItemsPageState extends ConsumerState<PrintItemsPage> {
  late Orders orders; // No need to reinitialize here directly.
  String selectedPrinter = "All";
  final TextEditingController _controller = TextEditingController();
  late double originalBill; // Declare originalBill
  late double adjustedBill;
  bool isRoundingApplied = false;
  List<bool> isSelected = [false, true];
  double amountReceived = 0.0;
  double amountChanged = 0.0;
  double roundingAdjustment = 0.0;
  int enteredDiscount = 0;
  late bool isTableSelected;

  void _calculateTotalWithDiscount() {
    // Calculate the discount amount
    double discountAmount = widget.selectedOrder.subTotal * (widget.selectedOrder.discount / 100);

    // Calculate the original and adjusted bill
    originalBill = widget.selectedOrder.subTotal - discountAmount;
    adjustedBill = isRoundingApplied ? roundBill(originalBill) : originalBill;
  }

  Map<String, List<Item>> categorizeItems(List<Item> items) {
    Map<String, List<Item>> categorizedItems = {};

    for (var item in items) {
      if (!categorizedItems.containsKey(item.category)) {
        categorizedItems[item.category] = [];
      }
      categorizedItems[item.category]?.add(item);
    }

    return categorizedItems;
  }

  Map<String, int> calculateTotalQuantities(Map<String, List<Item>> categorizedItems) {
    Map<String, int> totalQuantities = {};

    for (var entry in categorizedItems.entries) {
      totalQuantities[entry.key] = entry.value.fold(0, (sum, item) => sum + item.quantity);
    }

    return totalQuantities;
  }

  Map<String, double> calculateTotalPrices(Map<String, List<Item>> categorizedItems) {
    Map<String, double> totalPrices = {};

    for (var entry in categorizedItems.entries) {
      totalPrices[entry.key] = entry.value.fold(0.0, (sum, item) => sum + item.quantity * item.price);
    }

    return totalPrices;
  }

  double roundBill(double bill) {
    double fractionalPart = bill - bill.floor();
    if (fractionalPart <= 0.50) {
      return bill.floorToDouble();
    } else {
      return bill;
    }
  }

  Map<String, dynamic> filterRemarks(Map<String, dynamic>? itemRemarks) {
    Map<String, dynamic> filteredRemarks = {};
    if (itemRemarks != null) {
      itemRemarks.forEach((key, value) {
        // Add your conditions here
        if (key != '98' && key != '99') {
          filteredRemarks[key] = value;
        }
      });
    }
    return filteredRemarks;
  }

  String getFilteredRemarks(Map<String, dynamic>? itemRemarks) {
    final filteredRemarks = filterRemarks(itemRemarks);
    return filteredRemarks.values.join(', ');
  }

  // String getItemNameWithLog(int index, dynamic item) {
  //   // Log the item name using developer.log
  //   log('Item Original Name: ${item.originalName}');
  //   log('Item selectedDrink Name: ${item.selectedDrink?['name']}');

  //   // Return the formatted string based on the conditions
  //   return item.selectedDrink !=null
  //       ? '${index + 1}.${item.originalName} ${item.selectedDrink?['name']} - ${item.selectedTemp?["name"]}'
  //       : '${index + 1}.${item.originalName}';
  // }
  void _showSuccessToast() {
    CherryToast(
      icon: Icons.verified_rounded,
      iconColor: Colors.green,
      themeColor: const Color.fromRGBO(46, 125, 50, 1),
      backgroundColor: Colors.white,
      title: const Text(
        'Thank you!',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        'The payment for the table ${widget.tables[widget.selectedTableIndex]['name']} has been successfully processed.',
        style: const TextStyle(fontSize: 14),
      ),
      toastPosition: Position.top,
      toastDuration: const Duration(milliseconds: 3000),
      animationType: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 200),
      autoDismiss: true,
      displayCloseButton: false,
    ).show(context);
  }

  void _navigateBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  // A map to keep track of selected items, categorized by category
  Map<String, List<Item>> selectedItems = {};

  // Function to toggle item selection
  void toggleItemSelection(String category, Item item) {
    setState(() {
      if (selectedItems[category] == null) {
        selectedItems[category] = [];
      }
      if (selectedItems[category]!.contains(item)) {
        selectedItems[category]!.remove(item);
        log('Item removed: ${item.name} from category $category');
      } else {
        selectedItems[category]!.add(item);
        log('Item added: ${item.name} to category $category');
      }

      // Log the entire selectedItems map for tracking
      log('Updated selectedItems: ${selectedItems.map((k, v) => MapEntry(k, v.map((item) => item.name).toList()))}');
    });
  }

  Widget buildDottedLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 3.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(dashCount, (_) {
              return Row(
                children: <Widget>[
                  Container(width: dashWidth, height: 2, color: Colors.black87),
                  const SizedBox(width: dashWidth),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    orders = ref.read(ordersProvider);
    originalBill = widget.selectedOrder.totalPrice; // Initialize originalBill here
    adjustedBill = originalBill; // Initialize adjustedBill here
    // log('initState called, adjustedBill is now $adjustedBill');
    isTableSelected = widget.isTableInitiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Get the screen size
    var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height

    _calculateTotalWithDiscount();

    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Set the border radius here
        ),
        insetPadding: const EdgeInsets.only(top: 25), // Remove any padding
        child: SizedBox(
          width: screenSize.width, // Set width to screen width
          height: screenSize.height - statusBarHeight, // Subtract the status bar height from the screen height
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedOrder.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Select Items to Print',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.selectedOrder.orderTime} -',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.selectedOrder.orderDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: () {
                                Map<String, List<Item>> categorizedItems = categorizeItems(widget.selectedOrder.items);
                                Map<String, int> totalQuantities = calculateTotalQuantities(categorizedItems);
                                List<Widget> categoryWidgets = [];
                                categorizedItems.forEach((category, items) {
                                  categoryWidgets.add(
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                                      child: Text(
                                        '$category: ${totalQuantities[category]}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                  categoryWidgets.add(
                                    Column(
                                      children: items.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        Item item = entry.value;
                                        return Container(
                                          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
                                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: const Color(0xff1f2029),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: selectedItems[category]?.contains(item) ?? false,
                                                    onChanged: (bool? selected) {
                                                      toggleItemSelection(category, item);
                                                    },
                                                    activeColor: Colors.green,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              item.selection && item.selectedChoice != null
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                          item.originalName == item.selectedChoice!['name']
                                                                              ? '${index + 1}.${item.originalName}'
                                                                              : '${index + 1}.${item.originalName} ${item.selectedChoice!['name']}',
                                                                          style: const TextStyle(
                                                                            fontSize: 14,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      // getItemNameWithLog(index, item),
                                                                      item.selectedDrink != null
                                                                          ? '${index + 1}.${item.originalName} ${item.selectedDrink?['name']} - ${item.selectedTemp?["name"]}'
                                                                          : '${index + 1}.${item.originalName}',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 12),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    item.selection &&
                                                                            item.selectedNoodlesType != null &&
                                                                            item.selectedNoodlesType!['name'] != 'None'
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                "${item.selectedNoodlesType!['name']} ",
                                                                                style: const TextStyle(fontSize: 14, color: Colors.white),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    item.selection && item.selectedSoupOrKonLou != null
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                "- ${item.selectedSoupOrKonLou!['name']} ",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                                item.selection &&
                                                                        item.selectedMeePortion != null &&
                                                                        item.selectedMeePortion!['name'] != "Normal Mee"
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeePortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection &&
                                                                        item.selectedMeatPortion != null &&
                                                                        item.selectedMeatPortion!['name'] != "Normal Meat"
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeatPortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection && item.selectedSide!.isNotEmpty
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "Total Sides: ${(item.selectedSide?.length)}",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.yellow,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection && item.selectedSide != null
                                                                    ? Wrap(
                                                                        children: [
                                                                          for (var side in item.selectedSide!.toList())
                                                                            Wrap(
                                                                              children: [
                                                                                Text(
                                                                                  "${side['name']} ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "${side != item.selectedSide!.last ? ', ' : ''} ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                Wrap(
                                                                  children: [
                                                                    item.selection && filterRemarks(item.itemRemarks).isNotEmpty == true
                                                                        ? Row(
                                                                            children: [
                                                                              const Text(
                                                                                'Remarks: ',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                getFilteredRemarks(item.itemRemarks),
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.orangeAccent,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'x ${item.quantity}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                              // first column
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                });

                                return categoryWidgets;
                              }(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xff1f2029),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    // const Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       'Item',
                                    //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                    //     ),
                                    //     Text(
                                    //       'Quantity',
                                    //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                    //     ),
                                    //   ],
                                    // ),
                                    // buildDottedLine(),
                                    // Display selectedItems
                                    ...selectedItems.entries.map((entry) {
                                      String category = entry.key;
                                      List<Item> items = entry.value;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029), // Background color
                                              borderRadius: BorderRadius.circular(5.0), // Optional: Rounded corners
                                            ),
                                            child: Text(
                                              category,
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                          ),
                                          // Display each item's index, name, and quantity
                                          ...items.asMap().entries.map((entry) {
                                            int index = entry.key + 1; // Index in a 1-based count
                                            Item item = entry.value;
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '$index. ${item.name}', // Displays index and item name
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                  Text(
                                                    'x ${items.where((i) => i == item).length}', // Display quantity
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          buildDottedLine(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  'Total',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${items.length}',
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                                ),
                                              ],
                                            ),
                                          ),
                                          buildDottedLine(),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Select Printer",
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 6,
                                      runSpacing: 0,
                                      children: <String>['Cashier', 'Kitchen', 'Beverage', 'All'].map((String value) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            foregroundColor: WidgetStateProperty.all<Color>(
                                              selectedPrinter == value ? Colors.white : Colors.black87,
                                            ),
                                            backgroundColor: WidgetStateProperty.all<Color>(
                                              selectedPrinter == value ? Colors.green : Colors.white,
                                            ),
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedPrinter = value;
                                            });
                                          },
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end, // This will space the buttons evenly in the row.
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
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  insetPadding: EdgeInsets.zero, // Make dialog full-screen
                                                  backgroundColor: Colors.black87,
                                                  child: AlertDialog(
                                                    backgroundColor: const Color(0xff1f2029),
                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(
                                                      side: const BorderSide(color: Colors.green, width: 1), // This is the border color
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    content: ConstrainedBox(
                                                      constraints: const BoxConstraints(
                                                        maxWidth: 600,
                                                        maxHeight: 100,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const Text(
                                                            'Are you sure?',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
                                                          ),
                                                          Wrap(
                                                            alignment: WrapAlignment.center,
                                                            children: [
                                                              const Text(
                                                                'Please confirm you have received ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              Text(
                                                                '‘RM${_controller.text.isEmpty ? (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2) : _controller.text}‘ ',
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const Text(
                                                                'Printer ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              (amountChanged > 0)
                                                                  ? Wrap(
                                                                      children: [
                                                                        const Text(
                                                                          'and provide ',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 18,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '‘RM${amountChanged.toStringAsFixed(2)}‘',
                                                                          textAlign: TextAlign.center,
                                                                          style: const TextStyle(
                                                                            fontSize: 18,
                                                                            color: Colors.red,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        const Text(
                                                                          '(change) ',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 18,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : const SizedBox.shrink(),
                                                              const Text(
                                                                'in ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              Text(
                                                                '‘$selectedPrinter‘,',
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const Text(
                                                                ' before pressing confirm.',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
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
                                                              onPressed: () async {
                                                                log('You have confirmed');
                                                              },
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(6),
                                                                child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
                                                              ),
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
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Text(
                                            'Accept',
                                            style: TextStyle(fontSize: 14, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
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
                                            widget.selectedOrder.discount = 0;
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
