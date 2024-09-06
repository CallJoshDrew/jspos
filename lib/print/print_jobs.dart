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

Future<void> handleAllPrintingJobs(BuildContext context, WidgetRef ref) async {
  final List<Printer> printerList = ref.read(printerListProvider);
  final List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];

  // Scan for available Bluetooth devices first
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Start scanning for devices
  bluetoothPrint.startScan(timeout: const Duration(seconds: 10));
  bluetoothPrint.scanResults.listen((devices) {
    availableDevices = devices;
    log('Available Bluetooth devices: ${devices.map((d) => '${d.name} (${d.address})').toList()}');
  });

  // Wait for scanning to finish
  await Future.delayed(const Duration(seconds: 5));

  for (String area in areas) {
    try {
      Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
      if (printer != null) {
        // Find the BluetoothDevice with the matching MAC address
        BluetoothDevice? device = availableDevices.firstWhereOrNull((d) => d.address == printer.macAddress);

        if (device != null) {
          // Bluetooth instance should work with the BluetoothDevice now
          final bluetoothInstance = ref.read(printerListProvider.notifier).getBluetoothInstance(printer.macAddress);

          if (bluetoothInstance != null) {
            log('Attempting to connect to device: ${device.name} (${device.address})');
            bool isConnected = await bluetoothInstance.connect(device); // Use the BluetoothDevice object here
            log('Connected status for ${printer.name}: $isConnected');

            if (isConnected) {
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

              // Add a small delay to ensure the printer has processed the print job
              await Future.delayed(const Duration(seconds: 10));

              await bluetoothInstance.disconnect();
              log('Disconnected from printer: ${printer.name} (${printer.macAddress})');

              // Show a success message after printing, if mounted
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully printed for $area area.')),
                );
              }
            } else {
              log('Failed to connect to printer: ${printer.name} (${printer.macAddress})');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to connect to ${printer.name}.')),
                );
              }
            }
          } else {
            log('Bluetooth instance not found for printer: ${printer.name} (${printer.macAddress})');
          }
        } else {
          log('BluetoothDevice not found for printer: ${printer.name} (${printer.macAddress})');
        }
      } else {
        log('No printer found for area: $area');
      }
    } catch (e) {
      log('Error while handling printer for $area area: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in printing for $area area: $e')),
        );
      }
    }
  }

  // Log completion and show message
  log('All printing jobs are done.');
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All printing jobs are done.')),
    );
  }
}

Future<void> handlePrintingJobForArea(
    BuildContext context, WidgetRef ref, String area) async {
  final List<Printer> printerList = ref.read(printerListProvider);

  // Scan for available Bluetooth devices first
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Start scanning for devices
  bluetoothPrint.startScan(timeout: const Duration(seconds: 5));
  bluetoothPrint.scanResults.listen((devices) {
    availableDevices = devices;
    log('Available Bluetooth devices: ${devices.map((d) => '${d.name} (${d.address})').toList()}');
  });

  // Wait for scanning to finish
  await Future.delayed(const Duration(seconds: 10));

  try {
    // Get the printer assigned to the specified area
    Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
    if (printer != null) {
      // Find the BluetoothDevice with the matching MAC address
      BluetoothDevice? device = availableDevices.firstWhereOrNull((d) => d.address == printer.macAddress);

      if (device != null) {
        // Bluetooth instance should work with the BluetoothDevice now
        final bluetoothInstance = ref.read(printerListProvider.notifier).getBluetoothInstance(printer.macAddress);

        if (bluetoothInstance != null) {
          log('Attempting to connect to device: ${device.name} (${device.address})');
          bool isConnected = await bluetoothInstance.connect(device); // Use the BluetoothDevice object here
          log('Connected status for ${printer.name}: $isConnected');

          if (isConnected) {
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

            // Add a small delay to ensure the printer has processed the print job
            await Future.delayed(const Duration(seconds: 10));

            await bluetoothInstance.disconnect();
            log('Disconnected from printer: ${printer.name} (${printer.macAddress})');

            // Show a success message after printing, if mounted
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully printed for $area area.')),
              );
            }
          } else {
            log('Failed to connect to printer: ${printer.name} (${printer.macAddress})');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to connect to ${printer.name}.')),
              );
            }
          }
        } else {
          log('Bluetooth instance not found for printer: ${printer.name} (${printer.macAddress})');
        }
      } else {
        log('BluetoothDevice not found for printer: ${printer.name} (${printer.macAddress})');
      }
    } else {
      log('No printer found for area: $area');
    }
  } catch (e) {
    log('Error while handling printer for $area area: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in printing for $area area: $e')),
      );
    }
  }
}
