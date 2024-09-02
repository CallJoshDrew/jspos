import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/print/create_printer.dart';
import 'package:jspos/print/edit_printer.dart';
import 'package:jspos/print/receipt.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class PrinterSetting extends ConsumerStatefulWidget {
  const PrinterSetting({super.key});

  @override
  PrinterSettingState createState() => PrinterSettingState();
}

class PrinterSettingState extends ConsumerState<PrinterSetting> {
  BluetoothPrint? bluetoothPrint;

  @override
  Widget build(BuildContext context) {
    final printerList = ref.watch(printerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: printerList.isNotEmpty
          ? ListView.builder(
              itemCount: printerList.length,
              itemBuilder: (context, index) {
                final printer = printerList[index];
                return ListTile(
                  title: Text(printer.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(printer.macAddress),
                      Text('Area: ${printer.assignedArea}', style: const TextStyle(
                              color: Colors.green, fontSize: 16
                            ),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Connection:',
                            style: TextStyle(
                              color: printer.isConnected ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(printer.isConnected ? Icons.check : Icons.cancel, color: printer.isConnected ? Colors.green : Colors.red, size: 18),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!printer.isConnected)
                        ElevatedButton(
                          onPressed: () async {
                            await ref.read(printerListProvider.notifier).connectPrinter(index);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            textStyle: const TextStyle(fontSize: 14),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Connect'),
                        ),
                      const SizedBox(width: 10),
                      if (printer.isConnected)
                        ElevatedButton(
                          onPressed: () async {
                            await ref.read(printerListProvider.notifier).disconnectPrinter(index);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            textStyle: const TextStyle(fontSize: 14),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Disconnect'),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: printer.isConnected
                            ? () async {
                                try {
                                  final bluetoothInstance = ref.read(printerListProvider.notifier).getBluetoothInstance(printer.macAddress);

                                  if (bluetoothInstance != null) {
                                    // Log before printing
                                    log('Attempting to print receipt with ${printer.name}...');

                                    List<LineText> list = getReceiptLines();
                                    Map<String, dynamic> config = {}; // Ensure this is properly configured

                                    // Log the current Bluetooth instance details
                                    log('BluetoothPrint instance: $bluetoothInstance, Printer: $printer');
                                    log('Receipt content: $list');
                                    log('Print configuration: $config');

                                    // Attempt to print using the correct Bluetooth instance
                                    await bluetoothInstance.printReceipt(config, list);

                                    log('Print command sent successfully to ${printer.name} (${printer.macAddress}).');
                                  } else {
                                    log('Bluetooth instance not found for ${printer.name} (${printer.macAddress}).');
                                  }
                                } catch (e) {
                                  // Log the error
                                  log('Error while printing with ${printer.name}: $e');

                                  // Optionally, show a user-friendly error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to print receipt: $e')),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Print Receipt'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditPrint(printer: printer)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.deepOrange, width: 1),
                                ),
                                content: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    maxHeight: 80,
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            'Are you sure?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "This action cannot be undone",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                    ),
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      ref.read(printerListProvider.notifier).deletePrinter(index);
                                      Navigator.of(context).pop(); // Close the dialog after deleting
                                    },
                                  ),
                                  const SizedBox(width: 2),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                    ),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: Text('No printers available')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePrint()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
