import 'dart:developer'; // for log function
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/handle_print_jobs.dart';
import 'package:jspos/utils/cherry_toast_utils.dart';

class HistoryOrderPage extends ConsumerStatefulWidget {
  final SelectedOrder historyOrder;

  const HistoryOrderPage({super.key, required this.historyOrder});

  @override
  HistoryOrderPageState createState() => HistoryOrderPageState();
}

class HistoryOrderPageState extends ConsumerState<HistoryOrderPage> {
  bool isPrinting = false;
  final List<String> categories = ["Cakes", "Dishes", "Drinks", "Special", "Add On"];
  Map<String, List<Item>> categorizeItems(List<Item> items) {
    Map<String, List<Item>> categorizedItems = {};
    log('History Order Page: ${widget.historyOrder}');
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Get the screen size
    var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height
    return Scaffold(
      backgroundColor: const Color(0xff1f2029), //This is inside the item details
      body: Dialog(
        backgroundColor: Colors.black, // This is inside the item details
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
                      color: widget.historyOrder.status == "Paid" ? Colors.green : Colors.redAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.historyOrder.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Status: ${widget.historyOrder.status}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.historyOrder.status == "Paid" ? ' - with ${widget.historyOrder.paymentMethod}' : '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.historyOrder.status == "Paid" ? 'Transaction Time:' : 'Cancalled Time',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.historyOrder.status == "Paid" ? widget.historyOrder.paymentTime : widget.historyOrder.cancelledTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                                Map<String, List<Item>> categorizedItems = categorizeItems(widget.historyOrder.items);
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
                                                                      item.selection && item.selectedSoupOrKonLou != null
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
                                                                      item.selection && item.selectedNoodlesType != null
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
                            // color: const Color(0xff1f2029),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                          widget.historyOrder.subTotal.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount (${widget.historyOrder.discount}%)',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          (widget.historyOrder.subTotal * (widget.historyOrder.discount / 100)).toStringAsFixed(2),
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
                                          widget.historyOrder.totalPrice.toStringAsFixed(2),
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
                                          widget.historyOrder.amountReceived.toStringAsFixed(2),
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
                                          '- ${widget.historyOrder.amountChanged.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromRGBO(46, 125, 50, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: isPrinting
                                        ? null
                                        : () async {
                                            // Set isPrinting to true when printing starts
                                            setState(() {
                                              isPrinting = true;
                                            });

                                            if (mounted) {
                                              showCherryToast(
                                                context,
                                                'check_circle',
                                                Colors.green,
                                                // 'Welcome Back! ${matchedUser.name}!',
                                                'Please wait while printing is in process, do not move away from this page.',
                                                3000,
                                                1000,
                                              );
                                            }
                                            // Perform printing process
                                            await handlePrintingJobs(context, ref, selectedOrder: widget.historyOrder, specificArea: 'Cashier');

                                            if (!context.mounted) return;
                                            // Set isPrinting back to false when done
                                            setState(() {
                                              isPrinting = false;
                                            });
                                            Navigator.pop(context); // Close the screen when done
                                          },
                                    child: const Text('Print'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    // Disable "Close" button if printing is in progress
                                    onPressed: isPrinting
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                          },
                                    child: const Text('Close'),
                                  ),
                                ],
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
