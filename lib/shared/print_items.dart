import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:jspos/data/menu_data.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/providers/orders_provider.dart';

class PrintItemsPage extends ConsumerStatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback? updateOrderStatus;

  final List<Map<String, dynamic>> tables;
  final int selectedTableIndex;
  final void Function(int index, String orderNumber, bool isOccupied) updateTables;
  final bool isTableInitiallySelected;

  const PrintItemsPage({
    super.key,
    required this.selectedOrder,
    required this.updateOrderStatus,
    required this.tables,
    required this.selectedTableIndex,
    required this.updateTables,
    required this.isTableInitiallySelected,
  });

  @override
  PrintItemsPageState createState() => PrintItemsPageState();
}

class PrintItemsPageState extends ConsumerState<PrintItemsPage> {
  late Orders orders; // No need to reinitialize here directly.
  String selectedPrinter = "All";
  final printerNames = ['All', 'Cashier', 'Kitchen', 'Beverage'];

  late bool isTableSelected;
  bool isSelectedAll = true;
  bool isAnyCategorySelected = false; // Track if any category is selected
  List<Item> currentFilteredItems = [];

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

  void _navigateBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  // A map to keep track of selected items, categorized by category
  Map<String, List<Item>> selectedItems = {};

  // Function to toggle item selection
  void toggleItemSelection(String category, Item item) {
    setState(() {
      if (selectedItems[category] == null) {
        selectedItems[category] = [];
      }
      if (selectedItems[category]!.contains(item)) {
        selectedItems[category]!.remove(item);
        log('Item removed: ${item.name} from category $category');
      } else {
        selectedItems[category]!.add(item);
        log('Item added: ${item.name} to category $category');
      }

      // Log the entire selectedItems map for tracking
      log('Updated selectedItems: ${selectedItems.map((k, v) => MapEntry(k, v.map((item) => item.name).toList()))}');
    });
  }

  void toggleCategoryItems(String category) {
    setState(() {
      if (selectedItems.containsKey(category) && selectedItems[category]!.isNotEmpty) {
        // Deselect category if items are already selected
        selectedItems[category] = [];
      } else {
        // Select all items of the category
        selectedItems[category] = widget.selectedOrder.items.where((item) => item.category == category).toList();
      }

      // Update isSelectedAll
      isSelectedAll = selectedItems.keys.every((key) => selectedItems[key]?.isNotEmpty ?? false);

      // Update isAnyCategorySelected
      isAnyCategorySelected = selectedItems.values.any((items) => items.isNotEmpty);

      log('$category items toggled');
    });
  }

  void selectAllItems() {
    setState(() {
      isSelectedAll = true;
      // Group items by category
      selectedItems = {};
      for (var item in widget.selectedOrder.items) {
        final category = item.category; // Assuming `Item` has a `category` field
        if (selectedItems[category] == null) {
          selectedItems[category] = [];
        }
        selectedItems[category]!.add(item);
      }

      // Update isAnyCategorySelected
      isAnyCategorySelected = true;

      log('All items selected in all categories');
    });
  }

  void deselectAllItems() {
    setState(() {
      isSelectedAll = false;
      // Clear all items in each category
      selectedItems = selectedItems.map((category, items) {
        return MapEntry(category, []);
      });

      // Update isAnyCategorySelected
      isAnyCategorySelected = false;

      log('All items deselected in all categories');
    });
  }

  Widget buildLongDottedLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 3.0;
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
    );
  }

  Widget buildDottedLine() {
    return Container(
      width: 85.0, // Set the desired width for the dotted line here
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 3.0; // Width of each dot
          const dashSpacing = 3.0; // Space between dots

          final dashCount = (boxWidth / (dashWidth + dashSpacing)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.end, // Aligns the dots to the right
            children: List.generate(dashCount, (_) {
              return Row(
                children: <Widget>[
                  Container(width: dashWidth, height: 2, color: Colors.black87),
                  const SizedBox(width: dashSpacing),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  // Example of your categories list
  final List<String> categories = ["Cakes", "Dishes", "Drinks", "Special", "Add On"];

// Printer-Category Mapping
  static const printerCategories = {
    'Cashier': ["Cakes", "Dishes", "Drinks", "Special", "Add On"],
    'Kitchen': ["Dishes", "Special", "Add On"],
    'Beverage': ["Drinks"],
  };

// Grouping logic: Organize items by their assigned printers
  Map<String, List<Item>> groupItemsByPrinter(Map<String, List<Item>> selectedItems) {
    // Initialize the map with empty lists for each printer.
    Map<String, List<Item>> printerItems = {
      'Cashier': [],
      'Kitchen': [],
      'Beverage': [],
    };

    // Iterate over selected items and assign them to the appropriate printer.
    selectedItems.forEach((category, items) {
      printerCategories.forEach((printer, printerCategoriesList) {
        if (printerCategoriesList.contains(category)) {
          printerItems[printer]!.addAll(items); // Assign items to the printer group.
        }
      });
    });

    return printerItems;
  }

  List<Item> getFilteredItemsByPrinter(String printer) {
    if (printer == "All") {
      // Aggregate items from all categories for each printer
      List<Item> allItems = [];
      printerCategories.forEach((printerKey, categoriesList) {
        for (var category in categoriesList) {
          if (selectedItems.containsKey(category)) {
            allItems.addAll(selectedItems[category]!);
          }
        }
      });
      return allItems;
    } else {
      // Filter items for a specific printer
      List<Item> filteredItems = [];
      if (printerCategories.containsKey(printer)) {
        for (var category in printerCategories[printer]!) {
          if (selectedItems.containsKey(category)) {
            filteredItems.addAll(selectedItems[category]!);
          }
        }
      }
      return filteredItems;
    }
  }

  void updateSelectedPrinter(String printer) {
    setState(() {
      selectedPrinter = printer;
      currentFilteredItems = getFilteredItemsByPrinter(selectedPrinter);
    });
  }

  void sendToPrinter(Map<String, List<Item>> selectedItems) {
    Map<String, List<Item>> printerItems = groupItemsByPrinter(selectedItems);

    printerItems.forEach((printer, items) {
      // Send the grouped items to the relevant printer.
      log('Sending to $printer: ${items.length} items.');
    });
  }

  @override
  void initState() {
    super.initState();
    orders = ref.read(ordersProvider);
    selectAllItems();
    isTableSelected = widget.isTableInitiallySelected;
    currentFilteredItems = getFilteredItemsByPrinter(selectedPrinter);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Get the screen size
    var statusBarHeight = MediaQuery.of(context).padding.top; // Get the status bar height

    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Set the border radius here
        ),
        insetPadding: const EdgeInsets.only(top: 25), // Remove any padding
        child: SizedBox(
          width: screenSize.width, // Set width to screen width
          height: screenSize.height - statusBarHeight, // Subtract the status bar height from the screen height
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      color: Color.fromRGBO(46, 125, 50, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedOrder.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Select Items to Print',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.selectedOrder.orderTime} -',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.selectedOrder.orderDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              // Select All Button
                              Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                margin: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff1f2029),
                                  borderRadius: BorderRadius.circular(5.0), // Rounded corners (optional)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all<Color>(
                                          Colors.white,
                                          // isSelectedAll ? Colors.white : Colors.black,
                                        ),
                                        backgroundColor: WidgetStateProperty.all<Color>(
                                          const Color(0xff1f2029),
                                          // isSelectedAll ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
                                        ),
                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                        ),
                                        // Set minimum size for the button
                                        minimumSize: WidgetStateProperty.all<Size>(const Size(40, 30)),
                                      ),
                                      onPressed: selectAllItems,
                                      child: Row(
                                        children: [
                                          Icon(isSelectedAll ? Icons.check_box : Icons.check_box_outline_blank, size: 20, color: Colors.white),
                                          // color: isSelectedAll ? Colors.white : Colors.black),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'All',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Dynamically created category buttons

                                    for (var category in categories)
                                      if (widget.selectedOrder.items.any((item) => item.category == category))
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            foregroundColor: WidgetStateProperty.all<Color>(Colors.white
                                                // selectedItems[category]?.isNotEmpty == true ? Colors.white : Colors.black,
                                                ),
                                            backgroundColor: WidgetStateProperty.all<Color>(
                                              const Color(0xff1f2029),
                                              // selectedItems[category]?.isNotEmpty == true ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
                                            ),
                                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all(
                                              const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                            ),
                                            minimumSize: WidgetStateProperty.all<Size>(const Size(40, 30)),
                                          ),
                                          onPressed: () => toggleCategoryItems(category),
                                          child: Row(
                                            children: [
                                              Icon(
                                                selectedItems[category]?.isNotEmpty == true ? Icons.check_box : Icons.check_box_outline_blank,
                                                size: 20,
                                                // color: Colors.white,
                                                color: selectedItems[category]?.isNotEmpty == true ? Colors.green : Colors.white,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                category,
                                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                    // Deselect All Button
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all<Color>(
                                          Colors.white,
                                          // isSelectedAll ? Colors.black : Colors.white,
                                        ),
                                        backgroundColor: WidgetStateProperty.all<Color>(
                                          const Color(0xff1f2029),
                                          // isSelectedAll ? Colors.white : const Color.fromRGBO(46, 125, 50, 1),
                                        ),
                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                        ),
                                        minimumSize: WidgetStateProperty.all<Size>(const Size(40, 30)),
                                      ),
                                      onPressed: deselectAllItems,
                                      child: Row(
                                        children: [
                                          Icon(
                                            !isSelectedAll && !isAnyCategorySelected ? Icons.check_box : Icons.check_box_outline_blank,
                                            size: 20,
                                            color: Colors.white,
                                            // color: isSelectedAll ? Colors.black : Colors.white,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'Remove',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: () {
                                  Map<String, List<Item>> categorizedItems = categorizeItems(widget.selectedOrder.items);
                                  Map<String, int> totalQuantities = calculateTotalQuantities(categorizedItems);

                                  List<Widget> categoryWidgets = [];

                                  // Iterate through categories in the desired order
                                  for (var category in categories) {
                                    if (categorizedItems.containsKey(category)) {
                                      var items = categorizedItems[category]!;

                                      // Add category header with total quantity
                                      categoryWidgets.add(
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                                          child: Text(
                                            '$category: ${totalQuantities[category] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );

                                      // Add items within each category, keeping track of index and item
                                      categoryWidgets.add(
                                        Column(
                                          children: items.asMap().entries.map((entry) {
                                            int index = entry.key; // Item index within the category
                                            Item item = entry.value; // The item itself

                                            return Container(
                                              padding: const EdgeInsets.all(6),
                                              margin: const EdgeInsets.fromLTRB(0, 0, 15, 6),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: const Color(0xff1f2029),
                                              ),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: selectedItems[category]?.contains(item) ?? false,
                                                    onChanged: (bool? selected) {
                                                      toggleItemSelection(category, item); // Toggle individual item
                                                    },
                                                    activeColor: Colors.green,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              item.selection && item.selectedChoice != null
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                          item.originalName == item.selectedChoice!['name']
                                                                              ? '${index + 1}.${item.originalName}'
                                                                              : '${index + 1}.${item.originalName} ${item.selectedChoice!['name']}',
                                                                          style: const TextStyle(
                                                                            fontSize: 14,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Text(
                                                                      item.selectedDrink != null
                                                                          ? '${index + 1}.${item.originalName} ${item.selectedDrink?['name']} - ${item.selectedTemp?["name"]}'
                                                                          : '${index + 1}.${item.originalName}',
                                                                      style: const TextStyle(
                                                                        fontSize: 14,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 12),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    item.selection &&
                                                                            item.selectedNoodlesType != null &&
                                                                            item.selectedNoodlesType!['name'] != 'None'
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                "${item.selectedNoodlesType!['name']} ",
                                                                                style: const TextStyle(fontSize: 14, color: Colors.white),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    item.selection && item.selectedSoupOrKonLou != null
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                "- ${item.selectedSoupOrKonLou!['name']} ",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                                item.selection &&
                                                                        item.selectedMeePortion != null &&
                                                                        item.selectedMeePortion!['name'] != "Normal Mee"
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeePortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection &&
                                                                        item.selectedMeatPortion != null &&
                                                                        item.selectedMeatPortion!['name'] != "Normal Meat"
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "${item.selectedMeatPortion!['name']} ",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection && item.selectedSide!.isNotEmpty
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "Total Sides: ${(item.selectedSide?.length)}",
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.yellow,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                item.selection && item.selectedSide != null
                                                                    ? Wrap(
                                                                        children: [
                                                                          for (var side in item.selectedSide!.toList())
                                                                            Wrap(
                                                                              children: [
                                                                                Text(
                                                                                  "${side['name']} ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "${side != item.selectedSide!.last ? ', ' : ''} ",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                                Wrap(
                                                                  children: [
                                                                    item.selection && filterRemarks(item.itemRemarks).isNotEmpty == true
                                                                        ? Row(
                                                                            children: [
                                                                              const Text(
                                                                                'Remarks: ',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                getFilteredRemarks(item.itemRemarks),
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
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
                                                    'x ${item.quantity}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }
                                  }
                                  return categoryWidgets;
                                }(),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: const Color(0xff1f2029),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 2, 12, 2)),
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
                                                        side: const BorderSide(color: Colors.green, width: 1), // This is the border color
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      content: ConstrainedBox(
                                                        constraints: const BoxConstraints(
                                                          maxWidth: 600,
                                                          maxHeight: 100,
                                                        ),
                                                        child: const Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Are you sure?',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
                                                            ),
                                                            Wrap(
                                                              alignment: WrapAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'Please confirm before we ',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'proceed for printing',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ],
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
                                                                onPressed: () async {
                                                                  log('You have confirmed');
                                                                },
                                                                child: const Padding(
                                                                  padding: EdgeInsets.all(6),
                                                                  child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)),
                                                                ),
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
                                            },
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.print,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Print',
                                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
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
                                            widget.selectedOrder.discount = 0;
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        printerNames.length,
                                        (index) {
                                          final value = printerNames[index];
                                          final isLastItem = index == printerNames.length - 1; // Check if it's the last item

                                          return Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      foregroundColor: WidgetStateProperty.all<Color>(
                                                        selectedPrinter == value ? Colors.white : Colors.black87,
                                                      ),
                                                      backgroundColor: WidgetStateProperty.all<Color>(
                                                        selectedPrinter == value ? const Color.fromRGBO(46, 125, 50, 1) : Colors.white,
                                                      ),
                                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                      ),
                                                      padding: WidgetStateProperty.all(
                                                        const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                                      ),
                                                      minimumSize: WidgetStateProperty.all<Size>(const Size(40, 30)),
                                                    ),
                                                    onPressed: () {
                                                      updateSelectedPrinter(value);
                                                    },
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                // Add spacing except for the last button
                                                if (!isLastItem) const SizedBox(width: 10),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                                  children: [
                                    // Group the items by printers.
                                    ...groupItemsByPrinter(selectedItems).entries.map((entry) {
                                      String printer = entry.key; // Printer name
                                      List<Item> items = entry.value;

                                      // Only display if there are items for this printer
                                      if (items.isNotEmpty) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Display the printer name.
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1f2029),
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              child: Text(
                                                printer, // Printer name displayed
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            // Display each item's index, name, and quantity.
                                            ...items.asMap().entries.map((entry) {
                                              int index = entry.key + 1; // 1-based index
                                              Item item = entry.value;

                                              return Padding(
                                                padding: const EdgeInsets.only(right: 12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '$index. ${item.name}', // Index and item name
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      'x ${item.quantity}', // Quantity
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                            buildLongDottedLine(),
                                            // Display total items for this printer
                                            Padding(
                                              padding: const EdgeInsets.only(right: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${items.fold<int>(0, (sum, item) => sum + item.quantity)}',
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                buildDottedLine(),
                                              ],
                                            ),
                                            const SizedBox(height: 6), // Add some spacing below each printer section
                                          ],
                                        );
                                      } else {
                                        return Container(); // Return an empty container if no items
                                      }
                                    }), // Ensure to convert the iterable to a list
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
