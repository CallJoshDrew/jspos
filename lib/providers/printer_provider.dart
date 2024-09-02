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
        updatePrinter(index, updatedPrinter);

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
        // Attempt to disconnect the printer
        await printer.bluetoothInstance?.disconnect();
        log('Disconnected from ${printer.name}');

        // Update the printer's state
        final updatedPrinter = Printer(
          name: printer.name,
          macAddress: printer.macAddress,
          isConnected: false,
          assignedArea: printer.assignedArea,
          paperWidth: printer.paperWidth,
          interface: printer.interface,
          bluetoothInstance : null,
        );

        // Update the state and Hive storage
        updatePrinter(index, updatedPrinter);
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

    updatePrinter(index, updatedPrinter);

    // Log the printer's connection status
    log('Printer isConnected status: ${updatedPrinter.isConnected}');
  }

  BluetoothPrint? getBluetoothInstance(String macAddress) {
    return state.firstWhere((printer) => printer.macAddress == macAddress).bluetoothInstance;
  }
}
