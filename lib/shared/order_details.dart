import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:jspos/data/remarks.dart';
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
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();
  void prettyPrintOrder() {
    // print('Order Number: ${widget.selectedOrder.orderNumber}');
    // print('Table Name: ${widget.selectedOrder.tableName}');
    // print('Order Type: ${widget.selectedOrder.orderType}');
    // print('Order Time: ${widget.selectedOrder.orderTime}');
    // print('Order Date: ${widget.selectedOrder.orderDate}');
    // print('Status: ${widget.selectedOrder.status}');
    // print('-------------------------');
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
            timeStamp: (widget.selectedOrder.orderTime?.toString() ?? 'Order Time'),
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
          // Category, Items, Quantity UI
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xff1f2029),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cakes ${widget.selectedOrder.cakes['itemQuantity'].toString()}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Dish ${widget.selectedOrder.dish['itemQuantity'].toString()}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Drinks ${widget.selectedOrder.drinks['itemQuantity'].toString()}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
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
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[800]!),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Adjust this value as needed
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Edit', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
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
              style: const TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "$timeStamp, $date",
              style: const TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.bold),
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
                padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)), //
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
                  fontSize: 22,
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
                            padding: const EdgeInsets.all(20),
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
                                    //Item Heading Title
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xff1f2029),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${item.category}:  ${item.originalName}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                            width: 160,
                                            height: 160,
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
                                                          selectedChoice != null ? '${selectedChoice!['name']}' : 'Select Flavor and Type',
                                                          style: const TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Text(
                                                          "( + ${selectedChoice!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 24,
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
                                                              style: const TextStyle(fontSize: 22, color: Colors.white),
                                                            ),
                                                            Text(
                                                              "( + ${selectedType!['price'].toStringAsFixed(2)} )",
                                                              style: const TextStyle(
                                                                fontSize: 22,
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
                                                                fontSize: 22,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              "( + ${selectedMeePortion!['price'].toStringAsFixed(2)} )",
                                                              style: const TextStyle(
                                                                fontSize: 22,
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
                                                                fontSize: 22,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              "( + ${selectedMeatPortion!['price'].toStringAsFixed(2)} )",
                                                              style: const TextStyle(
                                                                fontSize: 22,
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
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // First Row for selection of Choices & Types
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 1.selectedChoice
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Wrap(
                                                    spacing: 14, // space between buttons horizontally
                                                    runSpacing: 14, // space between buttons vertically
                                                    children: item.choices.map((choice) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedChoice = choice;
                                                            choicePrice = choice['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedChoice == choice
                                                              ? Colors.orange
                                                              : Colors.white, // Change the color based on the selected button
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          // side: const BorderSide(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text(
                                                            '${choice['name']}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: selectedChoice == choice
                                                                  ? Colors.white
                                                                  : Colors.black, // Change the text color based on the selected button
                                                              fontSize: 22,
                                                            ),
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
                                        if (item.types.isNotEmpty) const SizedBox(width: 20),
                                        // 2.selectedType
                                        if (item.types.isNotEmpty) ...[
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Wrap(
                                                    spacing: 14, // space between buttons horizontally
                                                    runSpacing: 14, // space between buttons vertically
                                                    children: item.types.map((type) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedType = type;
                                                            typePrice = type['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedType == type
                                                              ? Colors.orange
                                                              : Colors.white, // Change the color based on the selected button
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          // side: const BorderSide(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text(
                                                            '${type['name']}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: selectedType == type
                                                                  ? Colors.white
                                                                  : Colors.black, // Change the text color based on the selected button
                                                              fontSize: 22,
                                                            ),
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
                                              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                              margin: const EdgeInsets.only(top: 20),
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
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Wrap(
                                                    spacing: 14, // space between buttons horizontally
                                                    runSpacing: 14, // space between buttons vertically
                                                    children: item.meePortion.map((meePortion) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMeePortion = meePortion;
                                                            meePrice = meePortion['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedMeePortion == meePortion
                                                              ? Colors.orange
                                                              : Colors.white, // Change the color based on the selected button
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          // side: const BorderSide(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text(
                                                            '${meePortion['name']}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: selectedMeePortion == meePortion
                                                                  ? Colors.white
                                                                  : Colors.black, // Change the text color based on the selected button
                                                              fontSize: 22,
                                                            ),
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
                                        if (item.meatPortion.isNotEmpty) const SizedBox(width: 20),
                                        if (item.meatPortion.isNotEmpty) ...[
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                              margin: const EdgeInsets.only(top: 20),
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
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Wrap(
                                                    spacing: 14, // space between buttons horizontally
                                                    runSpacing: 14, // space between buttons vertically
                                                    children: item.meatPortion.map((meatPortion) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMeatPortion = meatPortion;
                                                            meatPrice = meatPortion['price'];
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedMeatPortion == meatPortion
                                                              ? Colors.orange
                                                              : Colors.white, // Change the color based on the selected button
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          // side: const BorderSide(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10),
                                                          child: Text(
                                                            '${meatPortion['name']}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: selectedMeatPortion == meatPortion
                                                                  ? Colors.white
                                                                  : Colors.black, // Change the text color based on the selected button
                                                              fontSize: 22,
                                                            ),
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
                                            padding: const EdgeInsets.fromLTRB(20, 30, 10, 20),
                                            margin: const EdgeInsets.only(top: 20),
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
                                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10),
                                                // remarks buttons
                                                Wrap(
                                                  spacing: 6.0, // gap between adjacent chips
                                                  runSpacing: 3.0, // gap between lines
                                                  children: remarksData
                                                      .where((data) => data['category'] == item.category) // Filter remarksData based on item.category
                                                      .map((data) => Padding(
                                                            padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
                                                            child: remarkButton(data),
                                                          ))
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
                                            margin: const EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029),
                                              borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Please write additional remarks here',
                                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10),
                                                TextField(
                                                  controller: _controller,
                                                  style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.all(10),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    border: OutlineInputBorder(),
                                                    // labelText: 'Write Additional Comments here',
                                                    // labelStyle: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
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
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
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
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                // side: const BorderSide(color: Colors.deepOrange, width: 1),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                ),
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
                  height: 55,
                  width: 55,
                  margin: const EdgeInsets.only(left: 10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}. $name',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                item.selection == true && item.selectedType != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          "( ${item.selectedType!['name']} )",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: item.selectedType!['name'] == 'Cold' ? Colors.green[500] : Colors.orangeAccent,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                // Showing the Item Price UI
                                // Text(
                                //   'RM ${price.toStringAsFixed(2)}',
                                //   style: TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.green[300],
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        // To Edit, Increase, Decrease and Remove item
                        showEditBtn
                            ? Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${item.quantity} x',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        item.quantity++;
                                        widget.selectedOrder.updateTotalCost(0);
                                        widget.selectedOrder.calculateItemsAndQuantities();
                                        widget.updateOrderStatus!();
                                      });
                                    },
                                    child: Container(
                                      width: 40, // Adjust this value to change the width of the rectangle
                                      height: 40, // Adjust this value to change the height of the rectangle
                                      decoration: BoxDecoration(
                                        color: Colors.green[700],
                                        borderRadius: BorderRadius.circular(10), // Adjust this value to change the roundness of the rectangle corners
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 24,
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
                                          widget.selectedOrder.updateTotalCost(0);
                                          widget.selectedOrder.calculateItemsAndQuantities();
                                          widget.updateOrderStatus!();
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 40, // Adjust this value to change the width of the rectangle
                                      height: 40, // Adjust this value to change the height of the rectangle
                                      decoration: BoxDecoration(
                                        color: Colors.orange[800]!,
                                        borderRadius: BorderRadius.circular(10), // Adjust this value to change the roundness of the rectangle corners
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Item Remarks & Comments UI
            Wrap(
              children: [
                // Text for selectedMeatPortion
                item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 16.0 : 0.0,
                            top: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 10.0 : 0.0,
                            bottom: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 10.0 : 0.0,
                            right: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 16.0 : 0.0),
                        margin: EdgeInsets.only(top: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 12.0 : 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white10,
                        ),
                        child: Text(
                          item.itemRemarks?.values.join(', ') ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
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

          // Then show a snackbar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 300),
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
                      name,
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