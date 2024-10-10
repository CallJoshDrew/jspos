import 'dart:collection';
import 'dart:developer';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jspos/data/remarks.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/data/menu1_data.dart';

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
  final List<Item> tempCartItems;
  final bool Function(List<Item> list1, List<Item> list2) areItemListsEqual;

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
    required this.tempCartItems,
    required this.areItemListsEqual,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool showEditBtn = false;
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();
  String? comment;
  void updateItemRemarks({
    required dynamic selectedMeePortion,
    required dynamic selectedMeatPortion,
    required dynamic item,
  }) {
    Map<String, dynamic> itemRemarks = Map<String, dynamic>.from(item.itemRemarks ?? {});

    if (selectedMeePortion != null && selectedMeatPortion != null) {
      Map<String, Map<dynamic, dynamic>> portions = {
        '98': {'portion': selectedMeePortion, 'normalName': "Normal Mee"},
        '99': {'portion': selectedMeatPortion, 'normalName': "Normal Meat"}
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

    // Add or remove "Tapao"
    if (itemRemarks.containsKey('101')) {
      itemRemarks.remove('101'); // Remove Tapao
      log("Removed Tapao from item remarks.");
    } else {
      itemRemarks['101'] = 'Tapao'; // Add Tapao
      log("Added Tapao to item remarks.");
    }

    // Ensure consistent empty map handling
    if (itemRemarks.isEmpty) {
      itemRemarks = {};
    }

    log("Final item remarks: $itemRemarks");

    // Handle comment updates
    String? newComment = _controller.text.trim();
    if (newComment.isNotEmpty) {
      itemRemarks['100'] = newComment; // Add or update comment
    }

    // Sort the remarks
    SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
      (a, b) => int.parse(a).compareTo(int.parse(b)),
    )..addAll(itemRemarks);

    // Update the item if remarks changed
    if (item.itemRemarks.toString() != sortedItemRemarks.toString()) {
      item.itemRemarks = sortedItemRemarks;
    }

    log("Final sorted item remarks: $sortedItemRemarks");

    // Ensure `updateOrderStatus` is called after updating item remarks
    widget.updateOrderStatus!(); // Call updateOrderStatus to refresh UI

    // Trigger UI updates
    bool areItemsEqual = widget.areItemListsEqual(widget.tempCartItems, widget.selectedOrder.items);
    log("Are item lists equal? $areItemsEqual");

    setState(() {
      // Call setState to trigger UI update after remarks change
    });
  }

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
          timeStamp: (widget.selectedOrder.orderTime.toString()),
          date: (widget.selectedOrder.orderDate.toString()),
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
                            style: TextStyle(color: status == "Cancelled" ? Colors.red : Colors.green, fontSize: 16),
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
                                            alignment: WrapAlignment.center,
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
                                                    widget.resetSelectedTable?.call();
                                                    if (Hive.isBoxOpen('orders')) {
                                                      var ordersBox = Hive.box('orders');
                                                      var orders = ordersBox.get('orders') as Orders;

                                                      // Find the index of the order to update
                                                      int indexToUpdate =
                                                          orders.data.indexWhere((order) => order.orderNumber == widget.selectedOrder.orderNumber);

                                                      // Check if the order was found
                                                      if (indexToUpdate != -1) {
                                                        // Create a copy of the selectedOrder
                                                        var orderCopy = widget.selectedOrder.copyWith(categories);
                                                        String addCancelDateTime() {
                                                          DateTime now = DateTime.now();
                                                          return DateFormat('h:mm a, d MMMM yyyy').format(now); // Outputs: 1:03 AM, 5 May 2024
                                                        }

                                                        orderCopy.status = "Cancelled";
                                                        // Set orderCopy.cancelTime using the addCancelDateTime method
                                                        orderCopy.cancelledTime = addCancelDateTime();
                                                        orderCopy.paymentTime = "None";
                                                        orderCopy.paymentMethod = "None";
                                                        // Update the order in the list
                                                        orders.data[indexToUpdate] = orderCopy;
                                                        log('order was found: $indexToUpdate');

                                                        // Put the updated list back into the box
                                                        ordersBox.put('orders', orders);
                                                      } else {
                                                        log('order was not found');
                                                      }
                                                      log('order from order Details page: $orders');
                                                    }
                                                    setState(() {
                                                      widget.selectedOrder.handleCancelOrder();
                                                      if (handlefreezeMenu != null) {
                                                        handlefreezeMenu();
                                                      }
                                                      if (updateOrderStatus != null) {
                                                        updateOrderStatus();
                                                      }
                                                    });
                                                    CherryToast(
                                                      icon: Icons.cancel,
                                                      iconColor: Colors.red,
                                                      themeColor: Colors.red,
                                                      backgroundColor: Colors.white,
                                                      title: const Text(
                                                        'The order has being cancelled!',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
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
                                                  },
                                                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                              }),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              // show Edit Button when it is true
              showEditBtn && (widget.selectedOrder.status != "Paid" && widget.selectedOrder.status != "Cancelled")
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.selectedOrder.updateShowEditBtn(false);
                          // log('Order Details Start Page: --------------------------');
                          // log('selectedOrder.status: ${widget.selectedOrder.status}');
                          // log('selectedChoice from Order Details: ${widget.selectedOrder.items}');
                          // log('tempCartItems after: ${widget.tempCartItems}');
                          // log('Order Details End Page: --------------------------');
                        });
                        if (handlefreezeMenu != null) {
                          handlefreezeMenu();
                        }
                        if (updateOrderStatus != null) {
                          updateOrderStatus();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
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
                  : const SizedBox(height: 50),
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
          Map<String, dynamic>? selectedDrink = item.selectedDrink;
          Map<String, String>? selectedTemp = item.selectedTemp;
          log('selected Drink is :$selectedDrink');
          log('selected temp is :${item.selectedTemp}');
          Map<String, dynamic>? selectedChoice = item.selectedChoice;
          Map<String, dynamic>? selectedNoodlesType = item.selectedNoodlesType;
          Map<String, dynamic>? selectedMeatPortion = item.selectedMeatPortion;
          Map<String, dynamic>? selectedMeePortion = item.selectedMeePortion;
          Set<Map<String, dynamic>> selectedSide = Set<Map<String, dynamic>>.from(item.selectedSide ?? {});
          // The Map elements in selectedSide and item.selectedSide are the same Map objects.
          // even though selectedSide and item.selectedSide are separate Set objects.

          double drinkPrice() {
            final selectedTempName = selectedTemp?['name'] ?? ''; // Convert to non-nullable String
            final price = (selectedDrink?[selectedTempName] as double?) ?? 0.00;
            return price; // Get the price based on the selected temperature
          }
          // final priceResult = drinkPrice();
          // log('Drink Price is :${priceResult.toStringAsFixed(2)}');

          // these are ui display only, not yet saved into item.price
          double choicePrice = item.selectedChoice?['price'] ?? 0;
          double noodlesTypePrice = item.selectedNoodlesType?['price'] ?? 0;
          double meatPrice = item.selectedMeatPortion?['price'] ?? 0;
          double meePrice = item.selectedMeePortion?['price'] ?? 0;
          // double sidesPrice = item.sides.isNotEmpty && item.sides[0]['price'] != null ? item.sides[0]['price']! : 0.00;

          double calculateSidesPrice() {
            double sidesPrice = 0.0;
            for (var side in selectedSide) {
              sidesPrice += side['price'];
            }
            return sidesPrice;
          }

          double subTotalPrice = drinkPrice() + choicePrice + noodlesTypePrice + meatPrice + meePrice + calculateSidesPrice();

          void calculateTotalPrice(double drinkPrice, double choicePrice, double noodlesTypePrice, double meatPrice, double meePrice, double sidesPrice) {
            setState(() {
              subTotalPrice = drinkPrice + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice;
              item.price = subTotalPrice;
            });
          }
          // side is singular because it represent single item
          TextSpan generateSidesTextSpan(Map<String, dynamic> side, bool isLast) {
            return TextSpan(
              text: "${side['name']} ",
              children: <TextSpan>[
                TextSpan(
                  text: "( + ${side['price'].toStringAsFixed(2)} )${isLast ? '' : ' + '}", // No comma if it's the last side
                  style: const TextStyle(
                    color: Color.fromARGB(255, 114, 226, 118), // Change this to your desired color
                  ),
                ),
              ],
            );
          }

          comment = item.itemRemarks != null ? item.itemRemarks!['100'] : null;
          _controller.text = comment ?? '';

          // remarkButton Widget
          Widget remarkButton(Map<String, dynamic> data) {
            return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    // Check if the remark has been added to itemRemarks
                    if (itemRemarks.containsKey(data['id'].toString())) {
                      // If the button is pressed or the remark has been added, make the background green
                      return states.contains(WidgetState.pressed) ? Colors.white : Colors.orange;
                    } else {
                      // If the button is pressed or the remark has not been added, make the background black
                      return states.contains(WidgetState.pressed) ? Colors.orange : Colors.white;
                    }
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (itemRemarks.containsKey(data['id'].toString())) {
                      return states.contains(WidgetState.pressed) ? Colors.black : Colors.white;
                    } else {
                      return states.contains(WidgetState.pressed) ? Colors.white : Colors.black;
                    }
                  },
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(10, 6, 10, 6)), //
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
                                      padding: const EdgeInsets.fromLTRB(10, 10, 40, 10),
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
                                              item.selection && selectedChoice != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          item.originalName == selectedChoice!['name']
                                                              ? item.originalName
                                                              : '${item.originalName} ${selectedChoice!['name']}',
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          "( ${selectedChoice?['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            // color: Color.fromARGB(255, 114, 226, 118),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          item.originalName == selectedDrink!['name']
                                                              ? item.originalName
                                                              : '${item.originalName} ${selectedDrink?['name']} - ${selectedTemp?["name"]}',
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          "( ${drinkPrice().toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            // color: Color.fromARGB(255, 114, 226, 118),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  item.selection && selectedNoodlesType != null
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedNoodlesType!['name']} ",
                                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                                            ),
                                                            Text(
                                                              "( + ${selectedNoodlesType!['price'].toStringAsFixed(2)} )",
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
                                                  item.selection && selectedSide.isNotEmpty
                                                      ? Wrap(
                                                          children: [
                                                            const Text(
                                                              "Sides: ",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 500, // Adjust the width as needed
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.white,
                                                                  ),
                                                                  children: selectedSide.toList().asMap().entries.map((entry) {
                                                                    int idx = entry.key;
                                                                    Map<String, dynamic> side = entry.value;
                                                                    // singular because it represent one item.
                                                                    bool isLast = idx == selectedSide.length - 1;
                                                                    return generateSidesTextSpan(side, isLast);
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ),
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
                                        item.selection && selectedDrink != null
                                            ?
                                            // selectedDrink
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
                                                      if (item.drinks.isNotEmpty) ...[
                                                        const Text(
                                                          'Select Drink',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Wrap(
                                                          spacing: 6, // space between buttons horizontally
                                                          runSpacing: 0, // space between buttons vertically
                                                          children: item.drinks.map((drink) {
                                                            return ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedDrink = drink;
                                                                  calculateTotalPrice(
                                                                      drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                                });
                                                              },
                                                              style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.all<Color>(
                                                                  selectedDrink?['name'] == drink['name'] ? Colors.orange : Colors.white,
                                                                ),
                                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                              ),
                                                              child: Text(
                                                                '${drink['name']}',
                                                                style: TextStyle(
                                                                  color: selectedDrink?['name'] == drink['name']
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
                                              )
                                            : const SizedBox.shrink(),
                                        if (item.temp.isNotEmpty) const SizedBox(width: 10),
                                        item.selection && selectedTemp != null
                                            ?
                                            // selectedTemp
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
                                                      if (item.temp.isNotEmpty) ...[
                                                        const Text(
                                                          'Select Temperature',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Wrap(
                                                          spacing: 6, // space between buttons horizontally
                                                          runSpacing: 0, // space between buttons vertically
                                                          children: item.temp.map((item) {
                                                            return ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedTemp = item;
                                                                  calculateTotalPrice(
                                                                      drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                                });
                                                              },
                                                              style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.all<Color>(
                                                                  selectedTemp?['name'] == item['name'] ? Colors.orange : Colors.white,
                                                                ),
                                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                              ),
                                                              child: Text(
                                                                '${item['name']}',
                                                                style: TextStyle(
                                                                  color: selectedTemp?['name'] == item['name']
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
                                              )
                                            : const SizedBox.shrink(),
                                        item.selection && selectedChoice != null
                                            ?
                                            // selectedChoice
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
                                                          'Select Base',
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
                                                                  calculateTotalPrice(
                                                                      drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                                });
                                                              },
                                                              style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.all<Color>(
                                                                  selectedChoice?['name'] == choice['name'] ? Colors.orange : Colors.white,
                                                                ),
                                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                              ),
                                                              child: Text(
                                                                '${choice['name']}',
                                                                style: TextStyle(
                                                                  color: selectedChoice?['name'] == choice['name']
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
                                              )
                                            : const SizedBox.shrink(),
                                        if (item.noodlesTypes.isNotEmpty) const SizedBox(width: 10),
                                        // selectedNoodlesType
                                        if (item.noodlesTypes.isNotEmpty) ...[
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
                                                    "Select Noodles",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: item.noodlesTypes.map((type) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedNoodlesType = type;
                                                            noodlesTypePrice = type['price'];
                                                            calculateTotalPrice(
                                                                drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: WidgetStateProperty.all<Color>(
                                                            selectedNoodlesType?['name'] == type['name'] ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${type['name']}',
                                                          style: TextStyle(
                                                            color: selectedNoodlesType?['name'] == type['name']
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
                                        if (item.meatPortion.isNotEmpty) ...[
                                          Expanded(
                                            flex: 4,
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
                                                    'Select Meat Portion',
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
                                                            calculateTotalPrice(
                                                                drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: WidgetStateProperty.all<Color>(
                                                            selectedMeatPortion?['name'] == meatPortion['name'] ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${meatPortion['name']}',
                                                          style: TextStyle(
                                                            color: selectedMeatPortion?['name'] == meatPortion['name']
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
                                        if (item.sides.isNotEmpty) const SizedBox(width: 10),
                                        if (item.sides.isNotEmpty) ...[
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Sides',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 0,
                                                    children: item.sides.map((side) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          // print('selectedSide before: $selectedSide');
                                                          // print('side: $side');
                                                          setState(() {
                                                            if (selectedSide.contains(side)) {
                                                              selectedSide.remove(side);
                                                            } else {
                                                              selectedSide.add(side);
                                                            }
                                                            // print('selectedSide after: $selectedSide');
                                                            calculateTotalPrice(
                                                                drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: WidgetStateProperty.all<Color>(
                                                            selectedSide.contains(side) ? Colors.orange : Colors.white,
                                                          ),
                                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                        ),
                                                        child: Text(
                                                          '${side['name']}',
                                                          style: TextStyle(
                                                            color: selectedSide.contains(side) ? Colors.white : Colors.black,
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
                                        if (item.meePortion.isNotEmpty) ...[
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                              ),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Select Mee Portion',
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
                                                                calculateTotalPrice(
                                                                    drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor: WidgetStateProperty.all<Color>(
                                                                selectedMeePortion?['name'] == meePortion['name'] ? Colors.orange : Colors.white,
                                                              ),
                                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                              ),
                                                              padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                            ),
                                                            child: Text(
                                                              '${meePortion['name']}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: selectedMeePortion?['name'] == meePortion['name']
                                                                    ? Colors.white
                                                                    : Colors.black, // Change the text color based on the selected button
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox.shrink(),
                                        ],
                                        if (item.meePortion.isNotEmpty) const SizedBox(width: 10),
                                        Expanded(
                                          flex: 3,
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
                                                  'Add Remarks',
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
                                          flex: 3,
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
                                                  'Write Remarks',
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
                                              backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
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
                                                // log('before changes: item name is ${item.name}');
                                                // if (selectedChoice != null) {
                                                //   item.name = selectedChoice!['name'];
                                                // }
                                                // log('Ater changes: item name is ${item.name}');
                                                item.selectedNoodlesType = selectedNoodlesType;
                                                item.selectedMeatPortion = selectedMeatPortion;
                                                item.selectedMeePortion = selectedMeePortion;
                                                item.selectedSide = selectedSide;
                                                item.selectedDrink = selectedDrink;
                                                item.selectedTemp = selectedTemp;

                                                updateItemRemarks(
                                                  selectedMeePortion: selectedMeePortion,
                                                  selectedMeatPortion: selectedMeatPortion,
                                                  item: item,
                                                );

                                                calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice());
                                                item.price = subTotalPrice;
                                                widget.selectedOrder.updateTotalCost(0);
                                                widget.selectedOrder.updateItem(item);
                                                // // Update tempCartItems with the modified item
                                                // int itemIndex = widget.tempCartItems.indexWhere((tempItem) => tempItem.id == item.id);
                                                // if (itemIndex != -1) {
                                                //   widget.tempCartItems[itemIndex] = item;
                                                // }
                                              });
                                              widget.updateOrderStatus!();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)), // Set the padding here
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
                                              setState(() {
                                                itemRemarks = {};
                                                _controller.text = '';
                                                selectedSide = item.selectedSide != null ? Set<Map<String, dynamic>>.from(item.selectedSide!) : {};
                                              });
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
                        item.selection
                            ? Row(
                                children: [
                                  Text(
                                    item.selectedChoice != null
                                        ? '${index + 1}. ${item.originalName} ${item.selectedChoice?['name']}'
                                        : '${index + 1}. ${item.originalName} ${item.selectedDrink?['name']} - ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  item.selectedTemp != null
                                      ? Text(
                                          '${item.selectedTemp?["name"]}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: item.selectedTemp?['name'] == 'Hot' ? Colors.orangeAccent : Colors.green[400],
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              )
                            : Text(
                                '${index + 1}. $name',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                        Wrap(
                          children: [
                            item.selection == true && item.selectedNoodlesType != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      "( ${item.selectedNoodlesType!['name']} )",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.yellow,
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
                        item.selectedSide != null && item.selectedSide?.isNotEmpty == true
                            ? Text(
                                item.selectedSide!.map((side) => side['name']).join(', '),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox.shrink(),

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
                showEditBtn
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            updateItemRemarks(
                              selectedMeePortion: item.selectedMeePortion,
                              selectedMeatPortion: item.selectedMeatPortion,
                              item: item,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.blueGrey, // Background color
                            borderRadius: BorderRadius.circular(5), // Border radius
                          ),
                          child: const Text(
                            "Tapao",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                const SizedBox(width: 20.0),
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
                                      icon: Icons.remove_circle,
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
            icon: Icons.remove_circle,
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
            toastDuration: const Duration(milliseconds: 1000),
            animationType: AnimationType.fromTop,
            animationDuration: const Duration(milliseconds: 200),
            autoDismiss: true,
            displayCloseButton: false,
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
//         margin: EdgeInsets.only(top: item.selection && item.selectedMeatPortion != null ? 10 : 0.0),
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
//           margin: EdgeInsets.only(top: item.selection && item.selectedMeePortion != null ? 10 : 0.0),
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