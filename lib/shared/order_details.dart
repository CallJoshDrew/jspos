import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jspos/models/selected_table_order.dart';
import 'package:jspos/shared/item.dart';

class OrderDetails extends StatefulWidget {
  final SelectedTableOrder selectedOrder;
  final void Function() updateOrderStatus;
  final Color orderStatusColor;
  final IconData orderStatusIcon;
  final String orderStatus;
  final VoidCallback? handleMethod;

  const OrderDetails({
    super.key,
    required this.selectedOrder,
    required this.updateOrderStatus,
    required this.orderStatusColor,
    required this.orderStatusIcon,
    required this.orderStatus,
    this.handleMethod,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _showEditBtn = false;
  void prettyPrintOrder() {
    print('Order Number: ${widget.selectedOrder.orderNumber}');
    print('Table Name: ${widget.selectedOrder.tableName}');
    print('Order Type: ${widget.selectedOrder.orderType}');
    print('Order Time: ${widget.selectedOrder.orderTime}');
    print('Order Date: ${widget.selectedOrder.orderDate}');
    print('Status: ${widget.selectedOrder.status}');
    print('-------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Column(
        children: [
          _orderNumber(
            title: widget.selectedOrder.orderNumber,
            status: widget.selectedOrder.status,
            timeStamp:
                (widget.selectedOrder.orderDate?.toString() ?? 'Order Time'),
            // timeStamp: '04:21 PM, Sun, Mar 31, 2024',
            action: Container(),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.selectedOrder.items.length,
              itemBuilder: (context, index) {
                final item = widget.selectedOrder.items[index];
                return _itemOrder(
                  image: item.image,
                  title: item.name,
                  item: item,
                  price: item.price,
                  index: index,
                );
              },
            ),
          ),
          // This is SubTotal and Total Container
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xff1f2029),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sub Total',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      widget.selectedOrder.subTotal.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      widget.selectedOrder.serviceCharge.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                // custom doted line.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final boxWidth = constraints.constrainWidth();
                      const dashWidth = 5.0;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(dashCount, (_) {
                          return Row(
                            children: <Widget>[
                              Container(
                                  width: dashWidth,
                                  height: 2,
                                  color: Colors.white),
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      widget.selectedOrder.totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: widget.orderStatusColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: widget.handleMethod,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.orderStatusIcon, size: 32),
                      // const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Text(
                          widget.orderStatus,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderNumber({
    required String title,
    required String status,
    required String timeStamp,
    required Widget action,
    // required ValueNotifier<bool> isVisible,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80, // Adjust this value as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 150),
                  // isVisible.value
                  _showEditBtn
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showEditBtn = false;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepOrange),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.0), // Adjust this value as needed
                              ),
                            ),
                          ),
                          child: const Text('Edit',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Container(),
                ],
              ),
              Row(
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: (timeStamp == 'Order Time') ? 150 : 40,
                  ),
                  Text(
                    timeStamp,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container(width: double.infinity)),
        Expanded(flex: 5, child: action),
      ],
    );
  }

  Widget _itemOrder({
    required String image,
    required String title,
    required Item item,
    required double price,
    required int index,
  }) {
    return Dismissible(
        // Each Dismissible must contain a Key. Keys allow Flutter to
        // uniquely identify widgets.
        key: Key(item.id.toString()),
        // Provide a function that tells the app
        // what to do after an item has been swiped away.
        onDismissed: (direction) {
          // Remove the item from the data source.
          setState(() {
            widget.selectedOrder.items.remove(item);
            widget.selectedOrder.updateTotalCost(0);
          });

          // Then show a snackbar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
              content: Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        // Show a red background as the item is swiped away.
        background: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 36,
                ),
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xff1f2029),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 24, // Adjust as needed
                    height: 24, // Adjust as needed
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          14), // Adjust for desired border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 4, // Shadow spread radius
                          blurRadius: 5, // Shadow blur radius
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            color: Color.fromRGBO(31, 32, 41, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Item Name and Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        item.selectedMeatPortion != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  item.selectedMeatPortion!['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        item.selectedMeePortion != null
                            ? Text(
                                item.selectedMeePortion!['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    // Text(
                    //   price.toStringAsFixed(2),
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // )
                  ],
                ),
              ),
              // Add, Decrease and Remove
              _showEditBtn
                  ? Text(
                      'x ${item.quantity}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                item.quantity++; // Increase the quantity
                              });

                              widget.selectedOrder.updateTotalCost(0);
                            },
                            child: const CircleAvatar(
                              radius:
                                  16, // Adjust this value to change the size of the CircleAvatar
                              backgroundColor: Color.fromRGBO(65, 175, 71, 1),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (item.quantity > 1) {
                                  item.quantity--; // Decrease the quantity of the item
                                  widget.selectedOrder.updateTotalCost(0);
                                }
                              });
                            },
                            child: const CircleAvatar(
                              radius:
                                  16, // Adjust this value to change the size of the CircleAvatar
                              backgroundColor: Color.fromRGBO(232, 134, 13, 1),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }
}
