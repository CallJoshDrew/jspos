import 'package:flutter/material.dart';
import 'package:jspos/print/printers_list.dart';

class SettingsPage extends StatefulWidget {
  final List<String> categories;
  const SettingsPage({super.key, required this.categories, });
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        // margin: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: const Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: double.infinity, // or specify a certain height
                        child: ListOfPrinters(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
