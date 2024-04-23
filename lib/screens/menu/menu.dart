import 'package:flutter/material.dart';
import 'package:jspos/data/menu_data.dart';
import 'package:jspos/models/selected_table_order.dart';

class MenuPage extends StatefulWidget {
  final SelectedTableOrder selectedOrder;
  final VoidCallback onClick;
  final Function(Item) onItemAdded;
  const MenuPage(
      {super.key,
      required this.selectedOrder,
      required this.onClick,
      required this.onItemAdded});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';
  Widget _closedButtton() {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.onClick(); // Call the callback passed from the parent widget
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Adjust this value as needed
            ),
          ),
        ),
        child: const Text('Close Menu',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 14,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _topMenu(
                title: 'SMH Restaurant',
                subTitle: '28 March 2024',
                action: _closedButtton(),
              ),
            ), // Add spacing between _topMenu and ListView
            // Categories of Menu
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = 'All';
                      });
                    },
                    child: _itemTab(
                      title: 'All',
                      isActive: selectedCategory == 'All',
                    ),
                  ),
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: (1 / 1.2),
                children: menu
                    .where((item) =>
                        selectedCategory == 'All' ||
                        item['category'] == selectedCategory)
                    .map((item) {
                  return _item(
                    id: item['id'],
                    name: item['name'],
                    image: item['image'],
                    category: item['category'],
                    price: item['price'],
                    selection: item['selection'] ?? false,
                    // if selection is null, default it to false.
                    choices: item['choices'] ?? [],
                    types: item['types'] ?? [],
                    meatPortion: item['meat portion'] ?? [],
                    meePortion: item['mee portion'] ?? [],
                    selectedChoice: {},
                    selectedType: {},
                    selectedMeatPortion: {},
                    selectedMeePortion: {},
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required String id,
    required String name,
    required String image,
    required String category,
    required double price,
    // required cannot have default value
    bool selection = false,
    List<Map<String, dynamic>> choices = const [],
    List<Map<String, dynamic>> types = const [],
    List<Map<String, dynamic>> meatPortion = const [],
    List<Map<String, dynamic>> meePortion = const [],
    Map<String, dynamic>? selectedChoice,
    Map<String, dynamic>? selectedType,
    Map<String, dynamic>? selectedMeatPortion,
    Map<String, dynamic>? selectedMeePortion,
  }) {
    return GestureDetector(
      onTap: () {
        Item item = Item(
          id: id,
          name: name,
          price: price,
          category: category,
          image: image,
          quantity: 1,
          selection: selection,
          selectedChoice: null,
          selectedType: null,
          selectedMeatPortion: null,
          selectedMeePortion: null,
        ); //this is creating a new instance of item with the required field.

        Map<String, dynamic>? selectedChoice =
            choices.isNotEmpty ? choices[0] : null;
        Map<String, dynamic>? selectedType = types.isNotEmpty ? types[0] : null;

        String? selectedMeatPortion =
            meatPortion.isNotEmpty ? meatPortion[0]['name'] : null;
        String? selectedMeePortion =
            meePortion.isNotEmpty ? meePortion[0]['name'] : null;
        double additionalPrice = types.isNotEmpty ? types[0]['price'] : 0.00;
        double totalPrice = item.price + additionalPrice;
        if (item.selection) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text(item.name, style: const TextStyle(fontSize: 24, color: Colors.black),),
                    backgroundColor: Colors.white,
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 600,
                        minHeight: 500,
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
                                          '${selectedChoice!['name']} (${selectedType!['name']})',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Total: RM ${totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      'x ${item.quantity}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // Second row
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title:
                                                  const Text('Select Flavor'),
                                              children: choices
                                                  .map<SimpleDialogOption>(
                                                      (choices) {
                                                return SimpleDialogOption(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedChoice = choices;
                                                      item.selectedChoice =
                                                          choices;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '${choices['name']} (RM ${choices['price'].toStringAsFixed(2)})',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          borderRadius: BorderRadius.circular(
                                              5), // This is the border radius
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          selectedChoice != null
                                              ? '${selectedChoice!['name']} (RM ${selectedChoice!['price'].toStringAsFixed(2)})'
                                              : 'Select Flavor',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title: const Text(
                                                  'Select Variation'),
                                              children: types
                                                  .map<SimpleDialogOption>(
                                                      (type) {
                                                return SimpleDialogOption(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedType = type;
                                                      item.selectedType = type;
                                                      additionalPrice =
                                                          type['price'];
                                                      totalPrice = item.price +
                                                          additionalPrice;
                                                      print(totalPrice);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '${type['name']} + RM ${type['price'].toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          borderRadius: BorderRadius.circular(
                                              5), // This is the border radius
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          selectedType != null
                                              ? '${selectedType!['name']} + RM ${selectedType!['price'].toStringAsFixed(2)}'
                                              : 'Select Variation',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
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
                    actions: [
                      TextButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          widget.onItemAdded(item);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          widget.onItemAdded(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xff1f2029),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RM ${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTab({
    // required String icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff1f2029),
          border: isActive
              ? Border.all(color: Colors.deepOrangeAccent, width: 3)
              : Border.all(color: const Color(0xff1f2029), width: 3)),
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
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                subTitle,
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Expanded(flex: 1, child: Container(width: double.infinity)),
          Container(child: action)
        ]);
  }
}
