import 'dart:collection';
import 'dart:developer';
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
  final List<Map<String, dynamic>> types;
  final List<Map<String, dynamic>> meatPortion;
  final List<Map<String, dynamic>> meePortion;
  final List<Map<String, dynamic>> addOn;
  final Map<String, dynamic>? selectedDrink;
  final List<Map<String, String>> temp;
  final Map<String, String>? selectedTemp;
  final Map<String, dynamic>? selectedChoice;
  final Map<String, dynamic>? selectedType;
  final Map<String, dynamic>? selectedMeatPortion;
  final Map<String, dynamic>? selectedMeePortion;
  final Map<String, dynamic>? selectedAddOn;

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
    required this.types,
    required this.meatPortion,
    required this.meePortion,
    required this.addOn,
    this.selectedDrink,
    required this.temp,
    this.selectedTemp,
    this.selectedChoice,
    this.selectedType,
    this.selectedMeatPortion,
    this.selectedMeePortion,
    this.selectedAddOn,
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
          types: widget.types,
          meatPortion: widget.meatPortion,
          meePortion: widget.meePortion,
          addOn: widget.addOn,
          selectedDrink: widget.drinks.isNotEmpty ? widget.drinks[0] : null,
          temp: widget.temp,
          selectedTemp: widget.temp.isNotEmpty ? widget.temp[0] : null,
          selectedChoice: widget.choices.isNotEmpty ? widget.choices[0] : null,
          selectedType: widget.types.isNotEmpty ? widget.types[0] : null,
          selectedMeatPortion: widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null,
          selectedMeePortion: widget.meePortion.isNotEmpty ? widget.meePortion[0] : null,
          selectedAddOn: {},
        ); //this is creating a new instance of item with the required field.
        Map<String, dynamic>? selectedDrink = widget.drinks.isNotEmpty ? widget.drinks[0] : null;
        Map<String, String>? selectedTemp = widget.temp.isNotEmpty ? widget.temp[0] : null;
        Map<String, dynamic>? selectedChoice = widget.choices.isNotEmpty ? widget.choices[0] : null;
        Map<String, dynamic>? selectedType = widget.types.isNotEmpty ? widget.types[0] : null;
        Map<String, dynamic>? selectedMeatPortion = widget.meatPortion.isNotEmpty ? widget.meatPortion[0] : null;
        Map<String, dynamic>? selectedMeePortion = widget.meePortion.isNotEmpty ? widget.meePortion[0] : null;
        Set<Map<String, dynamic>> selectedAddOn = {};
        double drinkPrice() {
          var drink = widget.drinks.firstWhere(
            (drink) => drink['name'] == selectedDrink?['name'],
            orElse: () => {'Hot': 0.00, 'Cold': 0.00} as Map<String, Object>, // Set default values
          );

          final selectedTempName = selectedTemp?['name'] ?? ''; // Convert to non-nullable String

          return (drink[selectedTempName] as double?) ?? 0.00; // Get the price based on the selected temperature
        }

        double choicePrice = widget.choices.isNotEmpty && widget.choices[0]['price'] != null ? widget.choices[0]['price']! : 0.00;
        double typePrice = widget.types.isNotEmpty && widget.types[0]['price'] != null ? widget.types[0]['price']! : 0.00;
        double meatPrice = widget.meatPortion.isNotEmpty && widget.meatPortion[0]['price'] != null ? widget.meatPortion[0]['price']! : 0.00;
        double meePrice = widget.meePortion.isNotEmpty && widget.meePortion[0]['price'] != null ? widget.meePortion[0]['price']! : 0.00;
        double addOnPrice = widget.addOn.isNotEmpty && widget.addOn[0]['price'] != null ? widget.addOn[0]['price']! : 0.00;
        double subTotalPrice = drinkPrice() + choicePrice + typePrice + meatPrice + meePrice + addOnPrice;

        double calculateAddOnPrice() {
          double addOnPrice = 0.0;
          for (var addOn in selectedAddOn) {
            addOnPrice += addOn['price'];
          }
          return addOnPrice;
        }

        void calculateTotalPrice(double drinkPrice, double choicePrice, double typePrice, double meatPrice, double meePrice, double addOnPrice) {
          setState(() {
            subTotalPrice = drinkPrice + choicePrice + typePrice + meatPrice + meePrice + addOnPrice;
          });
        }

        TextSpan generateAddOnTextSpan(Map<String, dynamic> addOn, bool isLast) {
          return TextSpan(
            text: "${addOn['name']} ",
            children: <TextSpan>[
              TextSpan(
                text: "( + ${addOn['price'].toStringAsFixed(2)} )${isLast ? '' : ' + '}", // No comma if it's the last add-on
                style: const TextStyle(
                  color: Color.fromARGB(255, 114, 226, 118), // Change this to your desired color
                ),
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
                                // Item Image, Name, Price
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
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        // color: Color.fromARGB(255, 114, 226, 118),
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
                                              item.selection && selectedType != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "${selectedType!['name']} ",
                                                          style: const TextStyle(fontSize: 14, color: Colors.white),
                                                        ),
                                                        Text(
                                                          "( + ${selectedType!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Color.fromARGB(255, 114, 226, 118),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              item.selection && selectedMeePortion != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "${selectedMeePortion!['name']} ",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
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
                                              item.selection && selectedMeatPortion != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "${selectedMeatPortion!['name']} ",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
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
                                              item.selection && selectedAddOn.isNotEmpty
                                                  ? Wrap(
                                                      children: [
                                                        const Text(
                                                          "Add On: ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 500, // Adjust the width as needed
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                              ),
                                                              children: selectedAddOn.toList().asMap().entries.map((entry) {
                                                                int idx = entry.key;
                                                                Map<String, dynamic> addOn = entry.value;
                                                                bool isLast = idx == selectedAddOn.length - 1;
                                                                return generateAddOnTextSpan(addOn, isLast);
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),
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
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // First Row for selection of Choices & Types
                                Row(
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
                                                              calculateTotalPrice(
                                                                  drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                                              calculateTotalPrice(
                                                                  drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                                      'Select Base',
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
                                                              calculateTotalPrice(
                                                                  drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                    if (widget.types.isNotEmpty) const SizedBox(width: 10),
                                    //selectedType
                                    if (widget.types.isNotEmpty) ...[
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
                                                children: widget.types.map((type) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedType = type;
                                                        typePrice = type['price'];
                                                        calculateTotalPrice(drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStateProperty.all<Color>(
                                                        selectedType == type ? Colors.orange : Colors.white,
                                                      ),
                                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                      ),
                                                      padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                    ),
                                                    child: Text(
                                                      '${type['name']}',
                                                      style: TextStyle(
                                                        color: selectedType == type
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
                                // Second Row for selection of Mee & Meat Portions
                                Row(
                                  children: [
                                    if (widget.meatPortion.isNotEmpty) ...[
                                      Expanded(
                                        flex: 3,
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
                                                        calculateTotalPrice(drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                    if (widget.addOn.isNotEmpty) ...[
                                      Expanded(
                                        flex: 9,
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
                                                'Add-Ons',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Wrap(
                                                spacing: 6,
                                                runSpacing: 0,
                                                children: widget.addOn.map((addOn) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedAddOn.contains(addOn)) {
                                                          selectedAddOn.remove(addOn);
                                                        } else {
                                                          selectedAddOn.add(addOn);
                                                        }
                                                        calculateTotalPrice(drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStateProperty.all<Color>(
                                                        selectedAddOn.contains(addOn) ? Colors.orange : Colors.white,
                                                      ),
                                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                      ),
                                                      padding: WidgetStateProperty.all(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                                    ),
                                                    child: Text(
                                                      '${addOn['name']}',
                                                      style: TextStyle(
                                                        color: selectedAddOn.contains(addOn) ? Colors.white : Colors.black,
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
                                Row(
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
                                            borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                          ),
                                          child: Row(
                                            children: [
                                              Column(
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
                                                    spacing: 6, // space between buttons horizontally
                                                    runSpacing: 0, // space between buttons vertically
                                                    children: widget.meePortion.map((meePortion) {
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMeePortion = meePortion;
                                                            meePrice = meePortion['price'];
                                                            calculateTotalPrice(
                                                                drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      const SizedBox.shrink(),
                                    ],
                                    if (item.meePortion.isNotEmpty) const SizedBox(width: 10),
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
                                                // First row
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
                                          item.selectedType = selectedType;
                                          item.selectedMeatPortion = selectedMeatPortion;
                                          item.selectedMeePortion = selectedMeePortion;
                                          item.selectedAddOn = selectedAddOn;
                                          item.selectedDrink = selectedDrink;
                                          item.selectedTemp = selectedTemp;

                                          updateItemRemarks();

                                          calculateTotalPrice(drinkPrice(), choicePrice, typePrice, meatPrice, meePrice, calculateAddOnPrice());
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
                                          selectedAddOn = {};
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
// print('Price of Selected Type: $typePrice');
// print('Price of Selected Meat: $meatPrice');
// print('Price of Selected Mee: $meePrice');
// print('Total Price: $subTotalPrice');
// print('-------------------------');