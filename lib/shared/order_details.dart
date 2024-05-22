import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          print('item.itemRemarks is: ${item.itemRemarks}');
          Map<String, dynamic>? selectedChoice = item.selectedChoice;
          Map<String, dynamic>? selectedType = item.selectedType;
          Map<String, dynamic>? selectedMeatPortion = item.selectedMeatPortion;
          Map<String, dynamic>? selectedMeePortion = item.selectedMeePortion;

          double choicePrice = item.selectedChoice?['price'] ?? 0;
          double typePrice = item.selectedType?['price'] ?? 0;
          double meatPrice = item.selectedMeatPortion?['price'] ?? 0;
          double meePrice = item.selectedMeePortion?['price'] ?? 0;
          double subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;

          void calculateTotalPrice(double choicePrice, double typePrice, double meatPrice, double meePrice) {
            setState(() {
              subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;
              item.price = subTotalPrice;
              // print('Price of Selected Choice: $choicePrice');
              // print('Price of Selected Type: $typePrice');
              // print('Price of Selected Meat: $meatPrice');
              // print('Price of Selected Mee: $meePrice');
              // print('Total Price: $subTotalPrice');
              // print('-------------------------');
            });
          }

          String? comment = item.itemRemarks!['100'];
          _controller.text = comment ?? '';
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
                  print('itemRemarks selection:$itemRemarks');
                  print('item.itemRemarks:${item.itemRemarks}');
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

          if (!widget.selectedOrder.showEditBtn && item.selection) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Dialog(
                        insetPadding: EdgeInsets.zero, // Make dialog full-screen
                        backgroundColor: Colors.black87,
                        child: AlertDialog(
                          title: Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.black,
                          shadowColor: Colors.black,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.deepOrange, width: 2), // This is the border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 1600,
                              minHeight: 800,
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Column(
                                  children: [
                                    // First row
                                    Row(
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
                                            Text(
                                              selectedChoice != null && selectedType != null
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
                                                      builder: (BuildContext context) {
                                                        return SimpleDialog(
                                                          title: const Text('Select Flavor'),
                                                          children: item.choices.map<SimpleDialogOption>((choice) {
                                                            return SimpleDialogOption(
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedChoice = choice;
                                                                  item.selectedChoice = choice;
                                                                  choicePrice = choice['price'];
                                                                  item.name = choice['name'];
                                                                });
                                                                calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                '${choice['name']} (RM ${choice['price'].toStringAsFixed(2)})',
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
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
                                                      borderRadius: BorderRadius.circular(5), // This is the border radius
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                      '${selectedChoice!['name']} (RM ${selectedChoice!['price'].toStringAsFixed(2)})',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
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
                                                      builder: (BuildContext context) {
                                                        return SimpleDialog(
                                                          title: const Text('Select Variation'),
                                                          children: item.types.map<SimpleDialogOption>((type) {
                                                            return SimpleDialogOption(
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedType = type;
                                                                  item.selectedType = type;
                                                                  typePrice = type['price'];
                                                                });
                                                                calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                '${type['name']} + RM ${type['price'].toStringAsFixed(2)}',
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
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
                                                      borderRadius: BorderRadius.circular(5), // This is the border radius
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15),
                                                    child: Text(
                                                      '${selectedType!['name']} + RM ${selectedType!['price'].toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
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
                                                      builder: (BuildContext
                                                          context) {
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5), // This is the border radius
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
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
                                                      builder: (BuildContext
                                                          context) {
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5), // This is the border radius
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
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
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // First row
                                        const Text(
                                          'Press the buttons to add remarks',
                                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        // remarks buttons
                                        Wrap(
                                          spacing: 8.0, // gap between adjacent chips
                                          runSpacing: 4.0, // gap between lines
                                          children: remarksData
                                              .where((data) => data['category'] == item.category) // Filter remarksData based on item.category
                                              .map((data) => Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
                                                    child: remarkButton(data),
                                                  ))
                                              .toList(),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: _controller,
                                          style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(),
                                            labelText: 'Write comments or remarks here',
                                            labelStyle: TextStyle(color: Colors.grey, fontSize: 22, fontWeight: FontWeight.bold),
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
                                        )
                                      ],
                                    ),
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
                              // SubTotal, Service Charges Total OnPressed Function
                              onPressed: () {
                                setState(() {
                                  // Add the user's comment with a key of '100'
                                  if (item.itemRemarks != {} && comment != null && _controller.text.trim() != '') {
                                    itemRemarks['100'] = _controller.text;
                                  }
                                  SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
                                    (a, b) => int.parse(a).compareTo(int.parse(b)),
                                  )..addAll(itemRemarks);
                                  item.itemRemarks = sortedItemRemarks;
                                  item.price = subTotalPrice;
                                  widget.selectedOrder.updateTotalCost(0);
                                  widget.updateOrderStatus!();
                                  widget.selectedOrder.updateItem(item);
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
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                  fontSize: 18,
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
                          '${index + 1}. $name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        item.selectedType != null && item.category != "Cakes"
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "( ${item.selectedType!['name']} )",
                                  style: TextStyle(
                                    fontSize: 18,
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
                          fontSize: 24,
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
                                  widget.selectedOrder.updateTotalCost(0);
                                  widget.selectedOrder.calculateItemsAndQuantities();
                                  widget.updateOrderStatus!();
                                });
                              },
                              child: CircleAvatar(
                                radius: 16, // Adjust this value to change the size of the CircleAvatar
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
                                    widget.selectedOrder.updateTotalCost(0);
                                    widget.selectedOrder.calculateItemsAndQuantities();
                                    widget.updateOrderStatus!();
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 16, // Adjust this value to change the size of the CircleAvatar
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
            // Remarks & Comments UI
            Padding(
              padding: EdgeInsets.only(
                  top: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 10.0 : 0.0,
                  left: item.selection && item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true ? 2.0 : 0.0),
              child: Wrap(
                children: [
                  item.itemRemarks != null && item.itemRemarks?.isNotEmpty == true
                      ? Text(
                          item.itemRemarks?.values.join(', ') ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
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
              duration: const Duration(milliseconds: 100),
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
