import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: _topMenu(
                  title: 'SMH Restaurant',
                  subTitle: '28 March 2024',
                  action: _search(),
                ),
              ), // Add spacing between _topMenu and ListView
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _itemTab(
                      icon: 'assets/icons/icon-burger.png',
                      title: 'Burger',
                      isActive: true,
                    ),
                    _itemTab(
                      icon: 'assets/icons/icon-noodles.png',
                      title: 'Noodles',
                      isActive: false,
                    ),
                    _itemTab(
                      icon: 'assets/icons/icon-drinks.png',
                      title: 'Drinks',
                      isActive: false,
                    ),
                    _itemTab(
                      icon: 'assets/icons/icon-desserts.png',
                      title: 'Desserts',
                      isActive: false,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: (1 / 1.2),
                  children: [
                    _item(
                      image: 'assets/items/1.png',
                      title: 'Original Burger',
                      price: 'RM 5.99',
                      item: '11 item',
                    ),
                    _item(
                      image: 'assets/items/2.png',
                      title: 'Double Burger',
                      price: 'RM 8.99',
                      item: '10 item',
                    ),
                    _item(
                      image: 'assets/items/3.png',
                      title: 'Cheese Burger',
                      price: 'RM 6.99',
                      item: '7 item',
                    ),
                    _item(
                      image: 'assets/items/4.png',
                      title: 'Double Cheese Burger',
                      price: 'RM 12.99',
                      item: '20 item',
                    ),
                    _item(
                      image: 'assets/items/5.png',
                      title: 'Spicy Burger',
                      price: 'RM 7.39',
                      item: '12 item',
                    ),
                    _item(
                      image: 'assets/items/6.png',
                      title: 'Special Black Burger',
                      price: 'RM 7.39',
                      item: '39 item',
                    ),
                    _item(
                      image: 'assets/items/7.png',
                      title: 'Special Cheese Burger',
                      price: 'RM 8.00',
                      item: '2 item',
                    ),
                    _item(
                      image: 'assets/items/8.png',
                      title: 'Jumbo Cheese Burger',
                      price: 'RM 15.99',
                      item: '2 item',
                    ),
                    _item(
                      image: 'assets/items/9.png',
                      title: 'Spicy Burger',
                      price: 'RM 7.39',
                      item: '12 item',
                    ),
                    _item(
                      image: 'assets/items/10.png',
                      title: 'Special Black Burger',
                      price: 'RM 7.39',
                      item: '39 item',
                    ),
                    _item(
                      image: 'assets/items/11.png',
                      title: 'Special Cheese Burger',
                      price: 'RM 8.00',
                      item: '2 item',
                    ),
                    _item(
                      image: 'assets/items/12.png',
                      title: 'Jumbo Cheese Burger',
                      price: 'RM 15.99',
                      item: '2 item',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                _topMenu(
                  title: 'Order',
                  subTitle: 'Table 8',
                  action: Container(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: [
                      _itemOrder(
                        image: 'assets/items/1.png',
                        title: 'Orginal Burger',
                        qty: '2',
                        price: 'RM 5.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/2.png',
                        title: 'Double Burger',
                        qty: '3',
                        price: 'RM 10.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/6.png',
                        title: 'Special Black Burger',
                        qty: '2',
                        price: 'RM 8.00',
                      ),
                      _itemOrder(
                        image: 'assets/items/4.png',
                        title: 'Special Cheese Burger',
                        qty: '2',
                        price: 'RM 12.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/1.png',
                        title: 'Orginal Burger',
                        qty: '2',
                        price: 'RM 5.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/2.png',
                        title: 'Double Burger',
                        qty: '3',
                        price: 'RM 10.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/6.png',
                        title: 'Special Black Burger',
                        qty: '2',
                        price: 'RM 8.00',
                      ),
                      _itemOrder(
                        image: 'assets/items/4.png',
                        title: 'Special Cheese Burger',
                        qty: '2',
                        price: 'RM 12.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/1.png',
                        title: 'Orginal Burger',
                        qty: '2',
                        price: 'RM 5.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/2.png',
                        title: 'Double Burger',
                        qty: '3',
                        price: 'RM 10.99',
                      ),
                      _itemOrder(
                        image: 'assets/items/6.png',
                        title: 'Special Black Burger',
                        qty: '2',
                        price: 'RM 8.00',
                      ),
                      _itemOrder(
                        image: 'assets/items/4.png',
                        title: 'Special Cheese Burger',
                        qty: '2',
                        price: 'RM 12.99',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          height: 2,
                          width: double.infinity,
                          color: Colors.white,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemOrder({
    required String image,
    required String title,
    required String qty,
    required String price,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text(
            '$qty x',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String image,
    required String title,
    required String price,
    required String item,
  }) {
    return Container(
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
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
              ),
              Text(
                item,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemTab({
    required String icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 26),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff1f2029),
          border: isActive
              ? Border.all(color: Colors.deepOrangeAccent, width: 3)
              : Border.all(color: const Color(0xff1f2029), width: 3)),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 38,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _topMenu({
    required String title,
    required String subTitle,
    required Widget action,
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
          Expanded(flex: 5, child: action),
        ]);
  }

  Widget _search() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xff1f2029),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.white54,
            ),
            SizedBox(width: 10),
            Text(
              'Search menu here....',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            )
          ],
        ));
  }
}
