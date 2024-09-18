import 'dart:developer'; // for log function
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/print_jobs.dart';

class HistoryOrderPage extends ConsumerStatefulWidget {
  final SelectedOrder historyOrder;

  const HistoryOrderPage({super.key, required this.historyOrder});

  @override
  HistoryOrderPageState createState() => HistoryOrderPageState();
}

class HistoryOrderPageState extends ConsumerState<HistoryOrderPage> {
  String selectedPaymentMethod = "Cash";
  bool isPrinting = false;

  late double originalBill; // Declare originalBill
  late double adjustedBill;
  bool isRoundingApplied = false;
  List<bool> isSelected = [false, true];
  double amountReceived = 0.0;
  double amountChanged = 0.0;
  double roundingAdjustment = 0.0;

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

  @override
  void initState() {
    super.initState();
    originalBill = widget.historyOrder.totalPrice; // Initialize originalBill here
    adjustedBill = originalBill; // Initialize adjustedBill here
    // log('initState called, adjustedBill is now $adjustedBill');
  }

  @override
  Widget build(BuildContext context) {
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
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              item.selection && item.selectedChoice != null
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                          "${index + 1}.${item.originalName} ${item.selectedChoice!['name']} ",
                                                                          style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "( ${item.selectedChoice!['price'].toStringAsFixed(2)} ) ",
                                                                          style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      item.selectedTemp != null
                                                                          ? '${index + 1}. ${item.name} - ${item.selectedTemp?['name']} ( ${item.price.toStringAsFixed(2)} )'
                                                                          : '${index + 1}. ${item.name} ( ${item.price.toStringAsFixed(2)} )',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
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
                                                                item.selection && item.selectedType != null
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedType!['name']} ",
                                                                            style: const TextStyle(fontSize: 14, color: Colors.white),
                                                                          ),
                                                                          Text(
                                                                            "( + ${item.selectedType!['price'].toStringAsFixed(2)} )",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color.fromARGB(255, 114, 226, 118),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection && item.selectedMeePortion != null
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeePortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
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
                                                                item.selection && item.selectedMeatPortion != null
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeatPortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
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
                                                                item.selection && item.selectedAddOn != null
                                                                    ? Wrap(
                                                                        children: [
                                                                          item.selectedAddOn!.isNotEmpty
                                                                              ? const Text(
                                                                                  "AddOn: ",
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.yellow,
                                                                                  ),
                                                                                )
                                                                              : const SizedBox.shrink(),
                                                                          for (var addOn in item.selectedAddOn!.toList())
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${addOn['name']} ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                if (addOn['price'] != null)
                                                                                  Text(
                                                                                    "( + ${addOn['price'].toStringAsFixed(2)} )",
                                                                                    style: const TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: Color.fromARGB(255, 114, 226, 118),
                                                                                    ),
                                                                                  ),
                                                                                Text(
                                                                                  "${addOn != item.selectedAddOn!.last ? ', ' : ''} ",
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
                                                      fontWeight: FontWeight.bold,
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
                                        const Text(
                                          'Service Charges',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          widget.historyOrder.serviceCharge.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Rounding Adjustment',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          '- ${(roundingAdjustment).toStringAsFixed(2)}',
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

                                            CherryToast(
                                              icon: Icons.info,
                                              iconColor: Colors.green,
                                              themeColor: Colors.green,
                                              backgroundColor: Colors.white,
                                              title: const Text(
                                                'Please wait while printing is in process, do not move away from this page.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              toastPosition: Position.top,
                                              toastDuration: const Duration(milliseconds: 3000),
                                              animationType: AnimationType.fromTop,
                                              animationDuration: const Duration(milliseconds: 1000),
                                              autoDismiss: true,
                                              displayCloseButton: false,
                                            ).show(context);
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
