import 'dart:developer';

import 'package:collection/collection.dart';
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

  PrinterListNotifier(this.box) : super([]) {
    // Load initial state from Hive when the notifier is created
    loadPrintersFromHive();
  }

  void loadPrintersFromHive() {
    // Load printers from Hive and ensure no duplicates
    state = box.values.toSet().toList(); // Avoid duplicates in Hive
    log('Loaded printers from Hive: ${state.map((printer) => printer.toString()).toList()}');
  }

  void addPrinter(Printer newPrinter) {
    final existingPrinterIndex = state.indexWhere((printer) => printer.macAddress == newPrinter.macAddress);

    // Use copyWith to ensure we modify the printer with new properties
    final updatedPrinter = newPrinter.copyWith(
      assignedArea: newPrinter.assignedArea,
      paperWidth: newPrinter.paperWidth,
      interface: newPrinter.interface,
    );

    if (existingPrinterIndex != -1) {
      // If the printer with the same MAC exists, update it
      updatePrinter(updatedPrinter); // state update is handled inside updatePrinter
      log('Updated existing printer with MAC: ${updatedPrinter.macAddress}');
    } else {
      // Otherwise, add the new printer with updated fields
      box.add(updatedPrinter);
      log('Added new printer with MAC: ${updatedPrinter.macAddress}');

      // Only update state after adding a new printer
      state = box.values.toList();
    }
  }

  void updatePrinter(Printer updatedPrinter) {
    final box = Hive.box<Printer>('printersBox'); // Hive box

    // Find the existing printer in the Hive box by its MAC address
    final existingPrinterIndex = box.values.toList().indexWhere((p) => p.macAddress == updatedPrinter.macAddress);

    if (existingPrinterIndex != -1) {
      // Log the update details
      log('Updating printer with MAC: ${updatedPrinter.macAddress} at index: $existingPrinterIndex');

      // Update the printer in Hive at the found index
      box.putAt(existingPrinterIndex, updatedPrinter);

      // Log the updated printer details
      log('Updated printer at index: $existingPrinterIndex with new values: ${updatedPrinter.toString()}');

      // Refresh the state with the latest list of printers from Hive
      state = box.values.toList();

      // Log the latest state and list of printers from Hive
      log('Updated state after modification: ${state.toString()}');
      log('Updated Hive list of printers: ${box.values.toList()}');
    } else {
      log('Error: No existing printer found with MAC address ${updatedPrinter.macAddress}');
    }
  }

  void deletePrinterByMacAddress(String macAddress) {
    final box = Hive.box<Printer>('printersBox'); // Hive box

    // Find the existing printer in the Hive box by its MAC address
    final existingPrinterIndex = box.values.toList().indexWhere((p) => p.macAddress == macAddress);

    if (existingPrinterIndex != -1) {
      // Log the deletion details
      log('Deleting printer with MAC: $macAddress at index: $existingPrinterIndex');

      // Delete the printer in Hive at the found index
      box.deleteAt(existingPrinterIndex);

      // Log successful deletion
      log('Successfully deleted printer with MAC: $macAddress');

      // Refresh the state with the latest list of printers from Hive
      state = box.values.toList();

      // Log the latest state after deletion
      log('Updated state after deletion: ${state.toString()}');
    } else {
      log('Error: No printer found with MAC address $macAddress');
    }
  }

  Future<void> connectPrinter(int index) async {
    final printer = state[index];
    final bluetoothInstance = BluetoothPrint.instance;

    // Explicitly disconnect any existing connections
    await bluetoothInstance.disconnect();

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
      log('Device found: ${targetDevice.name}, MAC: ${targetDevice.address}');
    } catch (e) {
      log('Device not found: ${printer.macAddress}');
      targetDevice = null;
    }

    if (targetDevice != null) {
      try {
        // Attempt to connect to the printer
        final connectionResult = await bluetoothInstance.connect(targetDevice);
        log('Connection result: $connectionResult');

        // Directly use connectionResult since it's already a boolean
        final isConnected = connectionResult;

        log('Printer isConnected status: $isConnected');

        // Update printer with the Bluetooth instance and connection status
        final updatedPrinter = Printer(
          name: printer.name,
          macAddress: printer.macAddress,
          isConnected: isConnected,
          assignedArea: printer.assignedArea,
          paperWidth: printer.paperWidth,
          interface: printer.interface,
          bluetoothInstance: isConnected ? bluetoothInstance : null,
        );

        // Update the printer in the provider
        updatePrinter(updatedPrinter);

        // Log the printer's connection status
        log('Updated printer ${printer.name} with connection status: ${updatedPrinter.isConnected}');
      } catch (e) {
        log('Error connecting to device: $e');
        _handleConnectionError(index, printer);
      }
    } else {
      log('Printer not found or unable to connect.');
      _handleConnectionError(index, printer);
    }
  }

  Future<void> disconnectPrinter(int index) async {
    final printer = state[index];

    if (printer.isConnected && printer.bluetoothInstance != null) {
      try {
        // Check if the Bluetooth instance is valid before attempting to disconnect
        if (printer.bluetoothInstance != null) {
          await printer.bluetoothInstance?.disconnect();
          log('Disconnected from ${printer.name}');
        } else {
          log('Bluetooth instance is null, cannot disconnect.');
        }
        // Update the printer's state
        final updatedPrinter = Printer(
          name: printer.name,
          macAddress: printer.macAddress,
          isConnected: false,
          assignedArea: printer.assignedArea,
          paperWidth: printer.paperWidth,
          interface: printer.interface,
          bluetoothInstance: null,
        );

        // Update the state and Hive storage
        updatePrinter(updatedPrinter);
      } catch (e) {
        log('Error disconnecting from printer: $e');
        // Optionally, handle errors by showing a user-friendly message
      }
    } else {
      log('Printer is not connected or has no active Bluetooth instance.');
    }
  }

  void _handleConnectionError(int index, Printer printer) {
    // Handle connection error
    final updatedPrinter = Printer(
      name: printer.name,
      macAddress: printer.macAddress,
      isConnected: false,
      assignedArea: printer.assignedArea,
      paperWidth: printer.paperWidth,
      interface: printer.interface,
      bluetoothInstance: null,
    );

    updatePrinter(updatedPrinter);

    // Log the printer's connection status
    log('Printer isConnected status: ${updatedPrinter.isConnected}');
  }

  BluetoothPrint? getBluetoothInstance(String macAddress) {
    return state.firstWhere((printer) => printer.macAddress == macAddress).bluetoothInstance;
  }
}
// Function to get the Bluetooth instance for the specified MAC address
  BluetoothPrint? getBluetoothInstance(WidgetRef ref, String macAddress) {
    // Access the current printer list using the ref and the provider
    final printerList = ref.read(printerListProvider);

    // Find the printer with the matching macAddress
    final printer = printerList.firstWhereOrNull((p) => p.macAddress == macAddress);

    // Return the BluetoothPrint instance if the printer is found
    if (printer != null) {
      return BluetoothPrint.instance; // Return the BluetoothPrint instance
    }

    return null; // Return null if no printer found
  }