import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is Sales Page',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
