// import 'dart:developer';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/data/categories_data.dart';
import 'package:jspos/providers/menu_items_provider.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';
import 'package:jspos/shared/product_item.dart';

class MenuPage extends ConsumerStatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback onClick;
  // final void Function() onClick and final VoidCallback hold a reference to a function that takes no arguments and returns void.
  // The main difference is that VoidCallback is a bit more concise and is commonly used in Flutter for event handlers and callbacks.
  final Function(Item) onItemAdded;
  const MenuPage({super.key, required this.selectedOrder, required this.onClick, required this.onItemAdded});
  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  String selectedCategory = categories[0];

  @override
  void initState() {
    super.initState();
    // Load the menu when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenu();
    });
  }

  Widget _closedButton() {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.onClick(); // Call the callback passed from the parent widget
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.green[800]!),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 6, 12, 6)), // Add padding inside the button
        ),
        child: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 5),
              Text('CLOSE', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuProvider);
    // log('Menu Items: ${menuItems.length}');

    // log('Selected Category: $selectedCategory');

    var filteredItems = menuItems.where((item) {
      if (item.category == selectedCategory) {
        // log('Item matched: ${item.name}');
        return true;
      }
      return false;
    }).toList();

    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    log(screenWidth.toString());

    // Determine the crossAxisCount based on the screen width
    int numberOfItems = screenWidth > 1200 ? 5 : 4;

    // log('Filtered Items: ${filteredItems.length}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories of Menu
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: SizedBox(
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: _itemTab(
                              title: category,
                              isActive: selectedCategory == category,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  _closedButton(), // Add the close button here
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              // decoration: const BoxDecoration(
              //     color: Colors.white,
              //     ),
              child: GridView.count(
                crossAxisCount: numberOfItems,
                childAspectRatio: (1 / 1.15), // width 1 / height 1.15 previously is 1.3
                crossAxisSpacing: 14, // Add horizontal spacing
                mainAxisSpacing: 14, // Add vertical spacing// set the individual container height
                children:  filteredItems.map((item) {
                  return ProductItem(
                    // onItemAdded: widget.onItemAdded,
                    // id: item['id'],
                    // name: item['name'],
                    // image: item['image'],
                    // category: item['category'],
                    // price: item['price'],
                    // selection: item['selection'] ?? false,
                    // drinks: item['drinks'] ?? [],
                    // temp: item['temp'] ?? [],
                    // choices: item['choices'] ?? [],
                    // noodlesTypes: item['noodlesTypes'] ?? [],
                    // meatPortion: item['meat portion'] ?? [],
                    // meePortion: item['mee portion'] ?? [],
                    // sides: item['sides'] ?? [],
                    // addMilk: item['add milk'] ?? [],
                    // addOns: item['add on'] ?? [],
                    // tapao: item['tapao'] ?? false,
                    // soupOrKonLou: item['soupOrKonLou'] ?? [],
                    onItemAdded: widget.onItemAdded,
                    id: item.id,
                    name: item.name,
                    image: item.image,
                    category: item.category,
                    price: item.price,
                    selection: item.selection,
                    drinks: item.drinks,
                    temp: item.temp,
                    choices: item.choices,
                    noodlesTypes: item.noodlesTypes,
                    meatPortion: item.meatPortion,
                    meePortion: item.meePortion,
                    sides: item.sides,
                    addMilk: item.addMilk,
                    addOns: item.addOns,
                    tapao: item.tapao,
                    soupOrKonLou: item.soupOrKonLou,
                    setDrinks: item.setDrinks,
                  );
                  
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTab({
    // required String icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff1f2029),
          border: isActive ? Border.all(color: const Color.fromRGBO(46, 125, 50, 1), width: 2) : Border.all(color: const Color(0xff1f2029), width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }
}


//menu page, dine in page (no need), order details (no need)