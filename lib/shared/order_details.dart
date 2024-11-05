import 'dart:collection';
import 'dart:developer';
import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
import 'package:jspos/data/remarks.dart';
// import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/data/menu_data.dart';
// import 'package:jspos/data/menu1_data.dart';

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

  // Function to calculate the length of the concatenated string
  int calculateTextLength({
    String? originalName,
    Map<String, dynamic>? selectedChoice,
    Map<String, dynamic>? selectedDrink,
    required int index,
  }) {
    // Construct the string based on the provided optional values
    String result = '${index + 1}. ';

    if (originalName != null) {
      result += originalName;
    }

    if (selectedChoice != null && selectedChoice.containsKey('name')) {
      result += ' ${selectedChoice['name']}';
    } else if (selectedDrink != null && selectedDrink.containsKey('name')) {
      result += ' ${selectedDrink['name']} - ';
    }

    // Return the length of the constructed string
    return result.length;
  }

  IconData _getIconData(String iconText) {
    const iconMap = {
      'info': Icons.info,
      'check_circle': Icons.check_circle,
      'remove_circle': Icons.remove_circle,
      'cancel': Icons.cancel,
    };

    return iconMap[iconText] ?? Icons.info; // Default to 'help' if not found
  }

  void _showCherryToast(
    String iconText,
    String titleText,
    // String iconClr,
    // String themeClr,
    int toastDu, // Changed to int for duration
    int animateDu,
  ) {
    CherryToast(
      icon: _getIconData(iconText), // Retrieve the corresponding icon
      iconColor: Colors.green,
      themeColor: const Color.fromRGBO(46, 125, 50, 1),
      backgroundColor: Colors.white,
      title: Text(
        titleText,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      toastPosition: Position.top,
      toastDuration: Duration(milliseconds: toastDu), // Use the passed duration
      animationType: AnimationType.fromTop,
      animationDuration: Duration(milliseconds: animateDu), // Use the passed animation duration
      autoDismiss: true,
      displayCloseButton: false,
    ).show(context);
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
        // Total quantity of items under the category UI and handle method status
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
                  // // Cancel and Remove and Delete Selected Order
                  // (!showEditBtn && widget.selectedOrder.status != "Start Your Order" && widget.selectedOrder.status != "Ordering")
                  //     ? Container(
                  //         width: 35,
                  //         height: 35,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(12),
                  //           color: Colors.white,
                  //           shape: BoxShape.rectangle,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey.withOpacity(0.1),
                  //               spreadRadius: 2,
                  //               blurRadius: 2,
                  //               offset: const Offset(0, 1), // changes position of shadow
                  //             ),
                  //           ],
                  //         ),
                  //         child: IconButton(
                  //             icon: const Icon(Icons.delete_forever, size: 20),
                  //             color: Colors.redAccent,
                  //             onPressed: () {
                  //               showDialog(
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return Dialog(
                  //                     insetPadding: EdgeInsets.zero, // Make dialog full-screen
                  //                     backgroundColor: Colors.black87,
                  //                     child: AlertDialog(
                  //                       backgroundColor: const Color(0xff1f2029),
                  //                       elevation: 5,
                  //                       shape: RoundedRectangleBorder(
                  //                         side: const BorderSide(color: Colors.green, width: 1), // This is the border color
                  //                         borderRadius: BorderRadius.circular(10.0),
                  //                       ),
                  //                       content: ConstrainedBox(
                  //                         constraints: const BoxConstraints(
                  //                           maxWidth: 400,
                  //                           maxHeight: 100,
                  //                         ),
                  //                         child: const Wrap(
                  //                           alignment: WrapAlignment.center,
                  //                           children: [
                  //                             Text(
                  //                               'Are you sure?',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
                  //                             ),
                  //                             Text(
                  //                               'Please note, once cancelled, the action is irreversible.',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(fontSize: 18, color: Colors.white),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       actions: [
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(bottom: 0, left: 40, right: 40),
                  //                           child: Row(
                  //                             mainAxisAlignment: MainAxisAlignment.center,
                  //                             children: [
                  //                               ElevatedButton(
                  //                                 style: ButtonStyle(
                  //                                   backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                  //                                   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  //                                     RoundedRectangleBorder(
                  //                                       borderRadius: BorderRadius.circular(5),
                  //                                     ),
                  //                                   ),
                  //                                   padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 2, 12, 2)),
                  //                                 ),
                  //                                 onPressed: () {
                  //                                   widget.resetSelectedTable?.call();
                  //                                   if (Hive.isBoxOpen('orders')) {
                  //                                     var ordersBox = Hive.box('orders');
                  //                                     var orders = ordersBox.get('orders') as Orders;

                  //                                     // Find the index of the order to update
                  //                                     int indexToUpdate =
                  //                                         orders.data.indexWhere((order) => order.orderNumber == widget.selectedOrder.orderNumber);

                  //                                     // Check if the order was found
                  //                                     if (indexToUpdate != -1) {
                  //                                       // Create a copy of the selectedOrder
                  //                                       var orderCopy = widget.selectedOrder.copyWith();
                  //                                       String addCancelDateTime() {
                  //                                         DateTime now = DateTime.now();
                  //                                         return DateFormat('h:mm a, d MMMM yyyy').format(now); // Outputs: 1:03 AM, 5 May 2024
                  //                                       }

                  //                                       orderCopy.status = "Cancelled";
                  //                                       // Set orderCopy.cancelTime using the addCancelDateTime method
                  //                                       orderCopy.cancelledTime = addCancelDateTime();
                  //                                       orderCopy.paymentTime = "None";
                  //                                       orderCopy.paymentMethod = "None";
                  //                                       // Update the order in the list
                  //                                       orders.data[indexToUpdate] = orderCopy;
                  //                                       log('order was found: $indexToUpdate');

                  //                                       // Put the updated list back into the box
                  //                                       ordersBox.put('orders', orders);
                  //                                     } else {
                  //                                       log('order was not found');
                  //                                     }
                  //                                     log('order from order Details page: $orders');
                  //                                   }
                  //                                   setState(() {
                  //                                     widget.selectedOrder.handleCancelOrder();
                  //                                     if (handlefreezeMenu != null) {
                  //                                       handlefreezeMenu();
                  //                                     }
                  //                                     if (updateOrderStatus != null) {
                  //                                       updateOrderStatus();
                  //                                     }
                  //                                   });
                  //                                   _showCherryToast(
                  //                                     'cancel',
                  //                                     'The order has being cancelled!',
                  //                                     2000, // Toast duration in milliseconds
                  //                                     200, // Animation duration in milliseconds
                  //                                   );
                  //                                   // CherryToast(
                  //                                   //   icon: Icons.cancel,
                  //                                   //   iconColor: Colors.red,
                  //                                   //   themeColor: Colors.red,
                  //                                   //   backgroundColor: Colors.white,
                  //                                   //   title: const Text(
                  //                                   //     'The order has being cancelled!',
                  //                                   //     style: TextStyle(
                  //                                   //       fontSize: 14,
                  //                                   //       color: Colors.black,
                  //                                   //     ),
                  //                                   //   ),
                  //                                   //   toastPosition: Position.top,
                  //                                   //   toastDuration: const Duration(milliseconds: 3000),
                  //                                   //   animationType: AnimationType.fromTop,
                  //                                   //   animationDuration: const Duration(milliseconds: 200),
                  //                                   //   autoDismiss: true,
                  //                                   //   displayCloseButton: false,
                  //                                   // ).show(context);
                  //                                   Navigator.of(context).pop();
                  //                                 },
                  //                                 child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
                  //                               ),
                  //                               const SizedBox(width: 20),
                  //                               ElevatedButton(
                  //                                 style: ButtonStyle(
                  //                                   backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  //                                   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  //                                     RoundedRectangleBorder(
                  //                                       borderRadius: BorderRadius.circular(5),
                  //                                     ),
                  //                                   ),
                  //                                   padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 2, 12, 2)),
                  //                                 ),
                  //                                 onPressed: () {
                  //                                   Navigator.of(context).pop();
                  //                                 },
                  //                                 child: const Text(
                  //                                   'Cancel',
                  //                                   style: TextStyle(fontSize: 14, color: Colors.black),
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   );
                  //                 },
                  //               );
                  //             }),
                  //       )
                  //     : const SizedBox.shrink(),
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

  // selected items details iamge, name, quantity, sides, meePortion, meatPortion, noodlesTypes, etc
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
          Set<Map<String, dynamic>> selectedNoodlesType = Set<Map<String, dynamic>>.from(item.selectedNoodlesType ?? {});
          Map<String, dynamic>? selectedMeatPortion = item.selectedMeatPortion;
          Map<String, dynamic>? selectedMeePortion = item.selectedMeePortion;
          Set<Map<String, dynamic>> selectedSide = Set<Map<String, dynamic>>.from(item.selectedSide ?? {});
          log('From the ORDER DETAILS selected Side is: $selectedSide');
          log('Selected Side from item.selectedSide is: ${item.selectedSide}');
          Map<String, dynamic>? selectedSoupOrKonLou = item.selectedSoupOrKonLou;
          log('selected side are : $selectedSide');
          // The Map elements in selectedSide and item.selectedSide are the same Map objects.
          // even though selectedSide and item.selectedSide are separate Set objects.

          Map<String, dynamic>? selectedAddOn = item.selectedAddOn;

          double drinkPrice() {
            final selectedTempName = selectedTemp?['name'] ?? ''; // Convert to non-nullable String
            final price = (selectedDrink?[selectedTempName] as double?) ?? 0.00;
            return price; // Get the price based on the selected temperature
          }
          // final priceResult = drinkPrice();
          // log('Drink Price is :${priceResult.toStringAsFixed(2)}');

          // these are ui display only, not yet saved into item.price
          double choicePrice = item.selectedChoice?['price'] ?? 0;
          double noodlesTypePrice = item.noodlesTypes.isNotEmpty && item.noodlesTypes[0]['price'] != null ? item.noodlesTypes[0]['price']! : 0.00;
          double meatPrice = item.selectedMeatPortion?['price'] ?? 0;
          double meePrice = item.selectedMeePortion?['price'] ?? 0;
          double sidesPrice = item.sides.isNotEmpty && item.sides[0]['price'] != null ? item.sides[0]['price']! : 0.00;
          double addOnsPrice = item.selectedAddOn?['price'] ?? 0;
          double soupOrKonlouPrice = item.selectedSoupOrKonLou?['price'] ?? 0;
          double subTotalPrice = drinkPrice() + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice + addOnsPrice;

          double calculateNoodlesPrice() {
            double noodlesPrice = 0.0;
            for (var noodle in selectedNoodlesType) {
              noodlesPrice += noodle['price'];
            }
            return noodlesPrice;
          }

          double calculateSidesPrice() {
            double sidesPrice = 0.0;
            for (var side in selectedSide) {
              sidesPrice += side['price'];
            }
            return sidesPrice;
          }

          void sortSelectedNoodlesAlphabetically() {
            // Convert the set to a list for sorting
            List<Map<String, dynamic>> sortedSides = selectedNoodlesType.toList();

            // Sort the list alphabetically by 'name'
            sortedSides.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

            // Update selectedSide to reflect the sorted order
            selectedNoodlesType = sortedSides.toSet();
          }

          void sortSelectedSidesAlphabetically() {
            List<Map<String, dynamic>> sortedSides = selectedSide.toList();
            sortedSides.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
            selectedSide = sortedSides.toSet();
          }

          void calculateTotalPrice(double drinkPrice, double choicePrice, double noodlesTypePrice, double meatPrice, double meePrice, double sidesPrice,
              double addOnsPrice, double soupOrKonlouPrice) {
            double totalPrice = drinkPrice + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice + addOnsPrice + soupOrKonlouPrice;
            setState(() {
              subTotalPrice = totalPrice;
            });
          }

          TextSpan generateNoodlesOnTextSpan(Map<String, dynamic> noodle, bool isLast) {
            return TextSpan(
              text: "${noodle['name']}",
              children: <TextSpan>[
                if (noodle['price'] != null && noodle['price'] != 0.00)
                  TextSpan(
                    text: " ( + ${noodle['price'].toStringAsFixed(2)})", // Display price if available
                    style: const TextStyle(
                      color: Color.fromARGB(255, 114, 226, 118), // Customize the color for the price
                    ),
                  ),
                // Add a comma after each item, except for the last one
                TextSpan(
                  text: isLast ? '' : ', ',
                ),
              ],
            );
          }

          // side is singular because it represent single item
          TextSpan generateSidesOnTextSpan(Map<String, dynamic> side, bool isLast) {
            return TextSpan(
              text: "${side['name']}",
              children: <TextSpan>[
                if (side['price'] != null && side['price'] != 0.00)
                  TextSpan(
                    text: " ( + ${side['price'].toStringAsFixed(2)})", // Display price if available
                    style: const TextStyle(
                      color: Color.fromARGB(255, 114, 226, 118), // Customize the color for the price
                    ),
                  ),
                // Add a comma after each item, except for the last one
                TextSpan(
                  text: isLast ? '' : ', ',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    // Item Image, Name, Price DETAILS
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
                                                            // fontWeight: FontWeight.bold,
                                                            // color: Colors.white,
                                                            color: Color.fromARGB(255, 114, 226, 118),
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
                                                  Row(
                                                    children: [
                                                      item.selection && selectedSoupOrKonLou != null
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "${selectedSoupOrKonLou!['name']} - ",
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.yellow,
                                                                  ),
                                                                ),
                                                                // Display price only if it is greater than 0.00
                                                                if (selectedSoupOrKonLou!['price'] != 0.00)
                                                                  Text(
                                                                    "( + ${selectedSoupOrKonLou!['price'].toStringAsFixed(2)} )",
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                      color: Color.fromARGB(255, 114, 226, 118),
                                                                    ),
                                                                  )
                                                              ],
                                                            )
                                                          : const SizedBox.shrink(),
                                                      item.selection && selectedNoodlesType.isNotEmpty
                                                          ? Wrap(
                                                              children: [
                                                                SizedBox(
                                                                  width: 500, // Adjust the width as needed
                                                                  child: RichText(
                                                                    text: TextSpan(
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                        color: Colors.white,
                                                                      ),
                                                                      // Convert Set to List here
                                                                      children: selectedNoodlesType.toList().asMap().entries.map((entry) {
                                                                        int idx = entry.key;
                                                                        Map<String, dynamic> noodle = entry.value;
                                                                        bool isLast = idx == selectedNoodlesType.length - 1;
                                                                        return generateNoodlesOnTextSpan(noodle, isLast);
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox.shrink(),
                                                      // item.selection && selectedNoodlesType != null && selectedNoodlesType!['name'] != 'None'
                                                      //     ? Row(
                                                      //         children: [
                                                      //           Text(
                                                      //             "${selectedNoodlesType!['name']} ",
                                                      //             style: const TextStyle(fontSize: 14, color: Colors.white),
                                                      //           ),
                                                      //           // Display price only if it is greater than 0.00
                                                      //           if (selectedNoodlesType!['price'] != 0.00)
                                                      //             Text(
                                                      //               "( + ${selectedNoodlesType!['price'].toStringAsFixed(2)} )",
                                                      //               style: const TextStyle(
                                                      //                 fontSize: 14,
                                                      //                 color: Color.fromARGB(255, 114, 226, 118),
                                                      //               ),
                                                      //             ),
                                                      //         ],
                                                      //       )
                                                      //     : const SizedBox.shrink(),
                                                    ],
                                                  ),
                                                  item.selection && selectedMeePortion != null && selectedMeePortion!['name'] != "Normal Mee"
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedMeePortion!['name']} ",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            // Display price only if it is greater than 0.00
                                                            if (selectedMeePortion!['price'] != 0.00)
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
                                                  item.selection && selectedMeatPortion != null && selectedMeatPortion!['name'] != "Normal Meat"
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${selectedMeatPortion!['name']} ",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            if (selectedMeatPortion!['price'] != 0.00)
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
                                                  // Product Details after select side, noodles, choices, etc
                                                  item.selection
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "Total Sides: ${selectedSide.length}",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.yellow,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            if (selectedAddOn != null && selectedAddOn!['price'] > 0.00)
                                                              Text(
                                                                "( ${selectedAddOn!['name']} Extra Sides ",
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                ),
                                                              ),
                                                            const SizedBox(width: 5),
                                                            if (selectedAddOn != null && selectedAddOn!['price'] > 0.00)
                                                              Text(
                                                                "+ ${(selectedAddOn!['price'] as double).toStringAsFixed(2)})",
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                ),
                                                              ),
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                  item.selection && selectedSide.isNotEmpty
                                                      ? Wrap(
                                                          children: [
                                                            SizedBox(
                                                              width: 500, // Adjust the width as needed
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.white,
                                                                  ),
                                                                  // Convert Set to List here
                                                                  children: selectedSide.toList().asMap().entries.map((entry) {
                                                                    int idx = entry.key;
                                                                    Map<String, dynamic> side = entry.value;
                                                                    bool isLast = idx == selectedSide.length - 1;
                                                                    return generateSidesOnTextSpan(side, isLast);
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                  // Next need to update and separate meePortion and meatPortion from the remarks
                                                  // item.itemRemarks != null && item.itemRemarks!.isNotEmpty
                                                  //     ? Column(
                                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                                  //         children: [
                                                  //           Row(
                                                  //             children: [
                                                  //               const Text(
                                                  //                 "Remarks: ",
                                                  //                 style: TextStyle(
                                                  //                   fontSize: 14,
                                                  //                   color: Colors.yellow,
                                                  //                 ),
                                                  //               ),
                                                  //               Text(
                                                  //                 item.itemRemarks!.values.join(", "), // Get the values and join them with commas
                                                  //                 style: const TextStyle(
                                                  //                   fontSize: 14,
                                                  //                   color: Colors.white,
                                                  //                 ),
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         ],
                                                  //       )
                                                  //     : const SizedBox.shrink(),
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
                                                  // color: Colors.white,
                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // First Row for selection of Choices & Types
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          item.selection && selectedDrink != null
                                              ?
                                              // selectedDrink
                                              Expanded(
                                                  flex: 8,
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
                                                                    calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                        calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
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
                                                  flex: 4,
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
                                                                    calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                        calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
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
                                                            'Select Choice',
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
                                                                    calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                        calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
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
                                                      children: item.noodlesTypes.map((noodleType) {
                                                        return ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (selectedNoodlesType.contains(noodleType)) {
                                                                selectedNoodlesType.remove(noodleType);
                                                              } else {
                                                                selectedNoodlesType.add(noodleType);
                                                              }
                                                              sortSelectedNoodlesAlphabetically();
                                                              calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                  calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor: WidgetStateProperty.all<Color>(
                                                              selectedNoodlesType.any((n) => n['name'] == noodleType['name']) ? Colors.orange : Colors.white,
                                                            ),
                                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                            ),
                                                            padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                          ),
                                                          child: Text(
                                                            '${noodleType['name']}',
                                                            style: TextStyle(
                                                              color:
                                                                  selectedNoodlesType.any((n) => n['name'] == noodleType['name']) ? Colors.white : Colors.black,
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
                                    ),
                                    // Second Row for selection of sides
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          // Selection for user to select sides
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
                                                      'Select Sides',
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
                                                            // log('selectedSide before: $selectedSide');
                                                            // log('side: $side');
                                                            setState(() {
                                                              if (selectedSide.contains(side)) {
                                                                selectedSide.remove(side);
                                                              } else {
                                                                selectedSide.add(side);
                                                              }
                                                              sortSelectedSidesAlphabetically();
                                                              // log('selectedSide after: $selectedSide');
                                                              calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                  calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor: WidgetStateProperty.all<Color>(
                                                              selectedSide.any((s) => s['name'] == side['name']) ? Colors.orange : Colors.white,
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
                                                              color: selectedSide.any((s) => s['name'] == side['name']) ? Colors.white : Colors.black,
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
                                                  if (item.soupOrKonLou.isNotEmpty)
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'Select Soup or Kon Lou',
                                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                                        ),
                                                        Wrap(
                                                          spacing: 6, // space between buttons horizontally
                                                          runSpacing: 0, // space between buttons vertically
                                                          children: item.soupOrKonLou.map((soup) {
                                                            return ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedSoupOrKonLou = soup;
                                                                  soupOrKonlouPrice = soup['price'];
                                                                  calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                      calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
                                                                });
                                                              },
                                                              style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.all<Color>(
                                                                  selectedSoupOrKonLou != null && selectedSoupOrKonLou!['name'] == soup['name']
                                                                      ? Colors.orange
                                                                      : Colors.white,
                                                                ),
                                                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                              ),
                                                              child: Text(
                                                                '${soup['name']}',
                                                                style: TextStyle(
                                                                  color: selectedSoupOrKonLou != null && selectedSoupOrKonLou!['name'] == soup['name']
                                                                      ? Colors.white
                                                                      : Colors.black, // Change the text color based on the selected button
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        const SizedBox(height: 10),
                                                      ],
                                                    ),
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
                                        ],
                                      ),
                                    ),
                                    // Third Row for selection of add On

                                    Row(
                                      children: [
                                        if (item.addOns.isNotEmpty)
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
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Add-On Extra Sides',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Wrap(
                                                        spacing: 6, // space between buttons horizontally
                                                        runSpacing: 0, // space between buttons vertically
                                                        children: item.addOns.map((addOn) {
                                                          return ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedAddOn = addOn;
                                                                addOnsPrice = addOn['price'];
                                                                calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                    calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor: WidgetStateProperty.all<Color>(
                                                                selectedAddOn != null && selectedAddOn!['name'] == addOn['name'] ? Colors.orange : Colors.white,
                                                              ),
                                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                              ),
                                                              padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                            ),
                                                            child: Text(
                                                              '+ ${addOn['name']}',
                                                              style: TextStyle(
                                                                color: selectedAddOn != null && selectedAddOn!['name'] == addOn['name']
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
                                      ],
                                    ),
                                    // Forth Row for selection of meePortion, meatPortion, write remarks
                                    IntrinsicHeight(
                                      child: Row(
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
                                                  borderRadius: BorderRadius.circular(5),
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
                                                      spacing: 6,
                                                      runSpacing: 0,
                                                      children: item.meePortion.map((meePortion) {
                                                        return ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedMeePortion = meePortion;
                                                              meatPrice = meePortion['price'];
                                                              calculateTotalPrice(
                                                                  drinkPrice(),
                                                                  choicePrice,
                                                                  calculateNoodlesPrice(),
                                                                  meatPrice, // Correctly updated meat price
                                                                  meePrice, // Ensure meePrice is properly updated before
                                                                  calculateSidesPrice(),
                                                                  addOnsPrice,
                                                                  soupOrKonlouPrice);
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor: WidgetStateProperty.all<Color>(
                                                              selectedMeePortion != null && selectedMeePortion!['name'] == meePortion['name']
                                                                  ? Colors.orange
                                                                  : Colors.white,
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
                                                              color: selectedMeePortion != null && selectedMeePortion!['name'] == meePortion['name']
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
                                          if (item.meePortion.isNotEmpty) const SizedBox(width: 10),
                                          if (item.meatPortion.isNotEmpty) ...[
                                            Expanded(
                                              flex: 4,
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
                                                      'Select Meat Portion',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Wrap(
                                                      spacing: 6,
                                                      runSpacing: 0,
                                                      children: item.meatPortion.map((meatPortion) {
                                                        return ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedMeatPortion = meatPortion;
                                                              meatPrice = meatPortion['price'];
                                                              calculateTotalPrice(
                                                                  drinkPrice(),
                                                                  choicePrice,
                                                                  calculateNoodlesPrice(),
                                                                  meatPrice, // Correctly updated meat price
                                                                  meePrice, // Ensure meePrice is properly updated before
                                                                  calculateSidesPrice(),
                                                                  addOnsPrice,
                                                                  soupOrKonlouPrice);
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor: WidgetStateProperty.all<Color>(
                                                              selectedMeatPortion != null && selectedMeatPortion!['name'] == meatPortion['name']
                                                                  ? Colors.orange
                                                                  : Colors.white,
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
                                                              color: selectedMeatPortion != null && selectedMeatPortion!['name'] == meatPortion['name']
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
                                                        // labelText: 'Write Additional Comments here',
                                                        // labelStyle: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey),
                                                        ),
                                                      ),
                                                      onChanged: (text) {
                                                        // This callback is called each time the text changes
                                                        setState(() {
                                                          // Add the user's comment with a key of '100'
                                                          itemRemarks['100'] = text;
                                                          SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
                                                            (a, b) => int.parse(a).compareTo(int.parse(b)),
                                                          )..addAll(itemRemarks);
                                                          itemRemarks = sortedItemRemarks;
                                                          item.itemRemarks = itemRemarks;
                                                          // print(item.itemRemarks);
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
                                                item.selectedAddOn = selectedAddOn;
                                                item.selectedDrink = selectedDrink;
                                                item.selectedTemp = selectedTemp;
                                                item.selectedSoupOrKonLou = selectedSoupOrKonLou;

                                                updateItemRemarks(
                                                  selectedMeePortion: selectedMeePortion,
                                                  selectedMeatPortion: selectedMeatPortion,
                                                  item: item,
                                                );
                                                calculateTotalPrice(drinkPrice(), choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                    calculateSidesPrice(), addOnsPrice, soupOrKonlouPrice);
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

        // The main display ui for selected Order - Item Name and Price
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // item image and index
                  // if (calculateTextLength(
                  //       originalName: item.originalName,
                  //       selectedChoice: item.selectedChoice,
                  //       selectedDrink: item.selectedDrink,
                  //       index: index,
                  //     ) <
                  //     25)
                  Wrap(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.selection == false || item.selectedChoice != null)
                                      Row(
                                        children: [
                                          Text(
                                            '${index + 1}.${item.originalName}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          if (item.tapao != false)
                                            const Icon(
                                              Icons.takeout_dining_sharp,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                        ],
                                      ),
                                    if (item.selectedChoice != null)
                                      Text(
                                        '${item.selectedChoice?['name']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                  ],
                                ),
                                if (item.selectedDrink != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              if (item.selectedDrink?['name'].isNotEmpty)
                                                Text(
                                                  '${index + 1}.${item.originalName} ',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              const SizedBox(width: 4),
                                              if (item.tapao != false)
                                                const Icon(
                                                  Icons.takeout_dining_sharp,
                                                  color: Colors.yellow,
                                                  size: 16,
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (item.originalName != item.selectedDrink!['name'])
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${item.selectedDrink?['name']}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.yellow,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (item.originalName != item.selectedDrink!['name']) const SizedBox(width: 5),
                                              item.selection
                                                  ? item.selectedTemp != null
                                                      ? Text(
                                                          '- ${item.selectedTemp?["name"]}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: item.selectedTemp?['name'] == 'Hot' ? Colors.orangeAccent : Colors.green[400],
                                                          ),
                                                        )
                                                      : const SizedBox.shrink()
                                                  : Text(
                                                      '${index + 1}. ${item.selectedTemp?["name"]}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            showEditBtn
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'x ${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 16,
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
                                              item.tapao = !item.tapao;
                                              widget.updateOrderStatus!();
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: item.tapao ? Colors.red : const Color.fromARGB(255, 12, 120, 202), // Background color
                                              borderRadius: BorderRadius.circular(5), // Border radius
                                            ),
                                            child: const Icon(
                                              Icons.takeout_dining_outlined,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              item.quantity++;
                                              widget.selectedOrder.updateTotalCost(0);
                                              widget.selectedOrder.calculateItemsAndQuantities();
                                              widget.updateOrderStatus!();
                                            });
                                            _showCherryToast(
                                              'check_circle',
                                              '${item.name} (RM ${item.price.toStringAsFixed(2)})',
                                              2000, // Toast duration in milliseconds
                                              500, // Animation duration in milliseconds
                                            );
                                            // CherryToast(
                                            //   icon: Icons.check_circle,
                                            //   iconColor: Colors.green,
                                            //   themeColor: const Color.fromRGBO(46, 125, 50, 1),
                                            //   backgroundColor: Colors.white,
                                            //   title: Text(
                                            //     '${item.name} (RM ${item.price.toStringAsFixed(2)})',
                                            //     style: const TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.black,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            //   toastPosition: Position.top,
                                            //   toastDuration: const Duration(milliseconds: 1000),
                                            //   animationType: AnimationType.fromTop,
                                            //   animationDuration: const Duration(milliseconds: 200),
                                            //   autoDismiss: true,
                                            //   displayCloseButton: false,
                                            // ).show(context);
                                          },
                                          child: Container(
                                            width: 30, // Adjust this value to change the width of the rectangle
                                            height: 30, // Adjust this value to change the height of the rectangle
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
                                        const SizedBox(width: 8),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (item.quantity > 1) {
                                                item.quantity--;
                                                widget.selectedOrder.updateTotalCost(0);
                                                widget.selectedOrder.calculateItemsAndQuantities();
                                                widget.updateOrderStatus!();
                                                _showCherryToast(
                                                  'remove_circle',
                                                  '${item.name} (RM ${item.price.toStringAsFixed(2)})',
                                                  2000, // Toast duration in milliseconds
                                                  500, // Animation duration in milliseconds
                                                );
                                                // CherryToast(
                                                //   icon: Icons.remove_circle,
                                                //   iconColor: Colors.red,
                                                //   themeColor: Colors.red,
                                                //   backgroundColor: Colors.white,
                                                //   title: Text(
                                                //     '${item.name} (RM ${price.toStringAsFixed(2)})',
                                                //     style: const TextStyle(
                                                //       fontSize: 14,
                                                //       color: Colors.black,
                                                //       fontWeight: FontWeight.bold,
                                                //     ),
                                                //   ),
                                                //   toastPosition: Position.top,
                                                //   toastDuration: const Duration(milliseconds: 1000),
                                                //   animationType: AnimationType.fromTop,
                                                //   animationDuration: const Duration(milliseconds: 200),
                                                //   autoDismiss: true,
                                                //   displayCloseButton: false,
                                                // ).show(context);
                                              } else if (item.quantity == 1) {
                                                _showCherryToast(
                                                  'info',
                                                  "Swipe left/right to remove the item",
                                                  2000, // Toast duration in milliseconds
                                                  500, // Animation duration in milliseconds
                                                );
                                                // CherryToast(
                                                //   icon: Icons.info,
                                                //   iconColor: Colors.green,
                                                //   themeColor: Colors.green,
                                                //   backgroundColor: Colors.white,
                                                //   title: const Text(
                                                //     "Swipe left/right to remove the item",
                                                //     style: TextStyle(
                                                //       fontSize: 14,
                                                //       color: Colors.black,
                                                //       fontWeight: FontWeight.bold,
                                                //     ),
                                                //   ),
                                                //   toastPosition: Position.top,
                                                //   toastDuration: const Duration(milliseconds: 1000),
                                                //   animationType: AnimationType.fromTop,
                                                //   animationDuration: const Duration(milliseconds: 200),
                                                //   autoDismiss: true,
                                                //   displayCloseButton: false,
                                                // ).show(context);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 30, // Adjust this value to change the width of the rectangle
                                            height: 30, // Adjust this value to change the height of the rectangle
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
                ],
              ),
            ),

            // item is to be remained because the ui will be updated from another page. So they are directly got their values such as selectedSide, selectedNoodelsType data from item.
            Row(
              children: [
                // Check if either itemRemarks or selectedSide are non-null and not empty
                if ((item.itemRemarks?.isNotEmpty ?? false) || (item.selectedSide?.isNotEmpty ?? false) || (item.selectedNoodlesType?.isNotEmpty ?? false))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (item.selectedSoupOrKonLou != null)
                                Text(
                                  '${item.selectedSoupOrKonLou!['name']} ',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.yellow,
                                  ),
                                ),

                              // Safely handle selectedNoodles and ensure it's not null or empty
                              if (item.selectedNoodlesType != null && item.selectedNoodlesType!.isNotEmpty)
                                Text(
                                  item.selectedNoodlesType!.map((noodleType) => noodleType['name']).join(', '),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          Wrap(
                            children: [
                              // Item Remarks & Comments UI
                              if (item.itemRemarks != null && item.itemRemarks!.isNotEmpty)
                                Text(
                                  item.itemRemarks?.values.join(', ') ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          // Safely handle selectedSide and ensure it's not null or empty
                          if (item.selectedSide != null && item.selectedSide!.isNotEmpty)
                            Text(
                              item.selectedSide!.map((side) => side['name']).join(', '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.yellow,
                              ),
                            ),
                        ],
                      ),
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
        // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets.
        key: Key(item.id.toString()),
        confirmDismiss: (direction) async {
          // Check if showEditBtn is true; if so, prevent dismiss
          if (showEditBtn) {
            return Future.value(false);
          }

          // Otherwise, show the custom confirmation dialog
          final bool? shouldDelete = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.zero, // Makes dialog full-screen if needed
                backgroundColor: Colors.black87,
                child: AlertDialog(
                  backgroundColor: const Color(0xff1f2029),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.deepOrange, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 160,
                    ),
                    child: Column(
                      // alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Are you sure?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Please note, once cancelled, the action is irreversible.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Return true if confirmed
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // Return false if canceled
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Set the desired border radius here
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          // Allow or prevent dismiss based on the confirmation dialog result
          return shouldDelete == true;
        },
        onDismissed: (direction) {
          // Remove the item from the data source
          setState(() {
            widget.selectedOrder.items.remove(item);
            widget.selectedOrder.updateTotalCost(0);
            widget.selectedOrder.calculateItemsAndQuantities();
            widget.updateOrderStatus!();
          });

          // Show a notification
          _showCherryToast(
            'remove_circle',
            'Removed $name',
            1000, // Toast duration in milliseconds
            500, // Animation duration in milliseconds
          );
        },
        // Show a red background as the item is swiped away
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
                ),
              ],
            ),
          ),
        ),
        child: child,
      );
    }
  }
}
