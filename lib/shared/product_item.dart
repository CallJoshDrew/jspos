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
    // Get the status bar height
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
        double subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;

        void calculateTotalPrice(double choicePrice, double typePrice, double meatPrice, double meePrice) {
          setState(() {
            subTotalPrice = choicePrice + typePrice + meatPrice + meePrice;
          });
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
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  // Check if the remark has been added to itemRemarks
                  if (itemRemarks.containsKey(data['id'].toString())) {
                    // If the button is pressed or the remark has been added, make the background green
                    return states.contains(MaterialState.pressed) ? Colors.white : Colors.orange;
                  } else {
                    // If the button is pressed or the remark has not been added, make the background black
                    return states.contains(MaterialState.pressed) ? Colors.orange : Colors.black;
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
                // print('itemRemarks selection:$itemRemarks');
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
                                //Item Heading Title
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color(0xff1f2029)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${item.category}:  ${item.originalName}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Item Image, Name, Price
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xff1f2029),
                                  ),
                                  child: Row(
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
                                          item.selection && selectedChoice != null
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      selectedChoice != null ? '${selectedChoice!['name']}' : 'Select Flavor and Type',
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "( + ${selectedChoice!['price'].toStringAsFixed(2)} )",
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        // color: Color.fromARGB(255, 114, 226, 118),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              item.selection && selectedType != null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "${selectedType!['name']} ",
                                                          style: const TextStyle(fontSize: 22, color: Colors.white),
                                                        ),
                                                        Text(
                                                          "( + ${selectedType!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 22,
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
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          "( + ${selectedMeePortion!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 22,
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
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          "( + ${selectedMeatPortion!['price'].toStringAsFixed(2)} )",
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            color: Color.fromARGB(255, 114, 226, 118),
                                                          ),
                                                        )
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
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // First Row for selection of Choices & Types
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1.selectedChoice
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1f2029),
                                          borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (widget.choices.isNotEmpty) ...[
                                              const Text(
                                                '1.Select Your Flavor',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 14, // space between buttons horizontally
                                                runSpacing: 14, // space between buttons vertically
                                                children: widget.choices.map((choice) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedChoice = choice;
                                                        choicePrice = choice['price'];
                                                        calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: selectedChoice == choice
                                                          ? Colors.orange
                                                          : Colors.white, // Change the color based on the selected button
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      // side: const BorderSide(color: Colors.white),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${choice['name']}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: selectedChoice == choice
                                                              ? Colors.white
                                                              : Colors.black, // Change the text color based on the selected button
                                                          fontSize: 22,
                                                        ),
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
                                    ),
                                    if (widget.types.isNotEmpty) const SizedBox(width: 20),
                                    // 2.selectedType
                                    if (widget.types.isNotEmpty) ...[
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff1f2029),
                                            borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "2.Select Your Preference",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 14, // space between buttons horizontally
                                                runSpacing: 14, // space between buttons vertically
                                                children: widget.types.map((type) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedType = type;
                                                        typePrice = type['price'];
                                                        calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          selectedType == type ? Colors.orange : Colors.white, // Change the color based on the selected button
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      // side: const BorderSide(color: Colors.white),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${type['name']}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: selectedType == type
                                                              ? Colors.white
                                                              : Colors.black, // Change the text color based on the selected button
                                                          fontSize: 22,
                                                        ),
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
                                    if (widget.meePortion.isNotEmpty) ...[
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                          margin: const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff1f2029),
                                            borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '3.Select Your Desired Serving Size',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 14, // space between buttons horizontally
                                                runSpacing: 14, // space between buttons vertically
                                                children: widget.meePortion.map((meePortion) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedMeePortion = meePortion;
                                                        meePrice = meePortion['price'];
                                                        calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: selectedMeePortion == meePortion
                                                          ? Colors.orange
                                                          : Colors.white, // Change the color based on the selected button
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      // side: const BorderSide(color: Colors.white),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${meePortion['name']}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: selectedMeePortion == meePortion
                                                              ? Colors.white
                                                              : Colors.black, // Change the text color based on the selected button
                                                          fontSize: 22,
                                                        ),
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
                                    if (widget.meatPortion.isNotEmpty) const SizedBox(width: 20),
                                    if (widget.meatPortion.isNotEmpty) ...[
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                          margin: const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff1f2029),
                                            borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '4.Select Your Meat Portion Level',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 14, // space between buttons horizontally
                                                runSpacing: 14, // space between buttons vertically
                                                children: widget.meatPortion.map((meatPortion) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedMeatPortion = meatPortion;
                                                        meatPrice = meatPortion['price'];
                                                        calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: selectedMeatPortion == meatPortion
                                                          ? Colors.orange
                                                          : Colors.white, // Change the color based on the selected button
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      // side: const BorderSide(color: Colors.white),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Text(
                                                        '${meatPortion['name']}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: selectedMeatPortion == meatPortion
                                                              ? Colors.white
                                                              : Colors.black, // Change the text color based on the selected button
                                                          fontSize: 22,
                                                        ),
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
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(20, 30, 10, 20),
                                        margin: const EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1f2029),
                                          borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // First row
                                            const Text(
                                              'Press Buttons to add Remarks',
                                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            // remarks buttons
                                            Wrap(
                                              spacing: 6.0, // gap between adjacent chips
                                              runSpacing: 3.0, // gap between lines
                                              children: remarksData
                                                  .where((data) => data['category'] == item.category) // Filter remarksData based on item.category
                                                  .map((data) => Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 6, 10, 6),
                                                        child: remarkButton(data),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
                                        margin: const EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff1f2029),
                                          borderRadius: BorderRadius.circular(5), // Set the border radius here.
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Please write additional remarks here',
                                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: _controller,
                                              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
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
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                                          child: Text(
                                            'Confirm',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          item.selectedChoice = selectedChoice;
                                          item.selectedType = selectedType;
                                          item.selectedMeatPortion = selectedMeatPortion;
                                          item.selectedMeePortion = selectedMeePortion;

                                          updateItemRemarks();

                                          calculateTotalPrice(choicePrice, typePrice, meatPrice, meePrice);
                                          item.price = subTotalPrice;
                                          // widget.selectedOrder.updateTotalCost(0);
                                          // widget.updateOrderStatus!();
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
                                            // side: const BorderSide(color: Colors.green, width: 1),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 24,
                                            ),
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
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff1f2029),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'RM ${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
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