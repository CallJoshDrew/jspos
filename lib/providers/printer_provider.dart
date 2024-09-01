import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/printer.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

final printerBoxProvider = Provider<Box<Printer>>((ref) {
  return Hive.box<Printer>('printersBox');
});

final printerListProvider = StateNotifierProvider<PrinterListNotifier, List<Printer>>((ref) {
  final box = ref.read(printerBoxProvider);
  return PrinterListNotifier(box);
});

class PrinterListNotifier extends StateNotifier<List<Printer>> {
  final Box<Printer> box;

  PrinterListNotifier(this.box) : super(box.values.toList());

  void addPrinter(Printer printer) {
    box.add(printer);
    state = box.values.toList();
  }

  void updatePrinter(int index, Printer printer) {
    box.putAt(index, printer);
    state = box.values.toList();
  }

  void deletePrinter(int index) {
    box.deleteAt(index);
    state = box.values.toList();
  }

  Future<void> connectPrinter(int index) async {
    final printer = state[index];
    final bluetoothInstance = BluetoothPrint.instance;

    // Start scanning for Bluetooth devices
    bluetoothInstance.startScan(timeout: const Duration(seconds: 10));
    log('Scanning for devices...');

    // Get scan results
    final devices = await bluetoothInstance.scanResults.first;
    log('Scan results: ${devices.length} devices found');

    // Find the device that matches the printer's MAC address
    BluetoothDevice? targetDevice;
    try {
      targetDevice = devices.firstWhere(
        (d) => d.address == printer.macAddress,
      );
      log('Device found: $targetDevice');
    } catch (e) {
      targetDevice = null;
      log('Device not found: ${printer.macAddress}');
    }

    if (targetDevice != null) {
      try {
        // Attempt to connect to the printer
        final isConnected = await bluetoothInstance.connect(targetDevice);
        log('Connection status: $isConnected');

        // Update printer with the Bluetooth instance and connection status
        final updatedPrinter = Printer(
          name: printer.name,
          macAddress: printer.macAddress,
          isConnected: isConnected == BluetoothPrint.CONNECTED,
          assignedArea: printer.assignedArea,
          paperWidth: printer.paperWidth,
          interface: printer.interface,
          bluetoothInstance: bluetoothInstance, // Add this line
        );

        // Update the printer in the provider
        updatePrinter(index, updatedPrinter);

        // Log the printer's connection status
        log('Printer isConnected status: ${updatedPrinter.isConnected}');
      } catch (e) {
        log('Error connecting to device: $e');
        // Handle connection error
        final updatedPrinter = Printer(
          name: printer.name,
          macAddress: printer.macAddress,
          isConnected: false,
          assignedArea: printer.assignedArea,
          paperWidth: printer.paperWidth,
          interface: printer.interface,
          bluetoothInstance: null, // Add this line
        );

        updatePrinter(index, updatedPrinter);

        // Log the printer's connection status
        log('Printer isConnected status: ${updatedPrinter.isConnected}');
      }
    } else {
      // Handle the case where the printer was not found
      final updatedPrinter = Printer(
        name: printer.name,
        macAddress: printer.macAddress,
        isConnected: false,
        assignedArea: printer.assignedArea,
        paperWidth: printer.paperWidth,
        interface: printer.interface,
        bluetoothInstance: null, // Add this line
      );

      updatePrinter(index, updatedPrinter);

      // Log the printer's connection status
      log('Printer isConnected status: ${updatedPrinter.isConnected}');
    }
  }

  BluetoothPrint? getBluetoothInstance(String macAddress) {
    return state.firstWhere((printer) => printer.macAddress == macAddress).bluetoothInstance;
  }
}
