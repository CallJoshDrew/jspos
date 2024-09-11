import 'dart:developer';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/sample_receipt.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:jspos/print/kitchen_receipt.dart';
import 'package:jspos/print/beverage_receipt.dart';
import 'package:jspos/print/cashier_receipt.dart';

Future<void> handleAllPrintingJobs(BuildContext context, WidgetRef ref, SelectedOrder selectedOrder) async {
  final List<Printer> printerList = ref.read(printerListProvider);
  log('Printer List: $printerList');
  final List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];

  // Scan for available Bluetooth devices first
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Start scanning for devices
  bluetoothPrint.startScan(timeout: const Duration(seconds: 3));
  bluetoothPrint.scanResults.listen((devices) {
    availableDevices = devices;
    log('Available Bluetooth devices: ${devices.map((d) => '${d.name} (${d.address})').toList()}');
  });

  // Wait for scanning to finish
  await Future.delayed(const Duration(seconds: 3));

  for (String area in areas) {
    try {
      log('Printer list assigned area is: $area');

      // Log all printers in the list
      for (Printer printer in printerList) {
        log('Printer: ${printer.name}, Assigned Area: ${printer.assignedArea}');
      }

      // Find printer by assigned area
      Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
      if (printer != null) {
        log('Printer macAddress: ${printer.macAddress}');
        // Find the BluetoothDevice with the matching MAC address
        BluetoothDevice? device = availableDevices.firstWhereOrNull((d) => d.address == printer.macAddress);
        if (device != null) {
          // Bluetooth instance should work with the BluetoothDevice now
          final bluetoothInstance = getBluetoothInstance(ref, printer.macAddress);

          if (bluetoothInstance != null) {
            log('Attempting to connect to device: ${device.name} (${device.address})');
            bool isConnected = await bluetoothInstance.connect(device); // Use the BluetoothDevice object here
            log('Connected status for ${printer.name}: $isConnected');

            if (isConnected) {
              log('Waiting 3 seconds before printing...');
              await Future.delayed(const Duration(seconds: 3));

              // Define the receipt content based on the area
              List<LineText> receiptContent;
              switch (area) {
                case 'Kitchen':
                  receiptContent = getKitchenReceiptLines(selectedOrder);
                  break;
                case 'Beverage':
                  receiptContent = getBeverageReceiptLines(selectedOrder, printer.paperWidth);
                  break;
                case 'Cashier':
                default:
                  receiptContent = getCashierReceiptLines(selectedOrder);
                  break;
              }

              Map<String, dynamic> config = {}; // Adjust as needed for your printer configuration
              log('Printing receipt for $area area...');

              // Attempt to print the receipt
              await bluetoothInstance.printReceipt(config, receiptContent);
              log('Successfully printed receipt for $area area.');

              // Add a small delay to ensure the printer has processed the print job
              await Future.delayed(const Duration(seconds: 3));

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
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('All printing jobs are done.')),
    // );
    showCherryToast(context, 'All printing jobs are done.');
  }
}

bool hasDrinksItems(SelectedOrder selectedOrder) {
  return selectedOrder.items.isNotEmpty && selectedOrder.items.any((item) => item.category == 'Drinks');
}

bool hasDishesItems(SelectedOrder selectedOrder) {
  return selectedOrder.items.isNotEmpty && selectedOrder.items.any((item) => item.category == 'Dishes');
}

Future<void> handlePrintingJobForArea(BuildContext context, WidgetRef ref, String area, SelectedOrder selectedOrder) async {
  final List<Printer> printerList = ref.read(printerListProvider);
  log('${selectedOrder.items}');
  // Scan for available Bluetooth devices first
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Start scanning for devices
  bluetoothPrint.startScan(timeout: const Duration(seconds: 3));
  bluetoothPrint.scanResults.listen((devices) {
    availableDevices = devices;
    log('Available Bluetooth devices: ${devices.map((d) => '${d.name} (${d.address})').toList()}');
  });

  // Wait for scanning to finish
  await Future.delayed(const Duration(seconds: 3));

  try {
    // Get the printer assigned to the specified area
    Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
    if (printer != null) {
      // Find the BluetoothDevice with the matching MAC address
      BluetoothDevice? device = availableDevices.firstWhereOrNull((d) => d.address == printer.macAddress);

      if (device != null) {
        // Bluetooth instance should work with the BluetoothDevice now
        final bluetoothInstance = getBluetoothInstance(ref, device.address.toString());

        if (bluetoothInstance != null) {
          log('Attempting to connect to device: ${device.name} (${device.address})');
          bool isConnected = await bluetoothInstance.connect(device); // Use the BluetoothDevice object here
          log('Connected status for ${device.name}: $isConnected');

          if (isConnected) {
            log('Waiting 3 seconds before printing...');
            await Future.delayed(const Duration(seconds: 3));

            // Define the receipt content based on the area
            List<LineText>? receiptContent;

            switch (area) {

              case 'Kitchen':
                // Ensure there are "Dishes" items before printing for the Beverage area
                if (hasDishesItems(selectedOrder)) {
                  receiptContent = getKitchenReceiptLines(selectedOrder);
                } else {
                  log('No "Dishes" items in the order for the Kitchen area.');
                  await bluetoothInstance.disconnect();
                  return; // Exit the function if there are no "Drinks" items
                }
                break;
              case 'Beverage':
                // Ensure there are "Drinks" items before printing for the Beverage area
                if (hasDrinksItems(selectedOrder)) {
                  receiptContent = getBeverageReceiptLines(selectedOrder, printer.paperWidth);
                } else {
                  log('No "Drinks" items in the order for the Beverage area.');
                  await bluetoothInstance.disconnect();
                  return; // Exit the function if there are no "Drinks" items
                }
                break;
              case 'Cashier':
              default:
                receiptContent = getCashierReceiptLines(selectedOrder);
                break;
            }

            Map<String, dynamic> config = {}; // Adjust as needed for your printer configuration
            log('Printing receipt for $area area...');

            // Attempt to print the receipt
            await bluetoothInstance.printReceipt(config, receiptContent);
            log('Successfully printed receipt for $area area.');

            // Add a small delay to ensure the printer has processed the print job
            await Future.delayed(const Duration(seconds: 3));

            await bluetoothInstance.disconnect();
            log('Disconnected from printer: ${printer.name} (${printer.macAddress})');

            // Show a success message after printing, if mounted
            if (context.mounted) {
              log('Showing toast: Successfully printed for $area area.');
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


// Function to handle the printing process
Future<void> handleTestPrint(BuildContext context, WidgetRef ref, String area) async {
  final List<Printer> printerList = ref.read(printerListProvider);

  // Scan for available Bluetooth devices first
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Start scanning for devices
  bluetoothPrint.startScan(timeout: const Duration(seconds: 3));
  bluetoothPrint.scanResults.listen((devices) {
    availableDevices = devices;
    log('Available Bluetooth devices: ${devices.map((d) => '${d.name} (${d.address})').toList()}');
  });

  // Wait for scanning to finish
  await Future.delayed(const Duration(seconds: 3));

  try {
    // Get the printer assigned to the specified area
    Printer? printer = printerList.firstWhereOrNull((p) => p.assignedArea == area);
    if (printer != null) {
      // Find the BluetoothDevice with the matching MAC address
      BluetoothDevice? device = availableDevices.firstWhereOrNull((d) => d.address == printer.macAddress);

      if (device != null) {
        // Bluetooth instance should work with the BluetoothDevice now
        final bluetoothInstance = getBluetoothInstance(ref, printer.macAddress);

        if (bluetoothInstance != null) {
          log('Attempting to connect to device: ${device.name} (${device.address})');
          bool isConnected = await bluetoothInstance.connect(device); // Use the BluetoothDevice object here
          log('Connected status for ${printer.name}: $isConnected');

          if (isConnected) {
            log('Waiting 3 seconds before printing...');
            await Future.delayed(const Duration(seconds: 3));

            // Define the receipt content based on the area
            List<LineText> receiptContent;
            switch (area) {
              case 'Kitchen':
                receiptContent = getSampleReceiptLines();
                break;
              case 'Beverage':
                receiptContent = getSampleReceiptLines();
                break;
              case 'Cashier':
              default:
                receiptContent = getSampleReceiptLines();
                break;
            }

            Map<String, dynamic> config = {}; // Adjust as needed for your printer configuration
            log('Printing receipt for $area area...');

            // Attempt to print the receipt
            await bluetoothInstance.printReceipt(config, receiptContent);
            log('Successfully printed receipt for $area area.');

            // Add a small delay to ensure the printer has processed the print job
            await Future.delayed(const Duration(seconds: 3));

            await bluetoothInstance.disconnect();
            log('Disconnected from printer: ${printer.name} (${printer.macAddress})');

            // Show a success message after printing, if mounted
            if (context.mounted) {
              showCherryToast(context, 'Successfully printed for $area area.');
            }
          } else {
            log('Failed to connect to printer: ${printer.name} (${printer.macAddress})');
            if (context.mounted) {
              showCherryToast(context, 'Failed to connect to ${printer.name}.', iconColor: Colors.red, icon: Icons.error);
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
      showCherryToast(context, 'Error in printing for $area area: $e', iconColor: Colors.red, icon: Icons.error);
    }
  }
}

void showCherryToast(BuildContext context, String message, {Color? iconColor, IconData? icon}) {
  CherryToast(
    icon: icon ?? Icons.print, // Default to print icon if none provided
    iconColor: iconColor ?? Colors.green,
    themeColor: Colors.green,
    backgroundColor: Colors.white,
    title: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    toastPosition: Position.top,
    toastDuration: const Duration(milliseconds: 3000),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 200),
    autoDismiss: true,
    displayCloseButton: false,
  ).show(context);
}
