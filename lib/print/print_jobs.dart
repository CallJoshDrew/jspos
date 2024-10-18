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
import 'package:jspos/print/order_receipt.dart';
import 'package:jspos/print/sample_receipt.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:jspos/print/cashier_receipt.dart';

import 'package:jspos/models/client_profile.dart';
import 'package:jspos/providers/client_profile_provider.dart'; // Import the provider

Future<void> handlePrintingJobs(
  BuildContext context,
  WidgetRef ref, {
  SelectedOrder? selectedOrder,
  String? specificArea,
  String? testPrint,
}) async {
  // Fetch printer list once at the beginning avoid using ref after this point
  final List<Printer> printerList = ref.read(printerListProvider);
  log('Printer List: $printerList');

  final List<String> areas = specificArea != null ? [specificArea] : ['Kitchen', 'Beverage'];
  // removed cashier from specific

  // Scan for available Bluetooth devices first
  // Fetch the client profile using the provider
  final clientBox = await ref.read(clientProfileBoxProvider.future);
  final ClientProfile? profile = clientBox.getAt(0); // Get the first profile (assuming only one)

  if (profile == null) {
    log('Client profile not found. Cannot print Cashier receipt.');
    return;
  }

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> availableDevices = [];

  // Scan for available Bluetooth devices
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
          final bluetoothInstance = getBluetoothInstance(ref, printer.macAddress);

          if (bluetoothInstance != null) {
            log('Attempting to connect to device: ${device.name} (${device.address})');
            bool isConnected = await bluetoothInstance.connect(device);
            log('Connected status for ${printer.name}: $isConnected');

            if (isConnected) {
              log('Waiting 3 seconds before printing...');
              await Future.delayed(const Duration(seconds: 4));
              List<LineText> receiptContent;

              if (testPrint != null) {
                // Use sample receipt content if testPrint is not null
                log('Using sample receipt content for $area.');
                // receiptContent = getSampleReceiptLines();
                switch (area) {
                  case 'Kitchen':
                    receiptContent = getSampleReceiptLines(profile);
                    break;
                  case 'Beverage':
                receiptContent = getSampleReceiptLines(profile);
                    break;
                  case 'Cashier':
                  default:
                    receiptContent = getSampleReceiptLines(profile);
                    break;
                }
              } else {
                // Use actual receipt content for the selected order
                log('Using actual receipt content for $area.');
                OrderReceiptGenerator orderReceiptGenerator = OrderReceiptGenerator();
                CashierReceiptGenerator cashierReceiptGenerator = CashierReceiptGenerator();

                switch (area) {
                  case 'Kitchen':
                    if (hasDishesItems(selectedOrder!)) {
                      receiptContent = orderReceiptGenerator.getOrderReceiptLines(
                          selectedOrder, printer.paperWidth, "Dishes");
                    } else {
                      log('No "Dishes" items in the order for the Kitchen area.');
                      await bluetoothInstance.disconnect();
                      continue;
                    }
                    break;

                  case 'Beverage':
                    if (hasDrinksItems(selectedOrder!)) {
                      receiptContent = orderReceiptGenerator.getOrderReceiptLines(
                          selectedOrder, printer.paperWidth, "Drinks");
                    } else {
                      log('No "Drinks" items in the order for the Beverage area.');
                      await bluetoothInstance.disconnect();
                      continue;
                    }
                    break;

                  case 'Cashier':
                  default:
                    receiptContent = cashierReceiptGenerator.getCashierReceiptLines(
                        selectedOrder!, profile);  // Pass the profile here
                    break;
                }
              }

              Map<String, dynamic> config = {};
              log('Printing receipt for $area area...');

              await bluetoothInstance.printReceipt(config, receiptContent);
              log('Successfully printed receipt for $area area.');

              await Future.delayed(const Duration(seconds: 3));
              await bluetoothInstance.disconnect();
              log('Disconnected from printer: ${printer.name} (${printer.macAddress})');

              if (context.mounted && areas != ['Cashier', 'Kitchen', 'Beverage']) {
                showCherryToast(context, 'Successfully printed for $area area.');
              }
            } else {
              log('Failed to connect to printer: ${printer.name} (${printer.macAddress})');
              if (context.mounted) {
                showCherryToast(
                  context,
                  'Failed to connect to ${printer.name}.',
                  iconColor: Colors.red,
                  icon: Icons.error,
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
        showCherryToast(
          context,
          'Error in printing for $area area: $e',
          iconColor: Colors.red,
          icon: Icons.error,
        );
      }
    }
  }

  log('All printing jobs are done.');
  if (context.mounted && areas == ['Cashier', 'Kitchen', 'Beverage']) {
    showCherryToast(context, 'All printing jobs are done.');
  }
}

bool hasDrinksItems(SelectedOrder selectedOrder) {
  return selectedOrder.items.isNotEmpty && selectedOrder.items.any((item) => item.category == 'Drinks');
}

bool hasDishesItems(SelectedOrder selectedOrder) {
  return selectedOrder.items.isNotEmpty && selectedOrder.items.any((item) => item.category == 'Dishes');
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
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
    displayCloseButton: false,
  ).show(context);
}
