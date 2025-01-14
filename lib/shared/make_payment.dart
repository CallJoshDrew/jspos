import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/data/categories_data.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/providers/invoice_provider.dart';
// import 'package:jspos/models/selected_order.dart';
import 'package:jspos/providers/orders_provider.dart';
import 'package:jspos/providers/selected_order_provider.dart';
import 'package:jspos/providers/tables_provider.dart';
import 'package:jspos/utils/cherry_toast_utils.dart';

class MakePaymentPage extends ConsumerStatefulWidget {
  final VoidCallback? updateOrderStatus;

  final int selectedTableIndex;
  final bool isTableInitiallySelected;

  const MakePaymentPage({
    super.key,
    required this.updateOrderStatus,
    required this.selectedTableIndex,
    required this.isTableInitiallySelected,
  });

  @override
  MakePaymentPageState createState() => MakePaymentPageState();
}

class MakePaymentPageState extends ConsumerState<MakePaymentPage> {
  late Orders orders; // No need to reinitialize here directly.
  String selectedPaymentMethod = "Cash";
  final TextEditingController _controller = TextEditingController();
  late double subTotalBill;
  late double totalBill;
  double amountReceived = 0.0;
  double adjustedAmountReceived = 0.0;
  double amountChanged = 0.0;
  double totalAmountAfterDiscount = 0.00;
  int enteredDiscount = 0;
  List<bool> isSelected = [false, true];
  late bool isTableSelected;

  void _applyDiscount() {
    // Calculate the discounted total amount
    double discountAmount = subTotalBill * (enteredDiscount / 100);
    totalAmountAfterDiscount = subTotalBill - discountAmount;

    // Update adjustedAmountReceived and totalBill based on discount
    if (enteredDiscount > 0 && enteredDiscount < 100) {
      adjustedAmountReceived = totalAmountAfterDiscount;
      totalBill = adjustedAmountReceived;
    } else {
      totalBill = subTotalBill;
    }

    // Ensure values are rounded to 2 decimal places
    totalAmountAfterDiscount = double.parse(totalAmountAfterDiscount.toStringAsFixed(2));
    // Debug: Log the discount calculation
    log("SubTotal: $subTotalBill, Discount: $enteredDiscount, Total After Discount: $totalAmountAfterDiscount");
  }

  void _calculateAmountReceived() {
    // If no value is entered, amountReceived should remain as-is
    if (amountReceived == 0.0) {
      amountReceived = totalBill;
    }

    // Calculate change based on the entered amount
    double calculatedChange = amountReceived - totalBill;
    amountChanged = calculatedChange < 0 ? 0.0 : calculatedChange;

    // Round to 2 decimal places for display consistency
    amountReceived = double.parse(amountReceived.toStringAsFixed(2));
    amountChanged = double.parse(amountChanged.toStringAsFixed(2));

    // Debugging logs
    log("Amount Received: $amountReceived");
    log("Amount Changed: $amountChanged");
  }

  // Example of your categories list
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

  Map<String, dynamic> filterRemarks(Map<String, dynamic>? itemRemarks) {
    Map<String, dynamic> filteredRemarks = {};
    if (itemRemarks != null) {
      itemRemarks.forEach((key, value) {
        // Add your conditions here: exclude keys '98', '99', and empty values.
        if (key != '98' && key != '99' && value != null && value.toString().trim().isNotEmpty) {
          filteredRemarks[key] = value;
        }
      });
    }
    log('Filtered Remarks: $filteredRemarks');
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
    final tables = ref.read(tablesProvider);
    showCherryToast(
      context,
      'check_circle',
      Colors.green,
      'The payment for the ${tables[widget.selectedTableIndex]['name']} has been successfully processed.',
      3000,
      200,
    );
  }

  void _navigateBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    orders = ref.read(ordersProvider);
    subTotalBill = ref.read(selectedOrderProvider).subTotal;
    totalBill = ref.read(selectedOrderProvider).totalPrice;
    isTableSelected = widget.isTableInitiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder = ref.read(selectedOrderProvider);
    final selectedOrderNotifier = ref.read(selectedOrderProvider.notifier);

    var screenSize = MediaQuery.of(context).size; // Get the screen size
    var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height

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
                      color: const Color.fromRGBO(46, 125, 50, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedOrder.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Verifying Bill before Payment Transaction',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${selectedOrder.orderTime} -',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              selectedOrder.orderDate,
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
                                Map<String, List<Item>> categorizedItems = categorizeItems(selectedOrder.items);
                                Map<String, int> totalQuantities = calculateTotalQuantities(categorizedItems);
                                Map<String, double> totalPrices = calculateTotalPrices(categorizedItems);
                                List<Widget> categoryWidgets = [];

                                for (var category in categories) {
                                  if (categorizedItems.containsKey(category)) {
                                    var items = categorizedItems[category]!;

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
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                if (item.selection == true &&
                                                                    item.selectedChoice != null) // Case 1: With selection and selectedChoice
                                                                  Row(
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
                                                                      const SizedBox(width: 5),
                                                                      Text(
                                                                        "( ${item.selectedChoice!['price'].toStringAsFixed(2)} ) ",
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Color.fromARGB(255, 114, 226, 118),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                else if (item.selectedDrink != null &&
                                                                    item.selectedDrink!['name']?.isNotEmpty == true) // Case 2: Drinks
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        item.originalName == item.selectedDrink!['name']
                                                                            ? '${index + 1}.${item.originalName}  - ${item.selectedTemp?["name"]}'
                                                                            : '${index + 1}.${item.originalName} ${item.selectedDrink?['name']} - ${item.selectedTemp?["name"]} ',
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '( ${item.price.toStringAsFixed(2)} )',
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Color.fromARGB(255, 114, 226, 118),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                else // Case 3: Fallback for items without selection or selectedDrink
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${index + 1}.${item.originalName}',
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 5),
                                                                      Text(
                                                                        '( ${item.price.toStringAsFixed(2)} )',
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Color.fromARGB(255, 114, 226, 118),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                                                      item.selection && item.selectedSoupOrKonLou != null && item.selectedSoupOrKonLou!['name'] != "None"
                                                                          ? Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${item.selectedSoupOrKonLou!['name']} - ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.yellow,
                                                                                  ),
                                                                                ),
                                                                                // Display price only if it is greater than 0.00
                                                                                if (item.selectedSoupOrKonLou!['price'] != 0.00)
                                                                                  Text(
                                                                                    "( + ${item.selectedSoupOrKonLou!['price'].toStringAsFixed(2)} )",
                                                                                    style: const TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: Color.fromARGB(255, 114, 226, 118),
                                                                                    ),
                                                                                  )
                                                                              ],
                                                                            )
                                                                          : const SizedBox.shrink(),
                                                                      item.selection && item.selectedNoodlesType != null && item.selectedSoupOrKonLou != null && item.selectedSoupOrKonLou!['name'] != "None"
                                                                          ? Wrap(
                                                                              children: [
                                                                                for (var noodleType in item.selectedNoodlesType!.toList())
                                                                                  Wrap(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${noodleType['name']} ",
                                                                                        style: const TextStyle(
                                                                                          fontSize: 14,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      if (noodleType['price'] != null && noodleType['price'] != 0.00)
                                                                                        Text(
                                                                                          "( + ${noodleType['price'].toStringAsFixed(2)} )",
                                                                                          style: const TextStyle(
                                                                                            fontSize: 14,
                                                                                            color: Color.fromARGB(255, 114, 226, 118),
                                                                                          ),
                                                                                        ),
                                                                                      Text(
                                                                                        "${noodleType != item.selectedNoodlesType!.last ? ', ' : ''} ",
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
                                                                      // item.selection &&
                                                                      //         item.selectedNoodlesType != null &&
                                                                      //         item.selectedNoodlesType!['name'] != 'None'
                                                                      //     ? Row(
                                                                      //         children: [
                                                                      //           Text(
                                                                      //             "${item.selectedNoodlesType!['name']} ",
                                                                      //             style: const TextStyle(fontSize: 14, color: Colors.white),
                                                                      //           ),
                                                                      //           // Display price only if it is greater than 0.00
                                                                      //           if (item.selectedNoodlesType!['price'] != 0.00)
                                                                      //             Text(
                                                                      //               "( + ${item.selectedNoodlesType!['price'].toStringAsFixed(2)} )",
                                                                      //               style: const TextStyle(
                                                                      //                 fontSize: 14,
                                                                      //                 color: Color.fromARGB(255, 114, 226, 118),
                                                                      //               ),
                                                                      //             ),
                                                                      //         ],
                                                                      //       )
                                                                      //     : const SizedBox.shrink(),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                  children: [
                                                                    item.selection && item.selectedSetDrink != null
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                "${item.selectedSetDrink!['name']}",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.yellow,
                                                                                ),
                                                                              ),
                                                                              // Display price only if it is greater than 0.00
                                                                              if (item.selectedSetDrink!['price'] != 0.00)
                                                                                Text(
                                                                                  "( + ${item.selectedSetDrink!['price'].toStringAsFixed(2)} ) ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Color.fromARGB(255, 114, 226, 118),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                                  item.selection &&
                                                                          item.selectedMeePortion != null &&
                                                                          item.selectedMeePortion!['name'] != "Normal"
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                              "${item.selectedMeePortion!['name']} Mee ",
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            // Display price only if it is greater than 0.00
                                                                            if (item.selectedMeePortion!['price'] != 0.00)
                                                                              Text(
                                                                                "( + ${item.selectedMeePortion!['price'].toStringAsFixed(2)} )",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                                ),
                                                                              )
                                                                          ],
                                                                        )
                                                                      : const SizedBox.shrink(),
                                                                  item.selection &&
                                                                          item.selectedMeatPortion != null &&
                                                                          item.selectedMeatPortion!['name'] != "Normal"
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                              "${item.selectedMeatPortion!['name']} Meat",
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            if (item.selectedMeatPortion!['price'] != 0.00)
                                                                              Text(
                                                                                "( + ${item.selectedMeatPortion!['price'].toStringAsFixed(2)} )",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                                ),
                                                                              )
                                                                          ],
                                                                        )
                                                                      : const SizedBox.shrink(),
                                                                  item.selection && item.selectedAddMilk != null && item.selectedAddMilk!['name'] != "No Milk"
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                              "Add ${item.selectedAddMilk!['name']} ",
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            if (item.selectedAddMilk!['price'] != 0.00)
                                                                              Text(
                                                                                "( + ${item.selectedAddMilk!['price'].toStringAsFixed(2)} )",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                                ),
                                                                              )
                                                                          ],
                                                                        )
                                                                      : const SizedBox.shrink(),
                                                                  item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                              "Total Sides: ${(item.selectedSide?.length)}",
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.yellow,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            if (item.selectedAddOn != null && item.selectedAddOn!['price'] > 0.00)
                                                                              Text(
                                                                                "( ${item.selectedAddOn!['name']} Extra Sides ",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                                ),
                                                                              ),
                                                                            const SizedBox(width: 5),
                                                                            if (item.selectedAddOn != null && item.selectedAddOn!['price'] > 0.00)
                                                                              Text(
                                                                                "+ ${(item.selectedAddOn!['price'] as double).toStringAsFixed(2)})",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        )
                                                                      : const SizedBox.shrink(),
                                                                  item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty
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
                                                                                  if (side['price'] != null && side['price'] != 0.00)
                                                                                    Text(
                                                                                      "( + ${side['price'].toStringAsFixed(2)} )",
                                                                                      style: const TextStyle(
                                                                                        fontSize: 14,
                                                                                        color: Color.fromARGB(255, 114, 226, 118),
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
                                                                      item.selection && filterRemarks(item.itemRemarks).isNotEmpty
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
                                                    const SizedBox(width: 50),
                                                    Text(
                                                      (item.price * item.quantity).toStringAsFixed(2),
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
                                    categoryWidgets.add(
                                      Padding(
                                        padding: const EdgeInsets.only(right: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total $category :   ${totalPrices[category]?.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Sub Total',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          subTotalBill.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount ($enteredDiscount%)',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          (subTotalBill * (enteredDiscount / 100)).toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    // custom doted line.
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 12),
                                      child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          final boxWidth = constraints.constrainWidth();
                                          const dashWidth = 4.0;
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
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total (RM)',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          (totalBill.toStringAsFixed(2)),
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    // custom doted line.
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 12),
                                      child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          final boxWidth = constraints.constrainWidth();
                                          const dashWidth = 4.0;
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
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Amount Received',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          amountReceived.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Amount Change',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          '- ${amountChanged.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "1.Select Payment Method",
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 6,
                                      runSpacing: 0,
                                      children: <String>['Cash', 'DuitNow', 'FoodPanda', 'GrabFood', 'ShopeeFood'].map((String value) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            foregroundColor: WidgetStateProperty.all<Color>(
                                              selectedPaymentMethod == value ? Colors.white : Colors.black87,
                                            ),
                                            backgroundColor: WidgetStateProperty.all<Color>(
                                              selectedPaymentMethod == value ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
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
                                              selectedPaymentMethod = value;
                                              // selectedOrder.paymentMethod = value;
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
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Discount Input
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "2.Enter Discount (%)",
                                                style: TextStyle(fontSize: 14, color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 5), // Add spacing between label and input
                                              TextField(
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: const InputDecoration(
                                                  hintText: "0",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.grey),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    // Parse the entered discount and ensure it's between 0 and 100
                                                    enteredDiscount = int.tryParse(value) ?? 0;
                                                    // Ensure discount is not between 1 and 100, set the discount in _calculateChange()
                                                    if (enteredDiscount < 0 || enteredDiscount > 100) {
                                                      enteredDiscount = 0;
                                                    }

                                                    // Trigger change calculation and set it
                                                    _applyDiscount();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20), // Spacing between the two input fields
                                        // Amount Received Input
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "3.Amount Received (RM)",
                                                style: TextStyle(fontSize: 14, color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 5), // Add spacing between label and input
                                              TextField(
                                                  controller: _controller,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    hintText: (adjustedAmountReceived == 0.0
                                                        ? subTotalBill.toStringAsFixed(2)
                                                        : adjustedAmountReceived.toStringAsFixed(2)),
                                                    hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    border: const OutlineInputBorder(),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey), //
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      // Parse input or fallback to 0.0 if empty
                                                      amountReceived = double.tryParse(value) ?? 0.0;

                                                      // Trigger recalculation with the updated amountReceived
                                                      _calculateAmountReceived();
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end, // This will space the buttons evenly in the row.
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
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
                                                                '‘RM${_controller.text.isEmpty ? totalBill.toStringAsFixed(2) : _controller.text}‘ ',
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const Text(
                                                                'payment ',
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
                                                                '‘$selectedPaymentMethod‘,',
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
                                                                try {
                                                                  // Access the 'orders' box safely
                                                                  // var ordersBox = Hive.isBoxOpen('orders')
                                                                  //     ? Hive.box<Orders>('orders')
                                                                  //     : await Hive.openBox<Orders>('orders');
                                                                  _applyDiscount();
                                                                  _calculateAmountReceived();
                                                                  await ref.read(invoiceProvider.notifier).initializeInvoiceCounter();
                                                                  String invoiceNumber = await ref.read(invoiceProvider.notifier).generateInvoiceNumber();
                                                                  // Update selected order with invoice number
                                                                  selectedOrderNotifier.processPayment(
                                                                    amountReceived: amountReceived,
                                                                    amountChanged: amountChanged,
                                                                    discount: enteredDiscount,
                                                                    total: totalBill,
                                                                    subTotal: subTotalBill,
                                                                    paymentMethod: selectedPaymentMethod,
                                                                    status: 'Paid',
                                                                    cancelledTime: 'None',
                                                                    invoiceNumber: invoiceNumber,
                                                                  );
                                                                  log('Generated Invoice Number: $invoiceNumber');

                                                                  final updatedSelectedOrder = ref.read(selectedOrderProvider);

                                                                  if (updatedSelectedOrder.invoiceNumber != invoiceNumber) {
                                                                    log('Warning: Invoice number not updated in selectedOrderProvider');
                                                                  }

                                                                  // Add or update the order and save it in Hive
                                                                  widget.updateOrderStatus?.call();
                                                                  ref.read(ordersProvider.notifier).addOrUpdateOrder(updatedSelectedOrder);

                                                                  // Clear table data for the selected table
                                                                  var emptyOrderNumber = '';

                                                                  // Update the tables state
                                                                  ref
                                                                      .read(tablesProvider.notifier)
                                                                      .updateSelectedTable(widget.selectedTableIndex, emptyOrderNumber, false);

                                                                  isTableSelected = !isTableSelected; // Update the state
                                                                  // log('Order saved with discount: ${selectedOrder.discount}');

                                                                  //// Log updated orders from Hive for debugging
                                                                  // var storedOrders = ordersBox.get('orders') as Orders;
                                                                  // for (var order in storedOrders.data) {
                                                                  //   log('Order Number: ${order.orderNumber}, Status: ${order.status}, Total Qty: ${order.totalQuantity}');
                                                                  // }

                                                                  // Safely interact with UI if the widget is still in the tree
                                                                  if (mounted) {
                                                                    _showSuccessToast();
                                                                    _navigateBack();
                                                                  }
                                                                } catch (e) {
                                                                  log('An error occurred at MakePaymentPage: $e');
                                                                }
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
                                            selectedOrder.discount = 0;
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
