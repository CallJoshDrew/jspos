import 'package:flutter/material.dart';
import 'package:jspos/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  String pageActive = "Home";

  _pageView(){
    switch(pageActive){
      case 'Home': return const HomePage();
      case 'Menu': return Container();
      case 'History': return Container();
      case 'Promos': return Container();
      case 'Settings': return Container();

      default:
      return const HomePage();
    }
  }

  _setPage(String page){
    setState((){
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
            padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
            height: MediaQuery.of(context).size.height,
            child: _sideMenu(),
          ),
          Expanded(child: Container(
            margin: const EdgeInsets.only(top: 24, right:12),
            padding: const EdgeInsets.only(top: 12, right:12, left:12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
              ),
              color: Color(0xff17181f),
            ),
              child: _pageView(),
          ),)
        ],
      ),
    );
  }

  Widget _sideMenu() {
    return Column(children: [
      _logo(),
      const SizedBox(height: 30),
      Expanded(
        child: ListView(children: [
          _itemMenu(menu: 'Home', icon: Icons.rocket_sharp),
          _itemMenu(menu: 'Menu', icon: Icons.format_list_bulleted_rounded),
          _itemMenu(menu: 'History', icon: Icons.history_toggle_off_rounded),
          _itemMenu(menu: 'Promos', icon: Icons.discount_outlined),
          _itemMenu(menu: 'Settings', icon: Icons.sports_soccer_outlined),
        ]),
      )
    ]);
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
                    color: Colors.white,
                    size: 45,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
