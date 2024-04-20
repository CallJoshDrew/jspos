import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jspos/providers/providers.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _isVisible = false;

  @override
   Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Column(
        children: [
          _orderNumber(
            title: '#Table8-0001',
            status: 'Placed Order',
            timeStamp: '04:21 PM, Sun, Mar 31, 2024',
            action: Container(),
            // isVisible: isVisible,
          ),
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                _itemOrder(
                  image: 'assets/items/1.png',
                  title: 'Orginal Burger',
                  qty: '2',
                  price: 'RM 5.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/2.png',
                  title: 'Double Burger',
                  qty: '3',
                  price: 'RM 10.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/6.png',
                  title: 'Special Black Burger',
                  qty: '2',
                  price: 'RM 8.00',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/4.png',
                  title: 'Special Cheese Burger',
                  qty: '2',
                  price: 'RM 12.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/1.png',
                  title: 'Orginal Burger',
                  qty: '2',
                  price: 'RM 5.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/2.png',
                  title: 'Double Burger',
                  qty: '3',
                  price: 'RM 10.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/6.png',
                  title: 'Special Black Burger',
                  qty: '2',
                  price: 'RM 8.00',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/4.png',
                  title: 'Special Cheese Burger',
                  qty: '2',
                  price: 'RM 12.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/1.png',
                  title: 'Orginal Burger',
                  qty: '2',
                  price: 'RM 5.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/2.png',
                  title: 'Double Burger',
                  qty: '3',
                  price: 'RM 10.99',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/6.png',
                  title: 'Special Black Burger',
                  qty: '2',
                  price: 'RM 8.00',
                  // isVisible: isVisible,
                ),
                _itemOrder(
                  image: 'assets/items/4.png',
                  title: 'Special Cheese Burger',
                  qty: '2',
                  price: 'RM 12.99',
                  // isVisible: isVisible,
                ),
              ],
            ),
          ),
          // This is SubTotal and Total Container
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xff1f2029),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Total',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'RM 40.32',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Charges',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'RM 0',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                // custom doted line.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final boxWidth = constraints.constrainWidth();
                      const dashWidth = 5.0;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(dashCount, (_) {
                          return Row(
                            children: <Widget>[
                              Container(
                                  width: dashWidth,
                                  height: 2,
                                  color: Colors.white),
                              const SizedBox(width: dashWidth),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'RM 44.64',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'Place Order & Print',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderNumber({
    required String title,
    required String status,
    required String timeStamp,
    required Widget action,
    // required ValueNotifier<bool> isVisible,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80, // Adjust this value as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 170),
                  // isVisible.value
                  _isVisible
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = true;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepOrange),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.0), // Adjust this value as needed
                              ),
                            ),
                          ),
                          child: const Text('Edit',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                ],
              ),
              Row(
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 46),
                  Text(
                    timeStamp,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container(width: double.infinity)),
        Expanded(flex: 5, child: action),
      ],
    );
  }

  Widget _itemOrder({
    required String image,
    required String title,
    required String qty,
    required String price,
    // required ValueNotifier<bool> isVisible,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xff1f2029),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Item Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          // Add, Decrease and Remove
          _isVisible
              ? Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Empty function
                        },
                        child: const CircleAvatar(
                          radius:
                              12, // Adjust this value to change the size of the CircleAvatar
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        qty,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          // Empty function
                        },
                        child: const CircleAvatar(
                          radius:
                              12, // Adjust this value to change the size of the CircleAvatar
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          // Empty function
                        },
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Text(
            'x $qty',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
