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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
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
                                                  '${index + 1}. ${widget.payment.selectedOrder.items[index].name}',
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
                                                      ? 10.0
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
                                              child: Row(
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
                                          Text(
                                            '${widget.payment.selectedOrder.items[index].quantity} ',
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
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'RM ${widget.payment.selectedOrder.items[index].price.toStringAsFixed(2)}',
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
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  margin: const EdgeInsets.only(top: 25),
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
                                decoration: BoxDecoration(color: Colors.green),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          'Cakes',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          'Dish',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          'Drinks',
                                          style: TextStyle(
                                            fontSize: 24,
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
                                          top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          '${widget.payment.selectedOrder.totalItems}',
                                          style: const TextStyle(
                                            fontSize: 24,
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
                                          top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          '${widget.payment.selectedOrder.totalQuantity}',
                                          style: const TextStyle(
                                            fontSize: 24,
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
                                          top: 16, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          selectedPaymentMethod,
                                          style: const TextStyle(
                                            fontSize: 24,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            // custom doted line.
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 22),
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  final boxWidth = constraints.constrainWidth();
                                  const dashWidth = 4.0;
                                  final dashCount =
                                      (boxWidth / (2 * dashWidth)).floor();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      // Text('Discount: ${widget.payment.selectedOrder.discount}'),
                      // Text('Amount Received: ${widget.payment.selectedOrder.amountReceived}'),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Please Choose Payment Method",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                                widget.payment.selectedOrder.paymentMethod = value; 
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
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    child: Text('Confirm',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.orange)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Cancel',
                                        style: TextStyle(color: Colors.orange)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
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
