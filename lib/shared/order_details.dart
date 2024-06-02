import 'dart:collection';
import 'dart:developer';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/data/remarks.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/data/menu_data.dart';

class OrderDetails extends StatefulWidget {
  final SelectedOrder selectedOrder;
  final Color orderStatusColor;
  final IconData orderStatusIcon;
  final String orderStatus;
  final VoidCallback? handleMethod;
  final VoidCallback? handlefreezeMenu;
  final VoidCallback? updateOrderStatus;
  final VoidCallback? resetSelectedTable;
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
    this.resetSelectedTable,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool showEditBtn = false;
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Create a map where each key is a category and the value is a list of items in that category
    Map<String, List<Item>> itemsByCategory = {};
    for (var item in widget.selectedOrder.items) {
      if (!itemsByCategory.containsKey(item.category)) {
        itemsByCategory[item.category] = [];
      }
      itemsByCategory[item.category]!.add(item);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderNumber(
          title: widget.selectedOrder.orderNumber,
          status: widget.selectedOrder.status,
          showEditBtn: widget.selectedOrder.showEditBtn,
          timeStamp: (widget.selectedOrder.orderTime?.toString() ?? 'Order Time'),
          date: (widget.selectedOrder.orderDate?.toString() ?? 'Order Date'),
          // timeStamp: '04:21 PM, Sun, Mar 31, 2024',
          handlefreezeMenu: widget.handlefreezeMenu,
          updateOrderStatus: widget.updateOrderStatus,
          action: Container(),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            child: ListView.builder(
              itemCount: itemsByCategory.keys.length,
              itemBuilder: (context, index) {
                String category = itemsByCategory.keys.elementAt(index);
                List<Item> items = itemsByCategory[category]!;
                // Categories Title before item image, name, quantity,
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                    // Category title
                    Column(
                      children: items
                          .map((item) => _itemOrder(
                                image: item.image,
                                name: item.name,
                                item: item,
                                price: item.price,
                                index: items.indexOf(item),
                                category: item.category,
                                showEditBtn: widget.selectedOrder.showEditBtn,
                              ))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Category, Items, Quantity UI
        Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff1f2029),
            border: Border.all(
              color: Colors.white10,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: categories.map((category) {
                    return Column(
                      children: [
                        Text(
                          '$category: ${widget.selectedOrder.categories[category]?['itemQuantity'].toString()}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: widget.orderStatusColor,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: widget.handleMethod,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.orderStatusIcon, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      widget.orderStatus,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff1f2029),
        border: Border.all(
          color: Colors.white10,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order Number
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: const TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        "$timeStamp, $date",
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  // Cancel and Remove and Delete Selected Order
                  (!showEditBtn && widget.selectedOrder.status != "Start Your Order" && widget.selectedOrder.status != "Ordering")
                      ? Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                              icon: const Icon(Icons.delete_forever, size: 20),
                              color: Colors.redAccent,
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
                                            maxWidth: 400,
                                            maxHeight: 100,
                                          ),
                                          child: const Wrap(
                                            alignment : WrapAlignment.center,
                                            children: [
                                              Text(
                                                'Are you sure?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                'Please note, once cancelled, the action is irreversible.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18, color: Colors.white),
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
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    widget.resetSelectedTable?.call();
                                                    if (Hive.isBoxOpen('orders')) {
                                                      var ordersBox = Hive.box('orders');
                                                      var orders = ordersBox.get('orders') as Orders;

                                                      // Print the orderNumber of widget.selectedOrder
                                                      // log('Order number to delete: ${widget.selectedOrder.orderNumber}');

                                                      // // log the orderNumber of all orders in orders.data
                                                      // for (var order in orders.data) {
                                                      //   log('Order number in list: ${order.orderNumber}');
                                                      // }

                                                      // Find the index of the order to delete
                                                      int indexToDelete =
                                                          orders.data.indexWhere((order) => order.orderNumber == widget.selectedOrder.orderNumber);

                                                      // Check if the order was found
                                                      if (indexToDelete != -1) {
                                                        // Remove the order from the list
                                                        orders.data.removeAt(indexToDelete);
                                                        // log('order was found: $indexToDelete');

                                                        // Put the updated list back into the box
                                                        ordersBox.put('orders', orders);
                                                      } else {
                                                        log('order was not found');
                                                      }
                                                      // var updatedOrders = ordersBox.get('orders') as Orders;
                                                      // log('Updated orders: $updatedOrders');
                                                    }
                                                    setState(() {
                                                      widget.selectedOrder.resetDefault();
                                                      if (handlefreezeMenu != null) {
                                                        handlefreezeMenu();
                                                      }
                                                      if (updateOrderStatus != null) {
                                                        updateOrderStatus();
                                                      }
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 14)),
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
                              }),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              // show Edit Button when it is true
              (showEditBtn && widget.selectedOrder.status != "Paid")
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
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Edit', style: TextStyle(fontSize: 14, color: Colors.white)),
                          SizedBox(width: 6),
                          Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(width: double.infinity)),
              Expanded(child: action),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff1f2029),
      ),
      child: GestureDetector(
        onTap: () {
          itemRemarks = Map<String, dynamic>.from(item.itemRemarks ?? {});
          // print('item.itemRemarks is: ${item.itemRemarks}');
          Map<String, dynamic>? selectedChoice = item.selectedChoice;
          Map<String, dynamic>? selectedType = item.selectedType;
          Map<String, dynamic>? selectedMeatPortion = item.selectedMeatPortion;
          Map<String, dynamic>? selectedMeePortion = item.selectedMeePortion;

          // these are ui display only, not yet saved into item.price
          double choicePrice = item.selectedChoice?['price'] ?? 0;
          double typePrice = item.selectedType?['price'] ?? 0;
          double meatPrice = item.selectedMeatPortion?['price'] ?? 0;
          double meePrice = item.selectedMeePortion?['price'] ?? 0;

          double subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;

          void calculateTotalPrice(double choicePrice, double typePrice, double meatPrice, double meePrice) {
            setState(() {
              subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;
              item.price = subTotalPrice;
            });
          }

          String? comment = item.itemRemarks != null ? item.itemRemarks!['100'] : null;
          _controller.text = comment ?? '';
          void updateItemRemarks() {
            if (selectedMeePortion != null && selectedMeatPortion != null) {
              Map<String, Map<dynamic, dynamic>> portions = {
                '98': {'portion': selectedMeePortion ?? {}, 'normalName': "Normal Mee"},
                '99': {'portion': selectedMeatPortion ?? {}, 'normalName': "Normal Meat"}
              };

              portions.forEach((key, value) {
                Map<dynamic, dynamic> portion = value['portion'];
                String normalName = value['normalName'];

                if (itemRemarks.containsKey(key)) {
                  if (portion['name'] != normalName) {
                    itemRemarks[key] = portion['name'];
                  } else {
                    itemRemarks.remove(key);
                  }
                } else if (portion['name'] != normalName) {
                  itemRemarks[key] = portion['name'];
                }
              });
            }

            String? newComment = _controller.text.trim();
            if (item.itemRemarks != {} && comment != null && newComment != '') {
              itemRemarks['100'] = newComment;
            }

            SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
              (a, b) => int.parse(a).compareTo(int.parse(b)),
            )..addAll(itemRemarks);

            // Check if itemRemarks has actually changed before updating item.itemRemarks
            if (item.itemRemarks.toString() != sortedItemRemarks.toString()) {
              item.itemRemarks = sortedItemRemarks;
            }
          }

          // remarkButton Widget
          Widget remarkButton(Map<String, dynamic> data) {
            return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    // Check if the remark has been added to itemRemarks
                    if (itemRemarks.containsKey(data['id'].toString())) {
                      // If the button is pressed or the remark has been added, make the background green
                      return states.contains(MaterialState.pressed) ? Colors.green[700]! : Colors.green;
                    } else {
                      // If the button is pressed or the remark has not been added, make the background black
                      return states.contains(MaterialState.pressed) ? Colors.green : Colors.black;
                    }
                  },
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                side: MaterialStateProperty.all(const BorderSide(color: Colors.white)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 6, 10, 6)), //
              ),
              onPressed: () {
                setState(() {
                  String key = data['id'].toString();
                  if (itemRemarks.containsKey(key)) {
                    // If the remark is already in itemRemarks, remove it
                    itemRemarks.remove(key);
                  } else {
                    // If the remark is not in itemRemarks, add it
                    itemRemarks[key] = data['remarks'];
                  }
                  // print('itemRemarks selection:$itemRemarks');
                  // print('item.itemRemarks:${item.itemRemarks}');
                });
              },
              child: Text(
                data['remarks'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          // This is the selection process for item.selection is true
          if (!widget.selectedOrder.showEditBtn && item.selection) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var screenSize = MediaQuery.of(context).size; // Get the screen size
                  var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Scaffold(
                        body: Dialog(
                          insetPadding: EdgeInsets.zero, // Make dialog full-screen
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: screenSize.width,
                            height: screenSize.height - statusBarHeight,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    // Item Image, Name, Price
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xff1f2029),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            height: 110,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              child: Image.asset(
                                                item.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //Item Heading Title
                                              // Text(
                                              //   '${item.category}:  ${item.originalName}',
                                              //   textAlign: TextAlign.center,
                                              //   style: const TextStyle(fontSize: 14, color: Colors.white),
                                              // ),
                                              item.selection && selectedChoice != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          selectedChoice != null ? '${selectedChoice!['name']}' : 'Select Flavor and Type',
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Text(
                                                          "( ${selectedChoice!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color.fromARGB(255, 114, 226, 118),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  item.selection && selectedType != null
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedType!['name']} ",
                                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                                            ),
                                                            Text(
                                                              "( + ${selectedType!['price'].toStringAsFixed(2)} )",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Color.fromARGB(255, 114, 226, 118),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                  item.selection && selectedMeePortion != null
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedMeePortion!['name']} ",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              "( + ${selectedMeePortion!['price'].toStringAsFixed(2)} )",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Color.fromARGB(255, 114, 226, 118),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                  item.selection && selectedMeatPortion != null
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedMeatPortion!['name']} ",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              "( + ${selectedMeatPortion!['price'].toStringAsFixed(2)} )",
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
                                            ],
                                          ),
                                          Expanded(
                                            child: Text('RM ${subTotalPrice.toStringAsFixed(2)}',
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // First Row for selection of Choices & Types
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 1.selectedChoice
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029),
                                              borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (item.choices.isNotEmpty) ...[
                                                  const Text(
                                                    '1.Select Your Flavor',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: item.choices.map((choice) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedChoice = choice;
                                                            choicePrice = choice['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                            selectedChoice == choice ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${choice['name']}',
                                                          style: TextStyle(
                                                            color: selectedChoice == choice
                                                                ? Colors.white
                                                                : Colors.black, // Change the text color based on the selected button
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ] else ...[
                                                  const SizedBox.shrink(),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (item.types.isNotEmpty) const SizedBox(width: 10),
                                        // 2.selectedType
                                        if (item.types.isNotEmpty) ...[
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "2.Select Your Preference",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: item.types.map((type) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedType = type;
                                                            typePrice = type['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                            selectedType == type ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${type['name']}',
                                                          style: TextStyle(
                                                            color: selectedType == type
                                                                ? Colors.white
                                                                : Colors.black, // Change the text color based on the selected button
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox.shrink(),
                                        ],
                                      ],
                                    ),
                                    // Second Row for selection of Mee & Meat Portions
                                    Row(
                                      children: [
                                        if (item.meePortion.isNotEmpty) ...[
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    '3.Select Your Desired Serving Size',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: item.meePortion.map((meePortion) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMeePortion = meePortion;
                                                            meePrice = meePortion['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                            selectedMeePortion == meePortion ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${meePortion['name']}',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: selectedMeePortion == meePortion
                                                                ? Colors.white
                                                                : Colors.black, // Change the text color based on the selected button
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox.shrink(),
                                        ],
                                        if (item.meatPortion.isNotEmpty) const SizedBox(width: 10),
                                        if (item.meatPortion.isNotEmpty) ...[
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    '4.Select Your Meat Portion Level',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: item.meatPortion.map((meatPortion) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMeatPortion = meatPortion;
                                                            meatPrice = meatPortion['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(
                                                            selectedMeatPortion == meatPortion ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${meatPortion['name']}',
                                                          style: TextStyle(
                                                            color: selectedMeatPortion == meatPortion
                                                                ? Colors.white
                                                                : Colors.black, // Change the text color based on the selected button
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox.shrink(),
                                        ],
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029),
                                              borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // First row
                                                const Text(
                                                  'Press Buttons to add Remarks',
                                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                                ),
                                                // remarks buttons
                                                Wrap(
                                                  spacing: 6.0, // gap between adjacent chips
                                                  runSpacing: 0, // gap between lines
                                                  children: remarksData
                                                      .where((data) => data['category'] == item.category) // Filter remarksData based on item.category
                                                      .map((data) => remarkButton(data))
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029),
                                              borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Please write additional remarks here',
                                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                                ),
                                                const SizedBox(height: 3),
                                                SizedBox(
                                                  height: 45,
                                                  child: TextField(
                                                    controller: _controller,
                                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.all(10),
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      border: OutlineInputBorder(),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey),
                                                      ),
                                                    ),
                                                    onChanged: (text) {
                                                      // This callback is called each time the text changes
                                                      setState(() {
                                                        if (text.isEmpty) {
                                                          // If the text is empty, remove the key '100' from itemRemarks
                                                          itemRemarks.remove('100');
                                                        } else {
                                                          // Add the user's comment with a key of '100'
                                                          itemRemarks['100'] = text;
                                                        }
                                                        SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
                                                          (a, b) => int.parse(a).compareTo(int.parse(b)),
                                                        )..addAll(itemRemarks);
                                                        itemRemarks = sortedItemRemarks;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
                                            ),
                                            child: const Text(
                                              'Confirm',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            // SubTotal, Service Charges Total OnPressed Function
                                            onPressed: () {
                                              setState(() {
                                                item.selectedChoice = selectedChoice;
                                                item.name = selectedChoice!['name'];
                                                item.selectedType = selectedType;
                                                item.selectedMeatPortion = selectedMeatPortion;
                                                item.selectedMeePortion = selectedMeePortion;

                                                updateItemRemarks();

                                                calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                item.price = subTotalPrice;
                                                widget.selectedOrder.updateTotalCost(0);
                                                widget.updateOrderStatus!();
                                                widget.selectedOrder.addItem(item);
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            onPressed: () {
                                              itemRemarks = {};
                                              _controller.text = '';
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Item Image and Index Number
                Container(
                  height: 35,
                  width: 35,
                  margin: const EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name and Price
                        Text(
                          '${index + 1}. $name',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Wrap(
                          children: [
                            item.selection == true && item.selectedType != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      "( ${item.selectedType!['name']} )",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: item.selectedType!['name'] == 'Cold' ? Colors.green[500] : Colors.orangeAccent,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            // Item Remarks & Comments UI
                            item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true
                                ? Text(
                                    item.itemRemarks?.values.join(', ') ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),

                        // Showing the Item Price UI
                        // Text(
                        //   'RM ${price.toStringAsFixed(2)}',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,ß
                        //     color: Colors.green[300],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                showEditBtn
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'x ${item.quantity}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  item.quantity++;
                                  widget.selectedOrder.updateTotalCost(0);
                                  widget.selectedOrder.calculateItemsAndQuantities();
                                  widget.updateOrderStatus!();
                                });
                                CherryToast(
                                  icon: Icons.check_circle,
                                  iconColor: Colors.green,
                                  themeColor: const Color.fromRGBO(46, 125, 50, 1),
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    '${item.name} (RM ${item.price.toStringAsFixed(2)})',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  toastPosition: Position.top,
                                  toastDuration: const Duration(milliseconds: 1000),
                                  animationType: AnimationType.fromTop,
                                  animationDuration: const Duration(milliseconds: 200),
                                  autoDismiss: true,
                                  displayCloseButton: false,
                                ).show(context);
                              },
                              child: Container(
                                width: 20, // Adjust this value to change the width of the rectangle
                                height: 20, // Adjust this value to change the height of the rectangle
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(5), // Adjust this value to change the roundness of the rectangle corners
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                    widget.selectedOrder.updateTotalCost(0);
                                    widget.selectedOrder.calculateItemsAndQuantities();
                                    widget.updateOrderStatus!();
                                    CherryToast(
                                      icon: Icons.cancel,
                                      iconColor: Colors.red,
                                      themeColor: Colors.red,
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        '${item.name} (RM ${price.toStringAsFixed(2)})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      toastPosition: Position.top,
                                      toastDuration: const Duration(milliseconds: 1000),
                                      animationType: AnimationType.fromTop,
                                      animationDuration: const Duration(milliseconds: 200),
                                      autoDismiss: true,
                                      displayCloseButton: false,
                                    ).show(context);
                                  } else if (item.quantity == 1) {
                                    CherryToast(
                                      icon: Icons.info,
                                      iconColor: Colors.green,
                                      themeColor: Colors.green,
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "Swipe left/right to remove the item",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      toastPosition: Position.top,
                                      toastDuration: const Duration(milliseconds: 1000),
                                      animationType: AnimationType.fromTop,
                                      animationDuration: const Duration(milliseconds: 200),
                                      autoDismiss: true,
                                      displayCloseButton: false,
                                    ).show(context);
                                  }
                                });
                              },
                              child: Container(
                                width: 20, // Adjust this value to change the width of the rectangle
                                height: 20, // Adjust this value to change the height of the rectangle
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(239, 108, 0, 1),
                                  borderRadius: BorderRadius.circular(5), // Adjust this value to change the roundness of the rectangle corners
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
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
            widget.selectedOrder.calculateItemsAndQuantities();
            widget.updateOrderStatus!();
          });

          // Then show a notifications
          CherryToast(
            icon: Icons.cancel,
            iconColor: Colors.red,
            themeColor: Colors.red,
            backgroundColor: Colors.white,
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            toastPosition: Position.top,
            animationType: AnimationType.fromTop,
            animationDuration: const Duration(milliseconds: 200),
            autoDismiss: true,
          ).show(context);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.red,
          //     duration: const Duration(milliseconds: 300),
          //     content: Container(
          //       alignment: Alignment.centerRight,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           const Icon(
          //             Icons.cancel,
          //             color: Colors.white,
          //             size: 20,
          //           ),
          //           const SizedBox(width: 5),
          //           Text(
          //             name,
          //             style: const TextStyle(
          //               fontSize: 14,
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
        // Show a red background as the item is swiped away.
        background: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 14,
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

// if (item.selectedMeatPortion != null && item.selectedMeatPortion!['name'] != "Normal Meat")
//   Row(
//     children: [
//       Container(
//         padding: EdgeInsets.only(
//             left: item.selection && item.selectedMeatPortion != null ? 16.0 : 0.0,
//             top: item.selection && item.selectedMeatPortion != null ? 8.0 : 0.0,
//             right: item.selection && item.selectedMeatPortion != null ? 16.0 : 0.0,
//             bottom: item.selection && item.selectedMeatPortion != null ? 8.0 : 0.0),
//         margin: EdgeInsets.only(top: item.selection && item.selectedMeatPortion != null ? 12.0 : 0.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           // color: Colors.white,
//         ),
//         child: Text(
//           "${item.selectedMeatPortion!['name']}",
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       const SizedBox(width: 10),
//       // Text for selectedMeePortion
//       if (item.selectedMeePortion != null && item.selectedMeePortion!['name'] != "Normal Mee")
//         Container(
//           padding: EdgeInsets.only(
//               left: item.selection && item.selectedMeePortion != null ? 16.0 : 0.0,
//               top: item.selection && item.selectedMeePortion != null ? 10.0 : 0.0,
//               right: item.selection && item.selectedMeatPortion != null ? 16.0 : 0.0,
//               bottom: item.selection && item.selectedMeatPortion != null ? 8.0 : 0.0),
//           margin: EdgeInsets.only(top: item.selection && item.selectedMeePortion != null ? 12.0 : 0.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             // color: Colors.white,
//           ),
//           child: Text(
//             "${item.selectedMeePortion!['name']}",
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//     ],
//   ),