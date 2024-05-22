import 'package:flutter/material.dart';
import 'package:jspos/models/selected_order.dart';

class MakePayment {
  final SelectedOrder selectedOrder;

  MakePayment({required this.selectedOrder});
}

class MakePaymentPage extends StatefulWidget {
  final MakePayment payment;

  const MakePaymentPage({super.key, required this.payment});

  @override
  MakePaymentPageState createState() => MakePaymentPageState();
}

class MakePaymentPageState extends State<MakePaymentPage> {
  String selectedPaymentMethod = "Cash";
  TextEditingController _controller = TextEditingController();
  double _change = 0.0;

  void _calculateChange() {
    double amountReceived = double.tryParse(_controller.text) ?? 0.0;
    _change = amountReceived - widget.payment.selectedOrder.totalPrice;
    if (_change < 0) _change = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              5), // This sets the border radius.// This sets the border color.
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: widget.payment.selectedOrder.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xff1f2029),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Item Image and Index Number
                                    Container(
                                      height: 90,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: AssetImage(widget
                                              .payment
                                              .selectedOrder
                                              .items[index]
                                              .image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Item Name and Price
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${index + 1}. ${widget.payment.selectedOrder.items[index].name} ( ${widget.payment.selectedOrder.items[index].price.toStringAsFixed(2)} )',
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                widget
                                                                .payment
                                                                .selectedOrder
                                                                .items[index]
                                                                .selectedType !=
                                                            null &&
                                                        widget
                                                                .payment
                                                                .selectedOrder
                                                                .items[index]
                                                                .category !=
                                                            "Cakes"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10.0),
                                                        child: Text(
                                                          "( ${widget.payment.selectedOrder.items[index].selectedType!['name']} )",
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: widget
                                                                        .payment
                                                                        .selectedOrder
                                                                        .items[
                                                                            index]
                                                                        .selectedType!['name'] ==
                                                                    'Cold'
                                                                ? Colors.green[500]
                                                                : Colors.orangeAccent,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: widget
                                                              .payment
                                                              .selectedOrder
                                                              .items[index]
                                                              .selection &&
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks !=
                                                              null &&
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks
                                                                  ?.isNotEmpty ==
                                                              true
                                                      ? 2.0
                                                      : 0.0,
                                                  left: widget
                                                              .payment
                                                              .selectedOrder
                                                              .items[index]
                                                              .selection &&
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks !=
                                                              null &&
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks
                                                                  ?.isNotEmpty ==
                                                              true
                                                      ? 2.0
                                                      : 0.0),
                                              child: Wrap(
                                                children: [
                                                  widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks !=
                                                              null &&
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks
                                                                  ?.isNotEmpty ==
                                                              true
                                                      ? Text(
                                                          widget
                                                                  .payment
                                                                  .selectedOrder
                                                                  .items[index]
                                                                  .itemRemarks
                                                                  ?.values
                                                                  .join(', ') ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .orangeAccent,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'x',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Container(
                                            width: 35, 
                                            height: 35, 
                                            decoration: const BoxDecoration(
                                              color: Colors.white, 
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${widget.payment.selectedOrder.items[index].quantity}', 
                                                style: const TextStyle(
                                                  color: Colors.black, 
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            (widget.payment.selectedOrder
                                                        .items[index].price *
                                                    widget.payment.selectedOrder
                                                        .items[index].quantity)
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xff1f2029),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.payment.selectedOrder.orderNumber,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.payment.selectedOrder.orderTime} -',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${widget.payment.selectedOrder.orderDate}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius here.
                            border: Border.all(),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Make sure to match this with the Container's border radius.
                            child: Table(
                              border: TableBorder.all(),
                              children: [
                                const TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.green),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            'Cakes',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            'Dish',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            'Drinks',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            '${widget.payment.selectedOrder.totalItems}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromRGBO(96, 89, 89, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            '${widget.payment.selectedOrder.totalQuantity}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromRGBO(96, 89, 89, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        child: Center(
                                          child: Text(
                                            selectedPaymentMethod,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromRGBO(96, 89, 89, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SubTotal, Service Charges & Total UI
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sub Total',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    widget.payment.selectedOrder.subTotal
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Service Charges',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    widget.payment.selectedOrder.serviceCharge
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Amount Received',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    _controller.text.isEmpty
                                        ? '0.00'
                                        : _controller.text,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Change',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    _change.toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              // custom doted line.
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 22),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    final boxWidth =
                                        constraints.constrainWidth();
                                    const dashWidth = 4.0;
                                    final dashCount =
                                        (boxWidth / (2 * dashWidth)).floor();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(dashCount, (_) {
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                                width: dashWidth,
                                                height: 2,
                                                color: Colors.black87),
                                            const SizedBox(width: dashWidth),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    widget.payment.selectedOrder.totalPrice
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        // Text('Discount: ${widget.payment.selectedOrder.discount}'),
                        // Text('Amount Received: ${widget.payment.selectedOrder.amountReceived}'),
                        const SizedBox(height: 40),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "Please Choose Payment Method",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10.0,
                          runSpacing: 10,
                          children: <String>[
                            'Cash',
                            'DuitNow',
                            'FoodPanda',
                            'GrabFood',
                            'ShopeeFood'
                          ].map((String value) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: selectedPaymentMethod == value
                                    ? Colors.white
                                    : Colors.black87,
                                backgroundColor: selectedPaymentMethod == value
                                    ? Colors.green
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedPaymentMethod = value;
                                  widget.payment.selectedOrder.paymentMethod =
                                      value;
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
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Please Enter the Received Amount",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    "Change: RM ${_change.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
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
                                borderRadius: BorderRadius.circular(
                                    10), // Set the border radius here.
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide:
                                    //       BorderSide(color: Colors.white),
                                    // ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _calculateChange();
                                      _controller.text = value;
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: _controller.text.length),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // This will space the buttons evenly in the row.
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .green, // This sets the background color.
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // This sets the border radius.
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Are you sure?'),
                                      actions: [
                                        TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.orange)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Confirm',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.orange)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // This sets the border radius.
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
            ],
          ),
        ),
      ),
    );
  }
}