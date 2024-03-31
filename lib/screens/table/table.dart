import 'package:flutter/material.dart';
import 'package:jspos/models/tables_data.dart';
import 'package:jspos/screens/menu/menu.dart';

import 'package:jspos/shared/order_details.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  String? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        selectedTable == null ? Expanded(
          flex: 14,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                  child: Text("Please Select Table",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    itemCount: tables.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Adjust the number of items per row
                      childAspectRatio:
                          2 / 1, // Adjust the aspect ratio of the items
                      crossAxisSpacing: 10, // Add horizontal spacing
                      mainAxisSpacing: 10, // Add vertical spacing
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Add padding to each card
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTable = tables[index]['name'];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5, // elevation of the button
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tables[index]['name'],
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Empty',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ) : const MenuPage(),
        // Expanded(flex: 1, child: Container()),
        const Expanded(
          flex: 5,
          child: OrderDetails(),
        ),
      ],
    ); 
    // 
  }
}
