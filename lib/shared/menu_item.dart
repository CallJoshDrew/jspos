import 'dart:collection';
import 'dart:developer';
// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jspos/data/remarks.dart';
import 'package:jspos/models/item.dart';

class MenuItem extends StatefulWidget {
  final Function(Item) onItemAdded;
  final Item item;
  final String id;
  final String name;
  final String originalName;
  final String image;
  final String category;
  final double price;
  final bool selection;
  final List<Map<String, dynamic>> drinks;
  final List<Map<String, String>> temp;
  final List<Map<String, dynamic>> choices;
  final List<Map<String, dynamic>> noodlesTypes;
  final List<Map<String, dynamic>> soupOrKonLou;
  final List<Map<String, dynamic>> sides;
  final List<Map<String, dynamic>> addMilk;
  final List<Map<String, dynamic>> addOns;
  final List<Map<String, dynamic>> meePortion;
  final List<Map<String, dynamic>> meatPortion;
  final bool tapao;
  final Map<String, dynamic>? selectedDrink;
  final Map<String, String>? selectedTemp;
  final Map<String, dynamic>? selectedChoice;
  final Map<String, dynamic>? selectedNoodlesType;
  final Map<String, dynamic>? selectedSoupOrKonLou;
  final Map<String, dynamic>? selectedSide;
  final Map<String, dynamic>? selectedAddMilk;
  final Map<String, dynamic>? selectedAddOn;
  final Map<String, dynamic>? selectedMeePortion;
  final Map<String, dynamic>? selectedMeatPortion;

  const MenuItem({
    super.key,
    required this.onItemAdded,
    required this.item,
    required this.id,
    required this.name,
    required this.originalName,
    required this.image,
    required this.category,
    required this.price,
    required this.selection,
    required this.drinks,
    required this.temp,
    required this.choices,
    required this.noodlesTypes,
    required this.soupOrKonLou,
    required this.sides,
    required this.addMilk,
    required this.addOns,
    required this.meePortion,
    required this.meatPortion,
    this.tapao = false,
    required this.selectedDrink,
    required this.selectedTemp,
    required this.selectedChoice,
    required this.selectedNoodlesType,
    required this.selectedSoupOrKonLou,
    required this.selectedSide,
    required this.selectedAddMilk,
    required this.selectedAddOn,
    required this.selectedMeePortion,
    required this.selectedMeatPortion,
  });

  @override
  MenuItemState createState() => MenuItemState();
}

class MenuItemState extends State<MenuItem> {
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? selectedDrink;
  Map<String, String>? selectedTemp;
  Map<String, dynamic>? selectedChoice;
  Set<Map<String, dynamic>> selectedNoodlesType = {};
  Map<String, dynamic>? selectedSoupOrKonLou;
  Set<Map<String, dynamic>> selectedSide = {};
  Map<String, dynamic>? selectedAddMilk;
  Map<String, dynamic>? selectedAddOn;
  Map<String, dynamic>? selectedMeePortion;
  Map<String, dynamic>? selectedMeatPortion;

  double drinkPrice = 0.00;
  double choicePrice = 0.00;
  double noodlesTypePrice = 0.00;
  double soupOrKonlouPrice = 0.00;
  double sidesPrice = 0.00;
  double addMilkPrice = 0.00;
  double addOnsPrice = 0.00;
  double meatPrice = 0.00;
  double meePrice = 0.00;
  double subTotalPrice = 0.00;

  @override
  void initState() {
    super.initState();

    // Initialize prices
    drinkPrice = _calculateDrinkPrice();
    choicePrice = _getPrice(widget.choices);
    meatPrice = _getPrice(widget.meatPortion);
    meePrice = _getPrice(widget.meePortion);
    addMilkPrice = _getPrice(widget.addMilk);
    addOnsPrice = _getPrice(widget.addOns);
    soupOrKonlouPrice = _getPrice(widget.soupOrKonLou);

    // Calculate subtotal
    subTotalPrice = drinkPrice + choicePrice + meatPrice + meePrice + noodlesTypePrice + sidesPrice + addMilkPrice + addOnsPrice + soupOrKonlouPrice;
  }

  // @override
  // void didUpdateWidget(covariant ProductItem oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.choices != oldWidget.choices && widget.choices.isNotEmpty) {
  //     setState(() {
  //       selectedChoice = widget.choices[0]; // Select the first choice by default
  //       choicePrice = selectedChoice?['price'] ?? 0.0;
  //       log('didUpdateWidget: selectedChoice updated to: ${selectedChoice?['name']}');
  //     });
  //   }
  // }

  // Helper method to calculate drink price
  double _calculateDrinkPrice() {
    if (selectedDrink == null || selectedTemp == null) return 0.00;
    var drink = widget.drinks.firstWhere(
      (drink) => drink['name'] == selectedDrink?['name'],
      orElse: () => {'Hot': 0.00, 'Cold': 0.00},
    );

    final selectedTempName = selectedTemp?['name'] ?? '';
    return (drink[selectedTempName] as double?) ?? 0.00;
  }

  // Helper method to get price from a list
  double _getPrice(List<Map<String, dynamic>> items) {
    if (items.isEmpty || items[0]['price'] == null) return 0.00;
    return items[0]['price'] as double;
  }

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
      double addMilkPrice, double addOnsPrice, double soupOrKonlouPrice) {
    // Log each value to ensure they're being passed correctly
    // log("Drink Price: $drinkPrice");
    // log("Choice Price: $choicePrice");
    // log("Noodles Type Price: $noodlesTypePrice");
    // log("Meat Price: $meatPrice");
    // log("Mee Price: $meePrice");
    // log("Sides Price: $sidesPrice");
    // log("Add-Ons Price: $addOnsPrice");

    double totalPrice = drinkPrice + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice + addMilkPrice + addOnsPrice + soupOrKonlouPrice;

    // log("Total Price: $totalPrice");

    setState(() {
      subTotalPrice = totalPrice;
    });
  }

  TextSpan generateNoodlesOnTextSpan(Map<String, dynamic> noodle, bool isLast) {
    return TextSpan(
      text: "${noodle['name']}", // Display the name
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

  TextSpan generateSidesOnTextSpan(Map<String, dynamic> side, bool isLast) {
    return TextSpan(
      text: "${side['name']}", // Display the name
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

    // Add the user's comment with a key of '100'
    if (itemRemarks.isNotEmpty) {
      itemRemarks['100'] = _controller.text;
    }
    SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
      (a, b) => int.parse(a).compareTo(int.parse(b)),
    )..addAll(itemRemarks);

    itemRemarks = sortedItemRemarks;
    // print('itemRemarks after sorting: $itemRemarks');
    itemRemarks = itemRemarks;
    itemRemarks = {};
    // print('itemRemarks after clearing: $itemRemarks');
    _controller.text = '';
    // print('_controller.text after clearing: ${_controller.text}');
  }

  Widget remarkButton(Map<String, dynamic> data) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            // Check if the remark has been added to itemRemarks
            if (itemRemarks.containsKey(data['id'].toString())) {
              // If the button is pressed or the remark has been added, make the background orange
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
        padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(10, 6, 10, 6)), // Add padding inside the button
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('Item selection from product Page:');
        log('- ${widget.id}');
        log('-${widget.name}');
        log('- ${widget.originalName}');
        log('- ${widget.image}');
        log('- ${widget.category}');
        log('- ${widget.price}');
        log('- ${widget.selection}');

        log('- ${widget.drinks}'); //
        log('- ${widget.temp}'); //

        log('- ${widget.choices}');
        log('- ${widget.noodlesTypes}');

        log('- ${widget.soupOrKonLou}'); //

        log('- ${widget.sides}'); //
        log('- ${widget.addMilk}'); //
        log('- ${widget.addOns}'); //

        log('- ${widget.meePortion}');
        log('- ${widget.meatPortion}');
        log('- ${widget.tapao}');
        log('- selected Choice is ${selectedChoice?['name']}');
        log('- selected Mee Portion is ${selectedMeePortion?['name']}');
        if (widget.selection) {
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
                                // Item Image, Name, Price DETAILS
                                Container(
                                  // height: 200,
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
                                            widget.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          widget.selection && selectedChoice != null
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      widget.originalName == selectedChoice!['name']
                                                          ? widget.originalName
                                                          : '${widget.originalName} ${selectedChoice!['name']}',
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
                                                        fontWeight: FontWeight.bold,
                                                        // color: Colors.white,
                                                        color: Color.fromARGB(255, 114, 226, 118),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      widget.originalName == selectedDrink?['name']
                                                          ? widget.originalName
                                                          : '${widget.originalName} ${selectedDrink?['name']} - ${selectedTemp?["name"]}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      "( ${selectedDrink?['price'].toStringAsFixed(2)} )",
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
                                                  widget.selection && selectedSoupOrKonLou != null
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
                                                                "( + ${selectedSoupOrKonLou!['price'].toStringAsFixed(2)} ) ",
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color.fromARGB(255, 114, 226, 118),
                                                                ),
                                                              )
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                  widget.selection && selectedNoodlesType.isNotEmpty
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
                                                                  children: selectedNoodlesType.toList().asMap().entries.map((entry) {
                                                                    int idx = entry.key;
                                                                    // side is singular because represent single item
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
                                                  // widget.selection && selectedNoodlesType != null && selectedNoodlesType!['name'] != 'None'
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

                                                  // next time add to display remarks
                                                  // if (itemRemarks.isNotEmpty)
                                                  // Text(
                                                  //   "( + $itemRemarks )",
                                                  //   style: const TextStyle(
                                                  //     fontSize: 14,
                                                  //     color: Colors.white
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  widget.selection && selectedMeePortion != null && selectedMeePortion!['name'] != "Normal Mee"
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
                                                ],
                                              ),
                                              widget.selection && selectedMeatPortion != null && selectedMeatPortion!['name'] != "Normal Meat"
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
                                              widget.selection && selectedAddMilk != null && selectedAddMilk!['name'] != "No Milk"
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "Add ${selectedAddMilk!['name']} ",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        if (selectedAddMilk!['price'] != 0.00)
                                                          Text(
                                                            "( + ${selectedAddMilk!['price'].toStringAsFixed(2)} )",
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Color.fromARGB(255, 114, 226, 118),
                                                            ),
                                                          )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              // Product Details after select side, noodles, choices, etc
                                              widget.selection
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
                                              widget.selection && selectedSide.isNotEmpty
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
                                              // Wrap(
                                              //   children: [
                                              //     widget.selection && filterRemarks(itemRemarks).isNotEmpty == true
                                              //         ? Row(
                                              //             children: [
                                              //               const Text(
                                              //                 'Remarks: ',
                                              //                 style: TextStyle(
                                              //                   fontSize: 14,
                                              //                   color: Colors.white,
                                              //                 ),
                                              //               ),
                                              //               Text(
                                              //                 getFilteredRemarks(itemRemarks),
                                              //                 style: const TextStyle(
                                              //                   fontSize: 14,
                                              //                   color: Colors.orangeAccent,
                                              //                 ),
                                              //               )
                                              //             ],
                                              //           )
                                              //         : const SizedBox.shrink(),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Text('RM ${subTotalPrice.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
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
                                      if (widget.drinks.isNotEmpty) ...[
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
                                                    if (widget.drinks.isNotEmpty) ...[
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
                                                        children: widget.drinks.map((drink) {
                                                          return ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedDrink = drink;
                                                                calculateTotalPrice(drink['price'], choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                    calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor: WidgetStateProperty.all<Color>(
                                                                selectedDrink == drink ? Colors.orange : Colors.white,
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
                                                                color: selectedDrink == drink
                                                                    ? Colors.white
                                                                    : Colors.black, // Change the text color based on the selected button
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            )],
                                      if (widget.temp.isNotEmpty) const SizedBox(width: 10),
                                      widget.selection && selectedTemp != null
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
                                                    if (widget.temp.isNotEmpty) ...[
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
                                                        children: widget.temp.map((item) {
                                                          return ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedTemp = item;
                                                                calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                    calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
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
                                      // if (widget.choices.isNotEmpty) const SizedBox(width: 10),
                                      if (widget.choices.isNotEmpty) ...[
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
                                                  children: widget.choices.map((choice) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        log('Selected choice: ${selectedChoice?['name']}');

                                                        setState(() {
                                                          selectedChoice = choice;
                                                          choicePrice = choice['price'];
                                                          calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                              calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedChoice == choice ? Colors.orange : Colors.white,
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
                                                          color: selectedChoice == choice
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
                                        )
                                      ],
                                      if (widget.noodlesTypes.isNotEmpty) const SizedBox(width: 10),
                                      //selectedNoodlesType
                                      if (widget.noodlesTypes.isNotEmpty) ...[
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
                                                  children: widget.noodlesTypes.map((noodleType) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (selectedNoodlesType.contains(noodleType)) {
                                                            selectedNoodlesType.remove(noodleType);
                                                          } else {
                                                            selectedNoodlesType.add(noodleType);
                                                          }
                                                          sortSelectedNoodlesAlphabetically();
                                                          calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                              calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
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
                                                          color: selectedNoodlesType.any((n) => n['name'] == noodleType['name'])
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
                                      ]
                                    ],
                                  ),
                                ),
                                // Second Row for selection of sides
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Selection for user to select sides
                                      if (widget.sides.isNotEmpty) ...[
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
                                                  children: widget.sides.map((side) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (selectedSide.contains(side)) {
                                                            selectedSide.remove(side);
                                                          } else {
                                                            selectedSide.add(side);
                                                          }
                                                          sortSelectedSidesAlphabetically();
                                                          calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                              calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
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
                                      ],
                                      if (widget.sides.isNotEmpty) const SizedBox(width: 10),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff1f2029),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns content at the top
                                            children: [
                                              Expanded(
                                                // Ensure the column takes available space within the row
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (widget.soupOrKonLou.isNotEmpty) ...[
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
                                                            children: widget.soupOrKonLou.map((soup) {
                                                              return ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    selectedSoupOrKonLou = soup;
                                                                    soupOrKonlouPrice = soup['price'];
                                                                    calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                        calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                                                  });
                                                                },
                                                                style: ButtonStyle(
                                                                  backgroundColor: WidgetStateProperty.all<Color>(
                                                                    selectedSoupOrKonLou == soup ? Colors.orange : Colors.white,
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
                                                                    color: selectedSoupOrKonLou == soup
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
                                                      )
                                                    ],
                                                    const Text(
                                                      'Add Remarks',
                                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                                    ),
                                                    Wrap(
                                                      spacing: 6.0, // Gap between adjacent chips
                                                      runSpacing: 0.0, // Gap between lines
                                                      children: remarksData
                                                          .where((data) => data['category'] == widget.category)
                                                          .map((data) => remarkButton(data))
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Third Row for selection of add On and Add Milk

                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      if (widget.addOns.isNotEmpty) ...[
                                        Expanded(
                                          flex: 8,
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
                                                      children: widget.addOns.map((addOn) {
                                                        return ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedAddOn = addOn;
                                                              addOnsPrice = addOn['price'];
                                                              calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                                  calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor: WidgetStateProperty.all<Color>(
                                                              selectedAddOn == addOn ? Colors.orange : Colors.white,
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
                                                              color: selectedAddOn == addOn
                                                                  ? Colors.white
                                                                  : Colors.black, // Change the text color based on the selected button
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      // add milk
                                      if (widget.addMilk.isNotEmpty) const SizedBox(width: 10),
                                      if (widget.addMilk.isNotEmpty) ...[
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
                                                  'Add-On Milk',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Wrap(
                                                  spacing: 6,
                                                  runSpacing: 0,
                                                  children: widget.addMilk.map((addMilk) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedAddMilk = addMilk;
                                                          addMilkPrice = addMilk['price'];
                                                          calculateTotalPrice(
                                                              drinkPrice,
                                                              choicePrice,
                                                              calculateNoodlesPrice(),
                                                              meatPrice, // Correctly updated meat price
                                                              meePrice, // Ensure meePrice is properly updated before
                                                              calculateSidesPrice(),
                                                              addMilkPrice,
                                                              addOnsPrice,
                                                              soupOrKonlouPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedAddMilk == addMilk ? Colors.orange : Colors.white,
                                                        ),
                                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                      ),
                                                      child: Text(
                                                        '${addMilk['name']}',
                                                        style: TextStyle(
                                                          color: selectedAddMilk == addMilk
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
                                      ],
                                    ],
                                  ),
                                ),
                                // Forth Row for selection of meePortion, meePortion, write remarks
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.meePortion.isNotEmpty) ...[
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
                                                  'Select Mee Portion',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Wrap(
                                                  spacing: 6,
                                                  runSpacing: 0,
                                                  children: widget.meePortion.map((meePortion) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedMeePortion = meePortion;
                                                          meePrice = meePortion['price'];
                                                          calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice,
                                                              calculateSidesPrice(), addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedMeePortion == meePortion ? Colors.orange : Colors.white,
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
                                                          color: selectedMeePortion == meePortion
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
                                      ],
                                      if (widget.meePortion.isNotEmpty) const SizedBox(width: 10),
                                      if (widget.meatPortion.isNotEmpty) ...[
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
                                                  children: widget.meatPortion.map((meatPortion) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedMeatPortion = meatPortion;
                                                          meatPrice = meatPortion['price'];
                                                          calculateTotalPrice(
                                                              drinkPrice,
                                                              choicePrice,
                                                              calculateNoodlesPrice(),
                                                              meatPrice, // Correctly updated meat price
                                                              meePrice, // Ensure meePrice is properly updated before
                                                              calculateSidesPrice(),
                                                              addMilkPrice,
                                                              addOnsPrice,
                                                              soupOrKonlouPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedMeatPortion == meatPortion ? Colors.orange : Colors.white,
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
                                                          color: selectedMeatPortion == meatPortion
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
                                      if (widget.meatPortion.isNotEmpty) const SizedBox(width: 10),
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
                                                      itemRemarks = itemRemarks;
                                                      // print(itemRemarks);
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
                                          padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        onPressed: () {
                                          selectedChoice = selectedChoice;
                                          selectedNoodlesType = selectedNoodlesType;
                                          selectedMeatPortion = selectedMeatPortion;
                                          selectedMeePortion = selectedMeePortion;
                                          selectedSide = selectedSide;
                                          selectedAddMilk = selectedAddMilk;
                                          selectedAddOn = selectedAddOn;
                                          selectedDrink = selectedDrink;
                                          selectedTemp = selectedTemp;
                                          selectedSoupOrKonLou = selectedSoupOrKonLou;
                                          itemRemarks = itemRemarks;

                                          updateItemRemarks();

                                          calculateTotalPrice(drinkPrice, choicePrice, calculateNoodlesPrice(), meatPrice, meePrice, calculateSidesPrice(),
                                              addMilkPrice, addOnsPrice, soupOrKonlouPrice);
                                          // log('item Price: ${price}');
                                          // log('subTotal Price: $subTotalPrice');

                                          // Reason we didn't save the latest order to the selectedOrder provider or Hive because this order has not being place yet. We only do that after it is confirmed with orderNumber.
                                          // selectedOrderNotifier.updateTotalCost();
                                          // selectedOrderNotifier.updateItem(item);

                                          widget.onItemAdded(widget.item);
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
                                          itemRemarks = {};
                                          _controller.text = '';
                                          selectedSide = {};
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
            },
          );
        } else {
          // Call widget.onItemAdded if selection is false
          widget.onItemAdded(widget.item);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff1f2029),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // item name price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'RM ${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//         if (item.selection) {

//         } else {
//           widget.onItemAdded(item);
//         }
//       },

//     );
//   }
// }

// print('Price of Selected Choice: $choicePrice');
// print('Price of Selected Type: $noodlesTypePrice');
// print('Price of Selected Meat: $meatPrice');
// print('Price of Selected Mee: $meePrice');
// print('Total Price: $subTotalPrice');
// print('-------------------------');
