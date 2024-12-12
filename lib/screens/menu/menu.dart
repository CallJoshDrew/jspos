import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/data/categories_data.dart';
import 'package:jspos/providers/menu_items_provider.dart';
import 'package:jspos/shared/menu_item.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';

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
    // log('Menu items count: ${menuItems.length}');
    var filteredItems = menuItems.where((item) {
      if (item.category == selectedCategory) {
        // log('Matched item: ${item.name} ${item.category}, Selected: $selectedCategory');
        return true;
      }
      return false;
    }).toList();
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
                crossAxisCount: 4,
                childAspectRatio: (1 / 1.3), // width 1 / height 1.3
                crossAxisSpacing: 20, // Add horizontal spacing
                mainAxisSpacing: 14, // Add vertical spacing// set the individual container height
                children: filteredItems.map((item) {
                  try {
                    return MenuItem(
                      onItemAdded: widget.onItemAdded,
                      item: item,
                      id: item.id,
                      name: item.name,
                      originalName: item.originalName,
                      image: item.image,
                      category: item.category,
                      price: item.price,
                      selection: item.selection,
                      drinks: item.drinks,
                      temp: item.temp,
                      choices: item.choices,
                      noodlesTypes: item.noodlesTypes,
                      soupOrKonLou: item.soupOrKonLou,
                      sides: item.sides,
                      addMilk: item.addMilk,
                      addOns: item.addOns,
                      meePortion: item.meePortion,
                      meatPortion: item.meatPortion,
                      tapao: item.tapao,
                      selectedDrink: item.drinks.isNotEmpty ? item.drinks[0] : null,
                      selectedTemp: item.temp.isNotEmpty ? item.temp[0] : null,
                      selectedChoice: item.choices.isNotEmpty ? item.choices[0] : null,
                      selectedNoodlesType: item.noodlesTypes.isNotEmpty ? item.noodlesTypes[0] : null,
                      selectedSoupOrKonLou: item.soupOrKonLou.isNotEmpty ? item.soupOrKonLou[0] : null,
                      selectedSide: item.sides.isNotEmpty ? item.sides[0] : null,
                      selectedAddMilk: item.addMilk.isNotEmpty ? item.addMilk[0] : null,
                      selectedAddOn: item.addOns.isNotEmpty ? item.addOns[0] : null,
                      selectedMeePortion: item.meePortion.isNotEmpty ? item.meePortion[0] : null,
                      selectedMeatPortion: item.meatPortion.isNotEmpty ? item.meatPortion[0] : null,
                    );
                  } catch (e) {
                    log('Error creating MenuItem: $e');
                    return Container();
                  }
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