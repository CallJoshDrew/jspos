import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jspos/data/remarks.dart';
import 'package:jspos/models/item.dart';

class ProductItem extends StatefulWidget {
  final Function(Item) onItemAdded;
  final String id;
  final String name;
  final String image;
  final String category;
  final double price;
  final bool selection;
  final List<Map<String, dynamic>> choices;
  final List<Map<String, dynamic>> types;
  final List<Map<String, dynamic>> meatPortion;
  final List<Map<String, dynamic>> meePortion;
  final Map<String, dynamic>? selectedChoice;
  final Map<String, dynamic>? selectedType;

  const ProductItem({
    super.key,
    required this.onItemAdded,
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    this.selection = false,
    required this.choices,
    required this.types,
    required this.meatPortion,
    required this.meePortion,
    this.selectedChoice,
    this.selectedType,
  });

  @override
  ProductItemState createState() => ProductItemState();
}

class ProductItemState extends State<ProductItem> {
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Item item = Item(
          id: widget.id,
          name: widget.name,
          price: widget.price,
          category: widget.category,
          image: widget.image,
          quantity: 1,
          selection: widget.selection,
          choices: widget.choices,
          types: widget.types,
          meatPortion: widget.meatPortion,
          meePortion: widget.meePortion,
          selectedChoice: widget.choices.isNotEmpty ? widget.choices[0] : null,
          selectedType: widget.types.isNotEmpty ? widget.types[0] : null,
        ); //this is creating a new instance of item with the required field.
        Map<String, dynamic>? selectedChoice =
            widget.choices.isNotEmpty ? widget.choices[0] : null;
        Map<String, dynamic>? selectedType =
            widget.types.isNotEmpty ? widget.types[0] : null;

        double choicePrice =
            widget.choices.isNotEmpty && widget.choices[0]['price'] != null
                ? widget.choices[0]['price']!
                : 0.00;
        double typePrice =
            widget.types.isNotEmpty && widget.types[0]['price'] != null
                ? widget.types[0]['price']!
                : 0.00;

        double totalPrice = choicePrice + typePrice;

        void calculateTotalPrice(double choicePrice, double typePrice) {
          setState(() {
            totalPrice = choicePrice + typePrice;
            // print('Price of Selected Choice: $choicePrice');
            // print('Price of Selected Type: $typePrice');
            // print('Price of Selected Meat: $meatPrice');
            // print('Price of Selected Mee: $meePrice');
            // print('Total Price: $totalPrice');
            // print('-------------------------');
          });
        }

        Widget remarkButton(Map<String, dynamic> data) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  // Check if the remark has been added to itemRemarks
                  if (itemRemarks.containsKey(data['id'].toString())) {
                    // If the button is pressed or the remark has been added, make the background green
                    return states.contains(MaterialState.pressed)
                        ? Colors.green[700]!
                        : Colors.green;
                  } else {
                    // If the button is pressed or the remark has not been added, make the background black
                    return states.contains(MaterialState.pressed)
                        ? Colors.green
                        : Colors.black;
                  }
                },
              ),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.white)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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

                // Add the user's comment with a key of '100'
                itemRemarks['100'] = _controller.text;

                SplayTreeMap<String, dynamic> sortedItemRemarks =
                    SplayTreeMap<String, dynamic>(
                  (a, b) => int.parse(a).compareTo(int.parse(b)),
                )..addAll(itemRemarks);
                itemRemarks = sortedItemRemarks;
                item.itemRemarks = itemRemarks;
                print(itemRemarks);
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

        if (item.selection) {
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
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.black,
                      // second color const Color(0xff1f2029),
                      shadowColor: Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.deepOrange,
                            width: 2), // This is the border color
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
                                          selectedChoice != null &&
                                                  selectedType != null
                                              ? '${selectedChoice!['name']} (${selectedType!['name']})'
                                              : 'Select Flavor and Type',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Text(
                                          'RM ${totalPrice.toStringAsFixed(2)}',
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
                                      child: widget.choices.isNotEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text(
                                                          'Select Flavor'),
                                                      children: widget.choices
                                                          .map<SimpleDialogOption>(
                                                              (choice) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedChoice =
                                                                  choice;
                                                              item.selectedChoice =
                                                                  choice;
                                                              choicePrice =
                                                                  choice[
                                                                      'price'];
                                                            });
                                                            calculateTotalPrice(
                                                                choicePrice,
                                                                typePrice);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            '${choice['name']} (RM ${choice['price'].toStringAsFixed(2)})',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5), // This is the border radius
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
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
                                      child: widget.types.isNotEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text(
                                                          'Select Variation'),
                                                      children: widget.types
                                                          .map<SimpleDialogOption>(
                                                              (type) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedType =
                                                                  type;
                                                              item.selectedType =
                                                                  type;
                                                              typePrice =
                                                                  type['price'];
                                                            });
                                                            calculateTotalPrice(
                                                                choicePrice,
                                                                typePrice);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            '${type['name']} + RM ${type['price'].toStringAsFixed(2)}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5), // This is the border radius
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First row
                                    const Text(
                                      'Press the buttons to add remarks',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    // remarks buttons
                                    Wrap(
                                      spacing:
                                          8.0, // gap between adjacent chips
                                      runSpacing: 4.0, // gap between lines
                                      children: remarksData
                                          .where((data) =>
                                              data['category'] ==
                                              item.category) // Filter remarksData based on item.category
                                          .map((data) => Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 6, 10, 6),
                                                child: remarkButton(data),
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: _controller,
                                      style: const TextStyle(
                                          color: Colors
                                              .black), // Set text color to black
                                      decoration: const InputDecoration(
                                        fillColor: Colors
                                            .white, // Set background color to white
                                        filled: true, // Don't forget this
                                        border: OutlineInputBorder(),
                                        labelText: 'Write comments here',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .grey), // Set border color to grey when focused
                                        ),
                                      ),
                                    ),
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
                          onPressed: () {
                            itemRemarks = {};
                            widget.onItemAdded(item);
                            Navigator.of(context).pop();
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
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else {
          widget.onItemAdded(item);
        }
      },
      // individual item container
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xff1f2029),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: Text(
                'RM ${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
