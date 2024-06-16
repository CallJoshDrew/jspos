import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:jspos/print/printer_setting.dart';
import 'package:jspos/screens/settings/config/category_settings.dart';

class SettingsPage extends StatefulWidget {
  final List<String> categories;
  // final BluetoothPrint bluetoothPrint;
  // final ValueNotifier<BluetoothDevice?> printerDevices;
  // final ValueNotifier<bool> printersConnected;
  const SettingsPage({super.key, required this.categories, });
  // required this.bluetoothPrint, required this.printerDevices, required this.printersConnected

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
        margin: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: const Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Expanded(
                    //   child: SizedBox(
                    //     height: double.infinity, // or specify a certain height
                    //     child: PrinterSetting(bluetoothPrint: widget.bluetoothPrint, printerDevices: widget.printerDevices, printersConnected: widget.printersConnected),
                    //   ),
                    // ),
                    Expanded(child: CategorySettings()),
                  ],
                ),
              ),
              // Expanded(
              //   child: Row(
              //     children: [
              //       Expanded(child: CategorySettings()),
              //       Expanded(child: CategorySettings()),
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
  }
}
