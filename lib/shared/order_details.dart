import 'package:flutter/material.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';

class OrderDetails extends StatefulWidget {
  final SelectedOrder selectedOrder;
  final Color orderStatusColor;
  final IconData orderStatusIcon;
  final String orderStatus;
  final VoidCallback? handleMethod;
  final VoidCallback? handlefreezeMenu;
  final VoidCallback? updateOrderStatus;
  final Function(Item item) onItemAdded;

  const OrderDetails({
    super.key,
    required this.selectedOrder,
    required this.orderStatusColor,
    required this.orderStatusIcon,
    required this.orderStatus,
    this.handleMethod,
    this.handlefreezeMenu,
    this.updateOrderStatus,
    required this.onItemAdded,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool showEditBtn = false;
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
            showEditBtn: widget.selectedOrder.showEditBtn,
            timeStamp:
                (widget.selectedOrder.orderTime?.toString() ?? 'Order Time'),
            date: (widget.selectedOrder.orderDate?.toString() ?? 'Order Date'),
            // timeStamp: '04:21 PM, Sun, Mar 31, 2024',
            handlefreezeMenu: widget.handlefreezeMenu,
            updateOrderStatus: widget.updateOrderStatus,
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
                  name: item.name,
                  item: item,
                  price: item.price,
                  index: index,
                  category: item.category,
                  showEditBtn: widget.selectedOrder.showEditBtn,
                );
              },
            ),
          ),
          // SubTotal and Total Container
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
    required bool showEditBtn,
    required String timeStamp,
    required String date,
    required Widget action,
    VoidCallback? handlefreezeMenu,
    VoidCallback? updateOrderStatus,
    // required ValueNotifier<bool> isVisible,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              // show Edit Button when it is true
              showEditBtn
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.selectedOrder.updateShowEditBtn(false);
                        });
                        if (handlefreezeMenu != null) {
                          handlefreezeMenu();
                        }
                        if (updateOrderStatus != null) {
                          updateOrderStatus();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[800]!),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Adjust this value as needed
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Edit',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Icon(
                              Icons.assignment_add,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(height: 50.0),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "$timeStamp, $date",
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: Container(width: double.infinity)),
            Expanded(child: action),
          ],
        ),
      ],
    );
  }

  Widget _itemOrder({
    required String image,
    required String name,
    required Item item,
    required double price,
    required int index,
    required bool showEditBtn,
    required String category,
  }) {
    Widget child = Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xff1f2029),
      ),
      child: GestureDetector(
        onTap: () {
          Map<String, dynamic>? selectedChoice = item.selectedChoice;
          Map<String, dynamic>? selectedType = item.selectedType;
          Map<String, dynamic>? selectedMeatPortion = item.selectedMeatPortion;
          Map<String, dynamic>? selectedMeePortion = item.selectedMeePortion;
          double choicePrice = item.selectedChoice?['price'] ?? 0;
          double typePrice = item.selectedType?['price'] ?? 0;
          double meatPrice = item.selectedMeatPortion?['price'] ?? 0;
          double meePrice = item.selectedMeePortion?['price'] ?? 0;

          double totalPrice = choicePrice + typePrice + meatPrice + meePrice;

          void calculateTotalPrice(double choicePrice, double typePrice,
              double meatPrice, double meePrice) {
            setState(() {
              totalPrice = choicePrice + typePrice + meatPrice + meePrice;
              print('Price of Selected Choice: $choicePrice');
              print('Price of Selected Type: $typePrice');
              print('Price of Selected Meat: $meatPrice');
              print('Price of Selected Mee: $meePrice');
              print('Total Price: $totalPrice');
              print('-------------------------');
            });
          }

          if (!widget.selectedOrder.showEditBtn && item.selection) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.black,
                        shadowColor: Colors.black,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.deepOrange,
                              width: 2), // This is the border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1600,
                            minHeight: 800,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Column(
                                children: [
                                  // First row
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        height: 160,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.asset(
                                            item.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedChoice != null &&
                                                    selectedType != null
                                                ? '${selectedChoice!['name']} (${selectedType!['name']})'
                                                : 'Select Flavor and Type',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Text(
                                            'RM ${totalPrice.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Second row
                                  Row(
                                    children: [
                                      // selectedChoice
                                      Expanded(
                                        child: item.choices.isNotEmpty
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SimpleDialog(
                                                        title: const Text(
                                                            'Select Flavor'),
                                                        children: item.choices
                                                            .map<SimpleDialogOption>(
                                                                (choice) {
                                                          return SimpleDialogOption(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedChoice =
                                                                    choice;
                                                                item.selectedChoice =
                                                                    choice;
                                                                choicePrice =
                                                                    choice[
                                                                        'price'];
                                                              });
                                                              calculateTotalPrice(
                                                                  choicePrice,
                                                                  typePrice,
                                                                  meatPrice,
                                                                  meePrice);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              '${choice['name']} (RM ${choice['price'].toStringAsFixed(2)})',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // This is the border radius
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    '${selectedChoice!['name']} (RM ${selectedChoice!['price'].toStringAsFixed(2)})',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(), // Empty container if choices is empty
                                      ),
                                      const SizedBox(width: 10),
                                      // selectedType
                                      Expanded(
                                        child: item.types.isNotEmpty
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SimpleDialog(
                                                        title: const Text(
                                                            'Select Variation'),
                                                        children: item.types
                                                            .map<SimpleDialogOption>(
                                                                (type) {
                                                          return SimpleDialogOption(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedType =
                                                                    type;
                                                                item.selectedType =
                                                                    type;
                                                                typePrice = type[
                                                                    'price'];
                                                              });
                                                              calculateTotalPrice(
                                                                  choicePrice,
                                                                  typePrice,
                                                                  meatPrice,
                                                                  meePrice);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              '${type['name']} + RM ${type['price'].toStringAsFixed(2)}',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // This is the border radius
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    '${selectedType!['name']} + RM ${selectedType!['price'].toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(), // Empty container if types is empty
                                      ),
                                      const SizedBox(width: 10),
                                      // selectedMeat Portion
                                      Expanded(
                                        child: item.meatPortion.isNotEmpty
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SimpleDialog(
                                                        title: const Text(
                                                            'Select Meat Portion'),
                                                        children: item
                                                            .meatPortion
                                                            .map<SimpleDialogOption>(
                                                                (meatPortion) {
                                                          return SimpleDialogOption(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedMeatPortion =
                                                                    meatPortion;
                                                                item.selectedMeatPortion =
                                                                    meatPortion;
                                                                meatPrice =
                                                                    meatPortion[
                                                                        'price'];
                                                              });
                                                              calculateTotalPrice(
                                                                  choicePrice,
                                                                  typePrice,
                                                                  meatPrice,
                                                                  meePrice);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              '${meatPortion['name']} (RM ${meatPortion['price'].toStringAsFixed(2)})',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // This is the border radius
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    '${selectedMeatPortion!['name']} (RM ${selectedMeatPortion!['price'].toStringAsFixed(2)})',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(), // Empty container
                                      ),
                                      const SizedBox(width: 10),
                                      // selectedMee Portion
                                      Expanded(
                                        child: item.meePortion.isNotEmpty
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SimpleDialog(
                                                        title: const Text(
                                                            'Select Mee Portion'),
                                                        children: item
                                                            .meePortion
                                                            .map<SimpleDialogOption>(
                                                                (meePortion) {
                                                          return SimpleDialogOption(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedMeePortion =
                                                                    meePortion;
                                                                item.selectedMeePortion =
                                                                    meePortion;
                                                                meePrice =
                                                                    meePortion[
                                                                        'price'];
                                                              });
                                                              calculateTotalPrice(
                                                                  choicePrice,
                                                                  typePrice,
                                                                  meatPrice,
                                                                  meePrice);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              '${meePortion['name']} (RM ${meePortion['price'].toStringAsFixed(2)})',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // This is the border radius
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Text(
                                                    '${selectedMeePortion!['name']} (RM ${selectedMeePortion!['price'].toStringAsFixed(2)})',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(), // Empty container
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              widget.onItemAdded(item);
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // side: const BorderSide(color: Colors.deepOrange, width: 1),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                fontSize: 18,
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
                });
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                // Item Image and Index Number
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

                // Item Name and Price
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   width: 24,
                        //   height: 24,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(14),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.5),
                        //         spreadRadius: 2,
                        //         blurRadius: 7,
                        //         offset: const Offset(0, 3), // Shadow position
                        //       ),
                        //     ],
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       (index + 1).toString(),
                        //       style: const TextStyle(
                        //           color: Color.fromRGBO(31, 32, 41, 1),
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        Text(
                          item.selection ? "${index + 1}.${item.selectedChoice!['name']}" : '${index + 1}. $name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        item.selectedType != null && item.category == "Drinks"
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  item.selectedType!['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: item.selectedType!['name'] == 'Hot'
                                        ? Colors.orangeAccent
                                        : Colors.green[500],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        // Text(
                        //   'RM ${price.toStringAsFixed(2)}',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.green[300],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                // To Edit, Increase, Decrease and Remove item
                showEditBtn
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
                                  item.quantity++;
                                  widget.updateOrderStatus!();
                                  widget.selectedOrder.updateTotalCost(0);
                                });
                              },
                              child: CircleAvatar(
                                radius:
                                    16, // Adjust this value to change the size of the CircleAvatar
                                backgroundColor: Colors.green[700]!,
                                child: const Icon(
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
                                    item.quantity--;
                                    widget.updateOrderStatus!();
                                    widget.selectedOrder.updateTotalCost(0);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius:
                                    16, // Adjust this value to change the size of the CircleAvatar
                                backgroundColor: Colors.orange[800]!,
                                child: const Icon(
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
            Padding(
              padding:
                  EdgeInsets.only(top: item.category == "Dish" ? 15.0 : 0.0),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
    if (showEditBtn) {
      // If showEditBtn is true, return the child directly
      return child;
    } else {
      return Dismissible(
        // Each Dismissible must contain a Key. Keys allow Flutter to
        // uniquely identify widgets.
        key: Key(item.id.toString()),
        confirmDismiss: (direction) {
          if (showEditBtn) {
            // If showEditBtn is true, do not allow the dismiss action
            return Future.value(false);
          }
          // Otherwise, allow the dismiss action
          return Future.value(true);
        },
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
                      item.selection ? item.selectedChoice!['name'] : name,
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
        child: child,
      );
    }
  }
}
