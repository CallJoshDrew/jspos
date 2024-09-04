import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:jspos/print/kitchen_receipt.dart';
import 'package:jspos/print/beverage_receipt.dart';
import 'package:jspos/print/cashier_receipt.dart';

Future<void> handlePrintingJobs(BuildContext context, WidgetRef ref) async {
  final List<Printer> printerList = ref.read(printerListProvider);
  final List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];

  for (String area in areas) {
    try {
      Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
      if (printer != null) {
        final bluetoothInstance = ref.read(printerListProvider.notifier).getBluetoothInstance(printer.macAddress);

        if (bluetoothInstance != null) {
          // Attempt to connect to the printer
          log('Attempting to connect to printer: ${printer.name} (${printer.macAddress})');
          await bluetoothInstance.connect(printer.macAddress as BluetoothDevice);
          log('Connected to printer: ${printer.name} (${printer.macAddress})');

          // Add a delay of 5 seconds before printing
          log('Waiting 5 seconds before printing...');
          await Future.delayed(const Duration(seconds: 5));

          // Define the receipt content based on the area
          List<LineText> receiptContent;
          switch (area) {
            case 'Kitchen':
              receiptContent = getKitchenReceiptLines();
              break;
            case 'Beverage':
              receiptContent = getBeverageReceiptLines();
              break;
            case 'Cashier':
            default:
              receiptContent = getCashierReceiptLines();
              break;
          }

          Map<String, dynamic> config = {}; // Adjust as needed for your printer configuration
          log('Printing receipt for $area area...');

          // Attempt to print the receipt
          await bluetoothInstance.printReceipt(config, receiptContent);
          log('Successfully printed receipt for $area area.');

          // Disconnect from the printer
          await bluetoothInstance.disconnect();
          log('Disconnected from printer: ${printer.name} (${printer.macAddress})');
        } else {
          log('Bluetooth instance not found for printer: ${printer.name} (${printer.macAddress})');
        }
      } else {
        log('No printer found for area: $area');
      }
    } catch (e) {
      log('Error while handling printer for $area area: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to handle printing for $area area: $e')),
      );
    }
  }

  // Show a message when all printing jobs are done
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('All printing jobs are done.')),
  );
}
