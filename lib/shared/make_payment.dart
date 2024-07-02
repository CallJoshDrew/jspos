// import 'dart:developer';
import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/data/menu_data.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';

class MakePaymentPage extends StatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback? updateOrderStatus;
  final Orders orders;
  final List<Map<String, dynamic>> tables;
  final int selectedTableIndex;
  final void Function(int index, String orderNumber, bool isOccupied) updateTables;

  const MakePaymentPage(
      {super.key,
      required this.selectedOrder,
      required this.updateOrderStatus,
      required this.orders,
      required this.tables,
      required this.selectedTableIndex,
      required this.updateTables});

  @override
  MakePaymentPageState createState() => MakePaymentPageState();
}

class MakePaymentPageState extends State<MakePaymentPage> {
  String selectedPaymentMethod = "Cash";
  final TextEditingController _controller = TextEditingController();
  late double originalBill; // Declare originalBill
  late double adjustedBill;
  bool isRoundingApplied = false;
  List<bool> isSelected = [false, true];
  double amountReceived = 0.0;
  double amountChanged = 0.0;
  double roundingAdjustment = 0.0;

  void _calculateChange() {
    if (_controller.text.isEmpty) {
      amountReceived = double.parse(adjustedBill.toStringAsFixed(2));
    } else {
      num? parsedValue = num.tryParse(_controller.text);
      if (parsedValue != null) {
        amountReceived = parsedValue.toDouble();
      } else {
        // Handle the error: _controller.text is not a valid number
        // For example, you could set amountReceived to a default value:
        amountReceived = 0.0;
      }
    }
    if (isRoundingApplied) {
      adjustedBill = roundBill(originalBill);
    }
    double calculatedChange = amountReceived - (isRoundingApplied ? adjustedBill : originalBill); // calculates the change
    amountChanged = calculatedChange < 0 ? 0.0 : calculatedChange; // if the calculated change is negative, set amountChanged to 0.0
    amountChanged = double.parse(amountChanged.toStringAsFixed(2)); // rounds amountChanged to two decimal places and converts it back to a double.
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

  @override
  void initState() {
    super.initState();
    originalBill = widget.selectedOrder.totalPrice; // Initialize originalBill here
    adjustedBill = originalBill; // Initialize adjustedBill here
    // log('initState called, adjustedBill is now $adjustedBill');
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Get the screen size
    var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height
    double fractionAmount = widget.selectedOrder.totalPrice - widget.selectedOrder.totalPrice.floor();
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
                          'Verifying Bill before Payment Transaction',
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
                                                                    ? Row(
                                                                        children: [
                                                                          const Text(
                                                                            "AddOn: ",
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
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
                                          widget.selectedOrder.subTotal.toStringAsFixed(2),
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
                                          widget.selectedOrder.serviceCharge.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    (fractionAmount < 0.50 && fractionAmount > 0.00)
                                        ? Row(
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
                                          )
                                        : const SizedBox.shrink(),
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
                                          (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2),
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
                                          _controller.text.isEmpty ? (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2) : _controller.text,
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
                                    (fractionAmount < 0.50 && fractionAmount > 0.00)
                                        ? Row(
                                            children: [
                                              const Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Allow Rounding Adjustment?",
                                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    Text(
                                                      "- Less than 0.50",
                                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40,
                                                child: ToggleButtons(
                                                  onPressed: (int index) {
                                                    setState(() {
                                                      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                                        if (buttonIndex == index) {
                                                          isSelected[buttonIndex] = true;
                                                          // index 0 is Yes, index 1 is No.
                                                          if (index == 0) {
                                                            adjustedBill = roundBill(originalBill);
                                                            roundingAdjustment = double.parse((originalBill - adjustedBill).toStringAsFixed(2));
                                                            isRoundingApplied = true;
                                                          } else {
                                                            adjustedBill = originalBill;
                                                            roundingAdjustment = 0.0;
                                                            isRoundingApplied = false;
                                                          }
                                                          // Call _calculateChange after updating adjustedBill and isRoundingApplied
                                                          _calculateChange();
                                                        } else {
                                                          isSelected[buttonIndex] = false;
                                                        }
                                                      }
                                                    });
                                                  },
                                                  isSelected: isSelected,
                                                  fillColor: isSelected.contains(true) ? Colors.green : Colors.white,
                                                  selectedBorderColor: Colors.green,
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderWidth: 1.0,
                                                  borderColor: Colors.white,
                                                  children: const <Widget>[
                                                    Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
                                                    Text('No', style: TextStyle(fontSize: 14, color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Payment Method",
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
                                              selectedPaymentMethod == value ? Colors.green : Colors.white,
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
                                              widget.selectedOrder.paymentMethod = value;
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Please Enter the Amount Received",
                                          style: TextStyle(fontSize: 14, color: Colors.white),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: TextField(
                                            controller: _controller,
                                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2),
                                              hintStyle: const TextStyle(color: Colors.green),
                                              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: const OutlineInputBorder(),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _calculateChange();
                                                if (value.isEmpty) {
                                                  _controller.text = (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2);
                                                }
                                                _controller.selection = TextSelection.fromPosition(
                                                  TextPosition(offset: _controller.text.length),
                                                );
                                              });
                                            },
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
                                                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
                                                              ),
                                                              Text(
                                                                'Please confirm you’ve received the payment, either in cash or via a digital transaction like DuitNow, before pressing ‘Confirm’.',
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
                                                              onPressed: () {
                                                                try {
                                                                  setState(() {
                                                                    _calculateChange();
                                                                    widget.selectedOrder.totalPrice =
                                                                        double.parse((amountReceived - amountChanged).toStringAsFixed(2));
                                                                    widget.selectedOrder.amountReceived = amountReceived;
                                                                    widget.selectedOrder.amountChanged = amountChanged;
                                                                    widget.selectedOrder.roundingAdjustment = roundingAdjustment;
                                                                    widget.selectedOrder.paymentMethod = selectedPaymentMethod;
                                                                    widget.selectedOrder.status = 'Paid';
                                                                    widget.selectedOrder.cancelledTime = 'None';
                                                                    widget.selectedOrder.addPaymentDateTime();
                                                                    widget.updateOrderStatus!();
                                                                    widget.orders.addOrder(widget.selectedOrder.copyWith(categories));
                                                                    var emptyOrderNumber = '';
                                                                    widget.tables[widget.selectedTableIndex]['orderNumber'] = emptyOrderNumber;
                                                                    widget.tables[widget.selectedTableIndex]['occupied'] = false;
                                                                    widget.updateTables(widget.selectedTableIndex, emptyOrderNumber, false);
                                                                  });

                                                                  if (Hive.isBoxOpen('orders')) {
                                                                    var ordersBox = Hive.box('orders');
                                                                    ordersBox.put('orders', widget.orders);

                                                                    // Print the latest orders
                                                                    var latestOrders = ordersBox.get('orders') as Orders;
                                                                    for (var order in latestOrders.data) {
                                                                      log('Order Number from Payments: ${order.orderNumber}, Status: ${order.status}');
                                                                    }
                                                                  }
                                                                } catch (e) {
                                                                  log('An error occurred at MakePaymentPage: $e');
                                                                }
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
                                                                    'The payment for the table  ${widget.tables[widget.selectedTableIndex]['name']} has been successfully processed.',
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                      // color: Colors.black,
                                                                      // fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  toastPosition: Position.top,
                                                                  toastDuration: const Duration(milliseconds: 3000),
                                                                  animationType: AnimationType.fromTop,
                                                                  animationDuration: const Duration(milliseconds: 200),
                                                                  autoDismiss: true,
                                                                  displayCloseButton: false,
                                                                ).show(context);
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
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
