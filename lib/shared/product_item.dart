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
  final Map<String, dynamic>? selectedMeatPortion;
  final Map<String, dynamic>? selectedMeePortion;

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
    this.selectedMeatPortion,
    this.selectedMeePortion,
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
          selectedMeatPortion: widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null,
          selectedMeePortion: widget.meePortion.isNotEmpty ? widget.meePortion[0] : null,
        ); //this is creating a new instance of item with the required field.
        Map<String, dynamic>? selectedChoice = widget.choices.isNotEmpty ? widget.choices[0] : null;
        Map<String, dynamic>? selectedType = widget.types.isNotEmpty ? widget.types[0] : null;
        Map<String, dynamic>? selectedMeatPortion = widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null;
        Map<String, dynamic>? selectedMeePortion = widget.meePortion.isNotEmpty ? widget.meePortion[0] : null;

        double choicePrice = widget.choices.isNotEmpty && widget.choices[0]['price'] != null ? widget.choices[0]['price']! : 0.00;
        double typePrice = widget.types.isNotEmpty && widget.types[0]['price'] != null ? widget.types[0]['price']! : 0.00;
        double meatPrice = widget.meatPortion.isNotEmpty && widget.meatPortion[0]['price'] != null ? widget.meatPortion[0]['price']! : 0.00;
        double meePrice = widget.meePortion.isNotEmpty && widget.meePortion[0]['price'] != null ? widget.meePortion[0]['price']! : 0.00;

        double totalPrice = choicePrice + typePrice + meatPrice + meePrice;
        print(item.originalName);
        void calculateTotalPrice(double choicePrice, double typePrice, double meatPrice, double meePrice) {
          setState(() {
            totalPrice = choicePrice + typePrice + meatPrice + meePrice;
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
              padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)), // Add padding inside the button
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
                        item.originalName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.black,
                      // second color const Color(0xff1f2029),
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
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Text('RM ${totalPrice.toStringAsFixed(2)}',
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
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text('Select Flavor'),
                                                      children: widget.choices.map<SimpleDialogOption>((choice) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedChoice = choice;
                                                              item.selectedChoice = choice;
                                                              choicePrice = choice['price'];
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
                                      child: widget.types.isNotEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text('Select Variation'),
                                                      children: widget.types.map<SimpleDialogOption>((type) {
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
                                      child: widget.meatPortion.isNotEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text('Select Meat Portion'),
                                                      children: widget.meatPortion.map<SimpleDialogOption>((meatPortion) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedMeatPortion = meatPortion;
                                                              item.selectedMeatPortion = meatPortion;
                                                              if (item.selectedMeatPortion!['name'] != "Normal Meat") {
                                                                itemRemarks['98'] = meatPortion['name'];
                                                              }
                                                              meatPrice = meatPortion['price'];
                                                            });
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text(
                                                            '${meatPortion['name']} (RM ${meatPortion['price'].toStringAsFixed(2)})',
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
                                                  '${selectedMeatPortion!['name']} (RM ${selectedMeatPortion!['price'].toStringAsFixed(2)})',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                      child: widget.meePortion.isNotEmpty
                                          ? ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: const Text('Select Mee Portion'),
                                                      children: widget.meePortion.map<SimpleDialogOption>((meePortion) {
                                                        return SimpleDialogOption(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedMeePortion = meePortion;
                                                              item.selectedMeePortion = meePortion;
                                                              if (item.selectedMeePortion!['name'] != "Normal Mee") {
                                                                itemRemarks['99'] = meePortion['name'];
                                                              }
                                                              meePrice = meePortion['price'];
                                                            });
                                                            calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text(
                                                            '${meePortion['name']} (RM ${meePortion['price'].toStringAsFixed(2)})',
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
                                                  '${selectedMeePortion!['name']} (RM ${selectedMeePortion!['price'].toStringAsFixed(2)})',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                          // Add the user's comment with a key of '100'
                                          itemRemarks['100'] = text;
                                          SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
                                            (a, b) => int.parse(a).compareTo(int.parse(b)),
                                          )..addAll(itemRemarks);
                                          itemRemarks = sortedItemRemarks;
                                          item.itemRemarks = itemRemarks;
                                          print(item.itemRemarks);
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
                          onPressed: () {
                            // Add the user's comment with a key of '100'
                            if (item.itemRemarks != null) {
                              itemRemarks['100'] = _controller.text;
                            }
                            SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
                              (a, b) => int.parse(a).compareTo(int.parse(b)),
                            )..addAll(itemRemarks);
                            itemRemarks = sortedItemRemarks;
                            print('itemRemarks after sorting: $itemRemarks'); // Debug print
                            item.itemRemarks = itemRemarks;
                            itemRemarks = {};
                            print('itemRemarks after clearing: $itemRemarks'); // Debug print
                            _controller.text = '';
                            print('_controller.text after clearing: ${_controller.text}'); // Debug print
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
