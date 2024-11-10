import 'package:flutter/material.dart';
import 'package:jspos/screens/history/history.dart';
// import 'package:jspos/screens/recommendation/recommend.dart';
// import 'package:jspos/screens/reports/reports.dart';
import 'package:jspos/screens/settings/settings.dart';
import 'package:jspos/screens/home/home.dart';
import 'package:jspos/screens/dineIn/dine_in.dart';
// import 'package:jspos/screens/takeOut/take_out.dart';

class JPOSApp extends StatelessWidget {
  final List<String> categories;
  const JPOSApp({super.key, required this.categories});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMART POS SYSTEM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(
        categories: categories,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final List<String> categories;
  const MainPage({
    super.key,
    required this.categories,
  });
// required this.bluetoothPrint, required this.printerDevices, required this.printersConnected
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String pageActive = "Dine In";
  bool isSideMenuEnabled = true;
  
  void freezeSideMenu() {
    setState(() {
      isSideMenuEnabled = !isSideMenuEnabled;
    });
  }

  _pageView() {
    switch (pageActive) {
      case 'Dine In':
        return DineInPage(
          freezeSideMenu: freezeSideMenu,
        );
      // bluetoothPrint: widget.bluetoothPrint, printerDevices: widget.printerDevices, printersConnected: widget.printersConnected
      // case 'Take Out':
      //   return TakeOutPage(freezeSideMenu: freezeSideMenu);
      case 'History':
        return const HistoryPage();
      // case 'Reports':
      //   return const ReportsPage();
      // case 'Recommend':
      //   return const RecommendPage();
      case 'Settings':
        return SettingsPage(
          categories: widget.categories,
        );
      // bluetoothPrint: widget.bluetoothPrint, printerDevices: widget.printerDevices, printersConnected: widget.printersConnected

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            padding: const EdgeInsets.only(top: 40, right: 5, left: 5),
            height: MediaQuery.of(context).size.height,
            child: _sideMenu(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(top: 20, bottom: 5), // control the pageView width (dineIn + OrderDetails)
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: Color(0xff17181f)
                // Colors.blueGrey, can try this for next color theme
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
            _itemMenu(menu: 'Dine In', icon: Icons.dinner_dining),
            // _itemMenu(menu: 'Take Out', icon: Icons.shopping_bag),
            _itemMenu(menu: 'History', icon: Icons.history_sharp),
            // _itemMenu(menu: 'Reports', icon: Icons.bar_chart),
            // _itemMenu(menu: 'Recommend', icon: Icons.recommend),
            _itemMenu(menu: 'Settings', icon: Icons.tune),
          ]),
        )
      ]),
    );
  }

  Widget _logo() {
    return const Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(10), //this is the circle size
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(24),
        //     color: Colors.deepOrangeAccent,
        //   ),
        //   child: const Icon(Icons.fastfood, color: Colors.white, size: 20),
        // ),
        SizedBox(height: 10),
        Text(
          'SMART',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          'POS SYSTEM',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _itemMenu({required String menu, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () => _setPage(menu),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: pageActive == menu ? const Color.fromRGBO(46, 125, 50, 1) : Colors.transparent,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.slowMiddle,
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSideMenuEnabled == true ? Colors.white : Colors.grey[600],
                    size: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu,
                    style: TextStyle(
                      color: isSideMenuEnabled == true ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
