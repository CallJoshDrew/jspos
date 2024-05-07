import 'package:flutter/material.dart';
import 'package:jspos/models/orders.dart';
import 'package:jspos/screens/reports/reports.dart';
import 'package:jspos/screens/history/history.dart';
import 'package:jspos/screens/settings/settings.dart';
import 'package:jspos/screens/home/home.dart';
import 'package:jspos/screens/dineIn/dine_in.dart';
import 'package:jspos/screens/takeOut/take_out.dart';

class JPOSApp extends StatelessWidget {
  const JPOSApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSPOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String pageActive = "Dine In";
  bool isSideMenuEnabled = true;
  Orders orders = Orders(data: []);

  void toggleSideMenu() {
    setState(() {
      isSideMenuEnabled = !isSideMenuEnabled;
    });
  }

  _pageView() {
    switch (pageActive) {
      case 'Dine In':
        return DineInPage(toggleSideMenu: toggleSideMenu, orders: orders);
      case 'Take Out':
        return TakeOutPage(toggleSideMenu: toggleSideMenu);
      case 'History':
        return const HistoryPage();
      case 'Reports':
        return const ReportsPage();
      case 'Settings':
        return const SettingsPage();

      default:
        return const HomePage();
    }
  }

  _setPage(String page) {
    setState(() {
      pageActive = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2029),
      body: Row(
        children: [
          Container(
            width: 130,
            padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
            height: MediaQuery.of(context).size.height,
            child: _sideMenu(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 24, right: 12),
              padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: Color(0xff17181f),
              ),
              child: _pageView(),
            ),
          )
        ],
      ),
    );
  }

  Widget _sideMenu() {
    return IgnorePointer(
      ignoring: !isSideMenuEnabled,
      child: Column(children: [
        _logo(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(children: [
            _itemMenu(menu: 'Dine In', icon: Icons.table_bar),
            _itemMenu(menu: 'Take Out', icon: Icons.shopping_bag),
            _itemMenu(menu: 'History', icon: Icons.history_sharp),
            _itemMenu(menu: 'Reports', icon: Icons.bar_chart),
            _itemMenu(menu: 'Settings', icon: Icons.tune),
          ]),
        )
      ]),
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.deepOrangeAccent,
          ),
          child: const Icon(Icons.fastfood, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 10),
        const Text(
          'JSPOS',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _itemMenu({required String menu, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: GestureDetector(
        onTap: () => _setPage(menu),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: pageActive == menu
                    ? Colors.deepOrangeAccent
                    : Colors.transparent,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.slowMiddle,
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSideMenuEnabled == true ? Colors.white : Colors.grey[600],
                    size: 45,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu,
                    style: TextStyle(
                        color: isSideMenuEnabled == true ? Colors.white: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
