import 'dart:collection';
// import 'dart:developer';
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
  final List<Map<String, dynamic>> drinks;
  final List<Map<String, dynamic>> choices;
  final List<Map<String, dynamic>> noodlesTypes;
  final List<Map<String, dynamic>> meatPortion;
  final List<Map<String, dynamic>> meePortion;
  final List<Map<String, dynamic>> sides;
  final List<Map<String, dynamic>> addOns;
  final Map<String, dynamic>? selectedDrink;
  final List<Map<String, String>> temp;
  final Map<String, String>? selectedTemp;
  final Map<String, dynamic>? selectedChoice;
  final Map<String, dynamic>? selectedNoodlesType;
  final Map<String, dynamic>? selectedMeatPortion;
  final Map<String, dynamic>? selectedMeePortion;
  final Map<String, dynamic>? selectedSide;
  final Map<String, dynamic>? selectedAddOn;
  final bool tapao;

  const ProductItem({
    super.key,
    required this.onItemAdded,
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    this.selection = false,
    required this.drinks,
    required this.choices,
    required this.noodlesTypes,
    required this.meatPortion,
    required this.meePortion,
    required this.sides,
    required this.addOns,
    this.selectedDrink,
    required this.temp,
    this.selectedTemp,
    this.selectedChoice,
    this.selectedNoodlesType,
    this.selectedMeatPortion,
    this.selectedMeePortion,
    this.selectedSide,
    this.selectedAddOn,
    this.tapao = false,
  });

  @override
  ProductItemState createState() => ProductItemState();
}

class ProductItemState extends State<ProductItem> {
  Map<String, dynamic> itemRemarks = {};
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the status bar height
    return GestureDetector(
      onTap: () {
        Item item = Item(
          id: widget.id,
          name: widget.name,
          originalName: widget.name,
          price: widget.price,
          category: widget.category,
          image: widget.image,
          quantity: 1,
          selection: widget.selection,
          drinks: widget.drinks,
          choices: widget.choices,
          noodlesTypes: widget.noodlesTypes,
          meatPortion: widget.meatPortion,
          meePortion: widget.meePortion,
          sides: widget.sides,
          addOns: widget.addOns,
          selectedDrink: widget.drinks.isNotEmpty ? widget.drinks[0] : null,
          temp: widget.temp,
          selectedTemp: widget.temp.isNotEmpty ? widget.temp[0] : null,
          selectedChoice: widget.choices.isNotEmpty ? widget.choices[0] : null,
          selectedNoodlesType: widget.noodlesTypes.isNotEmpty ? widget.noodlesTypes[0] : null,
          selectedMeatPortion: widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null,
          selectedMeePortion: widget.meePortion.isNotEmpty ? widget.meePortion[0] : null,
          selectedSide: {},
          selectedAddOn: widget.addOns.isNotEmpty ? widget.addOns[0] : null,
          tapao: widget.tapao,
        ); //this is creating a new instance of item with the required field.
        Map<String, dynamic>? selectedDrink = widget.drinks.isNotEmpty ? widget.drinks[0] : null;
        Map<String, String>? selectedTemp = widget.temp.isNotEmpty ? widget.temp[0] : null;
        Map<String, dynamic>? selectedChoice = widget.choices.isNotEmpty ? widget.choices[0] : null;
        Map<String, dynamic>? selectedNoodlesType = widget.noodlesTypes.isNotEmpty ? widget.noodlesTypes[0] : null;
        Map<String, dynamic>? selectedMeatPortion = widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null;
        Map<String, dynamic>? selectedMeePortion = widget.meePortion.isNotEmpty ? widget.meePortion[0] : null;
        Set<Map<String, dynamic>> selectedSide = {};
        Map<String, dynamic>? selectedAddOn = widget.addOns.isNotEmpty ? widget.addOns[0] : null;
        double drinkPrice() {
          var drink = widget.drinks.firstWhere(
            (drink) => drink['name'] == selectedDrink?['name'],
            orElse: () => {'Hot': 0.00, 'Cold': 0.00} as Map<String, Object>, // Set default values
          );

          final selectedTempName = selectedTemp?['name'] ?? ''; // Convert to non-nullable String

          return (drink[selectedTempName] as double?) ?? 0.00; // Get the price based on the selected temperature
        }

        double choicePrice = widget.choices.isNotEmpty && widget.choices[0]['price'] != null ? widget.choices[0]['price']! : 0.00;
        double noodlesTypePrice = widget.noodlesTypes.isNotEmpty && widget.noodlesTypes[0]['price'] != null ? widget.noodlesTypes[0]['price']! : 0.00;
        double meatPrice = widget.meatPortion.isNotEmpty && widget.meatPortion[0]['price'] != null ? widget.meatPortion[0]['price']! : 0.00;
        double meePrice = widget.meePortion.isNotEmpty && widget.meePortion[0]['price'] != null ? widget.meePortion[0]['price']! : 0.00;
        double sidesPrice = 0.00;
        double addOnsPrice = widget.addOns.isNotEmpty && widget.addOns[0]['price'] != null ? widget.addOns[0]['price']! : 0.00;
        double subTotalPrice = drinkPrice() + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice + addOnsPrice;

        double calculateSidesPrice() {
          double sidesPrice = 0.0;
          for (var side in selectedSide) {
            sidesPrice += side['price'];
          }
          return sidesPrice;
        }

        int getTotalSelectedSides() {
          int sidesCount = selectedSide.length; // Get the number of selected sides

          // Add the selectedAddOn 'name' value if available
          if (selectedAddOn != null && selectedAddOn!['name'] != null) {
            num addOnValue = num.parse(selectedAddOn!['name']); // Parse 'name' as num (handles int and double)

            sidesCount == addOnValue.toInt(); // Convert to int if necessary
          }

          return sidesCount;
        }

        int getTotalSides() {
          int totalSidesCount = selectedSide.length; // Get the number of selected sides

          // Add the selectedAddOn 'name' value if available
          if (selectedAddOn != null && selectedAddOn!['name'] != null) {
            num addOnValue = num.parse(selectedAddOn!['name']); // Parse 'name' as num (handles int and double)

            totalSidesCount += addOnValue.toInt(); // Convert to int if necessary
          }

          return totalSidesCount;
        }

        void calculateTotalPrice(
            double drinkPrice, double choicePrice, double noodlesTypePrice, double meatPrice, double meePrice, double sidesPrice, double addOnsPrice) {
          // Log each value to ensure they're being passed correctly
          // log("Drink Price: $drinkPrice");
          // log("Choice Price: $choicePrice");
          // log("Noodles Type Price: $noodlesTypePrice");
          // log("Meat Price: $meatPrice");
          // log("Mee Price: $meePrice");
          // log("Sides Price: $sidesPrice");
          // log("Add-Ons Price: $addOnsPrice");

          double totalPrice = drinkPrice + choicePrice + noodlesTypePrice + meatPrice + meePrice + sidesPrice + addOnsPrice;

          // log("Total Price: $totalPrice");

          setState(() {
            subTotalPrice = totalPrice;
          });
        }

        TextSpan generateSidesOnTextSpan(Map<String, dynamic> side, bool isLast) {
          return TextSpan(
            text: "${side['name']}", // Display the name
            children: <TextSpan>[
              if (side['price'] != null && side['price'] != 0.00)
                TextSpan(
                  text: " (${side['price'].toStringAsFixed(2)})", // Display price if available
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
          if (item.itemRemarks != null) {
            itemRemarks['100'] = _controller.text;
          }
          SplayTreeMap<String, dynamic> sortedItemRemarks = SplayTreeMap<String, dynamic>(
            (a, b) => int.parse(a).compareTo(int.parse(b)),
          )..addAll(itemRemarks);

          itemRemarks = sortedItemRemarks;
          // print('itemRemarks after sorting: $itemRemarks');
          item.itemRemarks = itemRemarks;
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

        // item selection
        if (item.selection) {
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
                                            item.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                              item.selection && selectedNoodlesType != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "${selectedNoodlesType!['name']} ",
                                                          style: const TextStyle(fontSize: 14, color: Colors.white),
                                                        ),
                                                        // Display price only if it is greater than 0.00
                                                        if (item.selectedNoodlesType!['price'] != 0.00)
                                                          Text(
                                                            "( + ${selectedNoodlesType!['price'].toStringAsFixed(2)} )",
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Color.fromARGB(255, 114, 226, 118),
                                                            ),
                                                          ),
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
                                                    )
                                                  : const SizedBox.shrink(),
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
                                                              children: selectedSide.toList().asMap().entries.map((entry) {
                                                                int idx = entry.key;
                                                                // side is singular because represent single item
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
                                              item.selection && selectedAddOn != null
                                                  ? Text(
                                                      "Selected: ${getTotalSelectedSides()}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                              item.selection && selectedAddOn != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "Extra: ${selectedAddOn!['name']} ",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        if (selectedAddOn!['price'] != null && selectedAddOn!['price'] > 0.00)
                                                          Text(
                                                            "( + ${selectedAddOn!['price'].toStringAsFixed(2)} )",
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Color.fromARGB(255, 114, 226, 118),
                                                            ),
                                                          )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              item.selection && selectedAddOn != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "Total Sides: ${getTotalSides()} ",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   "( + ${selectedAddOn!['price'].toStringAsFixed(2)} )",
                                                        //   style: const TextStyle(
                                                        //     fontSize: 14,
                                                        //     color: Color.fromARGB(255, 114, 226, 118),
                                                        //   ),
                                                        // )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
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
                                      item.selection && selectedDrink != null
                                          ?
                                          // selectedDrink
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
                                                                calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                                    calculateSidesPrice(), addOnsPrice);
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
                                                    ] else ...[
                                                      const SizedBox.shrink(),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      if (widget.temp.isNotEmpty) const SizedBox(width: 10),
                                      item.selection && selectedTemp != null
                                          ?
                                          // selectedTemp
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
                                                                calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                                    calculateSidesPrice(), addOnsPrice);
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
                                                    if (widget.choices.isNotEmpty) ...[
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
                                                              setState(() {
                                                                selectedChoice = choice;
                                                                choicePrice = choice['price'];
                                                                calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                                    calculateSidesPrice(), addOnsPrice);
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
                                                    ] else ...[
                                                      const SizedBox.shrink(),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
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
                                                  children: widget.noodlesTypes.map((noodlestype) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedNoodlesType = noodlestype;
                                                          noodlesTypePrice = noodlestype['price'];
                                                          calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                              calculateSidesPrice(), addOnsPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedNoodlesType == noodlestype ? Colors.orange : Colors.white,
                                                        ),
                                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                        padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                      ),
                                                      child: Text(
                                                        '${noodlestype['name']}',
                                                        style: TextStyle(
                                                          color: selectedNoodlesType == noodlestype
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
                                                          calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                              calculateSidesPrice(), addOnsPrice);
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all<Color>(
                                                          selectedSide.contains(side) ? Colors.orange : Colors.white,
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
                                                          color: selectedSide.contains(side) ? Colors.white : Colors.black,
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
                                // Third Row for selection of add On
                                if (widget.addOns.isNotEmpty) ...[
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 9,
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
                                                          calculateTotalPrice(drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice,
                                                              calculateSidesPrice(), addOnsPrice);
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
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1f2029),
                                              borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                            ),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox.shrink(),
                                ],
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
                                                  'Select Meat Portion',
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
                                                          meatPrice = meePortion['price'];
                                                          calculateTotalPrice(
                                                              drinkPrice(),
                                                              choicePrice,
                                                              noodlesTypePrice,
                                                              meatPrice, // Correctly updated meat price
                                                              meePrice, // Ensure meePrice is properly updated before
                                                              calculateSidesPrice(),
                                                              addOnsPrice);
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
                                      ] else ...[
                                        const SizedBox.shrink(),
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
                                                              drinkPrice(),
                                                              choicePrice,
                                                              noodlesTypePrice,
                                                              meatPrice, // Correctly updated meat price
                                                              meePrice, // Ensure meePrice is properly updated before
                                                              calculateSidesPrice(),
                                                              addOnsPrice);
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
                                          item.selectedChoice = selectedChoice;
                                          item.selectedNoodlesType = selectedNoodlesType;
                                          item.selectedMeatPortion = selectedMeatPortion;
                                          item.selectedMeePortion = selectedMeePortion;
                                          item.selectedSide = selectedSide;
                                          item.selectedAddOn = selectedAddOn;
                                          item.selectedDrink = selectedDrink;
                                          item.selectedTemp = selectedTemp;

                                          updateItemRemarks();

                                          calculateTotalPrice(
                                              drinkPrice(), choicePrice, noodlesTypePrice, meatPrice, meePrice, calculateSidesPrice(), addOnsPrice);
                                          item.price = subTotalPrice;
                                          // log('item Price: ${item.price}');
                                          // log('subTotal Price: $subTotalPrice');
                                          widget.onItemAdded(item);
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
          widget.onItemAdded(item);
        }
      },
      // individual item container
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff1f2029),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1), // Change this color to customize your shadow
          //     spreadRadius: 2,
          //     blurRadius: 2,
          //     offset: const Offset(1, 1), // Changes position of shadow
          //   ),
          // ],
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

// print('Price of Selected Choice: $choicePrice');
// print('Price of Selected Type: $noodlesTypePrice');
// print('Price of Selected Meat: $meatPrice');
// print('Price of Selected Mee: $meePrice');
// print('Total Price: $subTotalPrice');
// print('-------------------------');
