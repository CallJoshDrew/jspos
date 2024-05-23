import 'package:flutter/material.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/selected_order.dart';

class MakePaymentPage extends StatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback? updateOrderStatus;

  const MakePaymentPage({super.key, required this.selectedOrder, required this.updateOrderStatus});

  @override
  MakePaymentPageState createState() => MakePaymentPageState();
}

class MakePaymentPageState extends State<MakePaymentPage> {
  String selectedPaymentMethod = "Cash";
  final TextEditingController _controller = TextEditingController();
  double _change = 0.0;
  late double originalBill; // Declare originalBill
  late double adjustedBill;
  bool isRoundingApplied = false;
  List<bool> isSelected = [false, true];

  void _calculateChange() {
    double amountReceived = double.tryParse(_controller.text) ?? 0.0;
    _change = amountReceived - widget.selectedOrder.totalPrice;
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
        insetPadding: EdgeInsets.zero, // Remove any padding
        child: SizedBox(
          width: screenSize.width, // Set width to screen width
          height: screenSize.height - statusBarHeight, // Subtract the status bar height from the screen height
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedOrder.orderNumber,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Verifying Bill before Payment Transaction',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.selectedOrder.orderTime} -',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.selectedOrder.orderDate}',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
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
                                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
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
                                                                          "${index + 1}.${item.selectedChoice!['name']} ",
                                                                          style: const TextStyle(
                                                                            fontSize: 22,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "( ${item.selectedChoice!['price'].toStringAsFixed(2)} ) ",
                                                                          style: const TextStyle(
                                                                            fontSize: 22,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      '${index + 1}. ${item.name} ( ${item.price.toStringAsFixed(2)} )',
                                                                      style: const TextStyle(
                                                                        fontSize: 22,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                              const SizedBox(width: 10.0),
                                                              Text(
                                                                'x ${item.quantity}',
                                                                style: const TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 10),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 20),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                item.selection && item.selectedType != null
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedType!['name']} ",
                                                                            style: const TextStyle(fontSize: 22, color: Colors.white),
                                                                          ),
                                                                          Text(
                                                                            "( + ${item.selectedType!['price'].toStringAsFixed(2)} )",
                                                                            style: const TextStyle(
                                                                              fontSize: 22,
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
                                                                              fontSize: 22,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "( + ${item.selectedMeePortion!['price'].toStringAsFixed(2)} )",
                                                                            style: const TextStyle(
                                                                              fontSize: 22,
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
                                                                              fontSize: 22,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "( + ${item.selectedMeatPortion!['price'].toStringAsFixed(2)} )",
                                                                            style: const TextStyle(
                                                                              fontSize: 22,
                                                                              color: Color.fromARGB(255, 114, 226, 118),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                const SizedBox(height: 4),
                                                                Wrap(
                                                                  children: [
                                                                    item.selection &&
                                                                            item.selectedMeatPortion != null &&
                                                                            filterRemarks(item.itemRemarks).isNotEmpty == true
                                                                        ? Row(
                                                                            children: [
                                                                              const Text(
                                                                                'Remarks: ',
                                                                                style: TextStyle(
                                                                                  fontSize: 22,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                getFilteredRemarks(item.itemRemarks),
                                                                                style: const TextStyle(
                                                                                  fontSize: 22,
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
                                                    (item.price * item.quantity).toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      fontSize: 22,
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
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xff1f2029),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Sub Total',
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          widget.selectedOrder.subTotal.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Service Charges',
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          widget.selectedOrder.serviceCharge.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    (fractionAmount < 0.50) ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Rounding Adjustment',
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          '- ${(originalBill - adjustedBill).toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ): const SizedBox.shrink(),
                                    // custom doted line.
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 22),
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
                                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          (isRoundingApplied ? adjustedBill : originalBill).toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    // custom doted line.
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 22),
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
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          _controller.text.isEmpty ? '0.00' : _controller.text,
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Amount Change',
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        Text(
                                          '- ${_change.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (fractionAmount < 0.50) ? Row(
                                      children: [
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Allow Rounding Adjustment?",
                                                style: TextStyle(fontSize: 24, color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                "- Less than 0.50",
                                                style: TextStyle(fontSize: 20, color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ToggleButtons(
                                          onPressed: (int index) {
                                            setState(() {
                                              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                                if (buttonIndex == index) {
                                                  isSelected[buttonIndex] = true;
                                                  if (index == 0) {
                                                    adjustedBill = roundBill(originalBill);
                                                    isRoundingApplied = true;
                                                  } else {
                                                    adjustedBill = originalBill;
                                                    isRoundingApplied = false;
                                                  }
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
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(30, 6, 30, 6),
                                              child: Text('Yes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(30, 6, 30, 6),
                                              child: Text('No', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )  : const SizedBox.shrink(),
                                    const SizedBox(height: 20),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Payment Method",
                                        style: TextStyle(fontSize: 24, color: Colors.white),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 10.0,
                                      runSpacing: 10,
                                      children: <String>['Cash', 'DuitNow', 'FoodPanda', 'GrabFood', 'ShopeeFood'].map((String value) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: selectedPaymentMethod == value ? Colors.white : Colors.black87,
                                            backgroundColor: selectedPaymentMethod == value ? Colors.green : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedPaymentMethod = value;
                                              widget.selectedOrder.paymentMethod = value;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Please Enter the Amount Received",
                                          style: TextStyle(fontSize: 24, color: Colors.white),
                                          textAlign: TextAlign.start,
                                        ),
                                        Container(
                                          width: 200,
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(10), // Set the border radius here.
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller: _controller,
                                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _calculateChange();
                                                  _controller.text = value;
                                                  _controller.selection = TextSelection.fromPosition(
                                                    TextPosition(offset: _controller.text.length),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end, // This will space the buttons evenly in the row.
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green, // This sets the background color.
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // This sets the border radius.
                                            ),
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
                                                      side: const BorderSide(color: Colors.green, width: 2), // This is the border color
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    content: ConstrainedBox(
                                                      constraints: const BoxConstraints(
                                                        minWidth: 300,
                                                        minHeight: 70,
                                                      ),
                                                      child: const Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Are you sure?',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10, left: 40, right: 40),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            TextButton(
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {

                                                                Navigator.of(context).pop();
                                                              },
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(6.0),
                                                                child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 24)),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 30),
                                                            TextButton(
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(6.0),
                                                                child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 24)),
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
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(fontSize: 24, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // This sets the border radius.
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(fontSize: 24, color: Colors.black),
                                            ),
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
