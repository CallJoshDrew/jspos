import 'package:flutter/material.dart';
import 'package:jspos/screens/history/history.dart';
// import 'package:jspos/screens/recommendation/recommend.dart';
// import 'package:jspos/screens/reports/reports.dart';
import 'package:jspos/screens/settings/settings.dart';
import 'package:jspos/screens/home/home.dart';
import 'package:jspos/screens/dineIn/dine_in.dart';
import 'package:jspos/user/check_in.dart';
import 'package:jspos/user/check_out.dart';
// import 'package:jspos/screens/takeOut/take_out.dart';

class JPOSApp extends StatelessWidget {
  const JPOSApp({super.key});

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
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });
// required this.bluetoothPrint, required this.printerDevices, required this.printersConnected
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String pageActive = "Dine In";
  bool isSideMenuEnabled = true;
  bool isCheckIn = false;
  void toggleCheckInState() {
    setState(() {
      isCheckIn = !isCheckIn;
      if (!isCheckIn) {
        pageActive = 'Check In'; // Force pageActive to Check In
      } else if (pageActive == 'Check In') {
        pageActive = 'Dine In'; // Reset to default if returning to isCheckIn
      }
    });
  }

  void freezeSideMenu() {
    setState(() {
      isSideMenuEnabled = !isSideMenuEnabled;
    });
  }

  _pageView() {
    if (!isCheckIn) {
      // Show only the Check In page when isCheckIn is false
      return CheckInPage(toggleCheckInState: toggleCheckInState);
    }

    // if (!isCheckIn) {
    //   // Show only the Check In page when isCheckIn is false
    //   switch (pageActive) {
    //     case 'Check In':
    //       return CheckInPage(toggleCheckInState: toggleCheckInState);
    //     case 'Shift':
    //       return ShiftPage();
    //     default:
    //       return const HomePage();
    //   }
    // }

    // Show the rest of the pages when isCheckIn is true
    switch (pageActive) {
      case 'Dine In':
        return DineInPage(
          freezeSideMenu: freezeSideMenu,
        );
      // case 'Take Out':
      //   return TakeOutPage(freezeSideMenu: freezeSideMenu);
      case 'History':
        return const HistoryPage();
      // case 'Reports':
      //   return const ReportsPage();
      // case 'Recommend':
      //   return const RecommendPage();
      case 'Settings':
        return const SettingsPage(
        );
      case 'Check Out':
        return CheckOutPage(toggleCheckInState: toggleCheckInState);
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
              decoration:
                  const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)), color: Color(0xff17181f)
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
        child: ListView(
          children: [
            if (!isCheckIn)
              _itemMenu(page: 'Check In', icon: Icons.login_rounded),
            if (isCheckIn) ...[
              _itemMenu(page: 'Dine In', icon: Icons.dinner_dining),
              // _itemMenu(page: 'Take Out', icon: Icons.shopping_bag),
              _itemMenu(page: 'History', icon: Icons.history_sharp),
              // _itemMenu(page: 'Reports', icon: Icons.bar_chart),
              // _itemMenu(page: 'Recommend', icon: Icons.thumb_up),
              _itemMenu(page: 'Settings', icon: Icons.tune),
              _itemMenu(page: 'Check Out', icon: Icons.logout_rounded),
            ]
          ],
        ),
      )
    ]),
  );
}


  Widget _logo() {
    return const Column(
      children: [
        // Add Company Logo if necessary
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
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _itemMenu({required String page, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () => _setPage(page),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: pageActive == page ? const Color.fromRGBO(46, 125, 50, 1) : Colors.transparent,
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
                    page,
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
