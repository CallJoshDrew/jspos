import 'package:flutter/material.dart';
import 'package:jspos/data/menu1_data.dart';
// import 'package:jspos/data/menu_data.dart';

class TopFivePage extends StatelessWidget {
  // Extract only the necessary details from the menu
  final List<Map<String, dynamic>> menuItems = menu.take(5).toList();

  // Accept getTotalTab widget in the constructor
  final Widget getTotalTab;

  TopFivePage(this.getTotalTab, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            getTotalTab,
            const SizedBox(height: 10),

            // Menu Items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: menuItems.map((item) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6.0), // Small margin between items
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Item Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Item Name and Price
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1, // Set the line height as a multiple of the font size
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text exceeds maxLines
                                    maxLines: 2, // Controls how many lines the text wraps to
                                  ),
                                  const Text(
                                    'x 100',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
