import 'package:flutter/material.dart';
import 'package:jspos/data/menu_data.dart';
import 'package:jspos/shared/product_item.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/models/item.dart';

class MenuPage extends StatefulWidget {
  final SelectedOrder selectedOrder;
  final VoidCallback onClick;
  // final void Function() onClick and final VoidCallback hold a reference to a function that takes no arguments and returns void.
  // The main difference is that VoidCallback is a bit more concise and is commonly used in Flutter for event handlers and callbacks.
  final Function(Item) onItemAdded;
  const MenuPage({super.key, required this.selectedOrder, required this.onClick, required this.onItemAdded});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = categories[0];
  Widget _closedButtton() {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.onClick(); // Call the callback passed from the parent widget
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green[800]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Close', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Icon(
                Icons.cancel,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: _topMenu(
              title: 'SMH Restaurant',
              subTitle: 'today date',
              action: _closedButtton(),
            ),
          ), // Add spacing between _topMenu and ListView
          // Categories of Menu
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: SizedBox(
              height: 45,
              // padding: const EdgeInsets.symmetric(vertical: 0),
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
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom:10),
              // decoration: const BoxDecoration(
              //     color: Colors.white,
              //     ),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: (1 / 1.4), // width 1 / height 1.3
                crossAxisSpacing: 15, // Add horizontal spacing
                mainAxisSpacing: 14, // Add vertical spacing// set the individual container height
                children: menu
                    .where((item) =>
                        // selectedCategory == 'All' ||
                        item['category'] == selectedCategory)
                    .map((item) {
                  return ProductItem(
                    onItemAdded: widget.onItemAdded,
                    id: item['id'],
                    name: item['name'],
                    image: item['image'],
                    category: item['category'],
                    price: item['price'],
                    selection: item['selection'] ?? false,
                    choices: item['choices'] ?? [],
                    types: item['types'] ?? [],
                    meatPortion: item['meat portion'] ?? [],
                    meePortion: item['mee portion'] ?? [],
                    selectedChoice: null,
                    selectedType: null,
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
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff1f2029),
          border: isActive ? Border.all(color: Colors.deepOrangeAccent, width: 2) : Border.all(color: const Color(0xff1f2029), width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   icon,
          //   width: 55,
          // ),
          // const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }

  Widget _topMenu({
    required String title,
    required String subTitle,
    required action,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            subTitle,
            style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Expanded(flex: 1, child: Container(width: double.infinity)),
      Container(child: action)
    ]);
  }
}
