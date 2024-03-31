import 'package:flutter/material.dart';
import 'package:jspos/shared/order_details.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
                  action: _closedButtton(),
                ),
              ), // Add spacing between _topMenu and ListView
              // Categories of Menu
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _itemTab(
                      icon: 'assets/icons/icon-burger.png',
                      title: 'All',
                      isActive: true,
                    ),
                    _itemTab(
                      icon: 'assets/icons/icon-burger.png',
                      title: 'Burger',
                      isActive: false,
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
        const Expanded(
          flex: 5,
          child: OrderDetails(),
        ),
      ],
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
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
      width: 200,
      margin: const EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff1f2029),
          border: isActive
              ? Border.all(color: Colors.deepOrangeAccent, width: 3)
              : Border.all(color: const Color(0xff1f2029), width: 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 55,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _topMenu({
    required String title,
    required String subTitle,
    required action,
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
          Container(child: action)
        ]);
  }

  Widget _closedButtton() {
    return Container( 
      margin: const EdgeInsets.only(right: 15),
      child: ElevatedButton(  
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.red),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Adjust this value as needed
            ),
          ),
        ),
        child: const Text('Close Menu'),
      ),
    );
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
