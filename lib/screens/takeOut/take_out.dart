import 'package:flutter/material.dart';

class TakeOutPage extends StatefulWidget {
  const TakeOutPage({super.key, required void Function() freezeSideMenu});

  @override
  State<TakeOutPage> createState() => _TakeOutPageState();
}

class _TakeOutPageState extends State<TakeOutPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is Take Out Page',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
