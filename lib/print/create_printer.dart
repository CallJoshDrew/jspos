import 'dart:async';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/providers/printer_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePrint extends ConsumerStatefulWidget {
  const CreatePrint({super.key});

  @override
  CreatePrintState createState() => CreatePrintState();
}

class CreatePrintState extends ConsumerState<CreatePrint> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  BluetoothDevice? _device;
  Printer? _printer;

  List<BluetoothDevice> devices = [];
  List<BluetoothDevice> uniqueDevices = [];

  List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];
  List<String> paperWidth = ['80 mm', '58 mm'];
  List<String> interface = ['Bluetooth', 'USB', 'Ethernet', 'Wifi'];
  String assignedArea = '';
  String selectedPaperWidth = '';
  String selectedInterface = '';

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
    initializeDevices();
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the subscription when disposing the widget
    bluetoothPrint.stopScan(); // Stop the Bluetooth scan
    super.dispose();
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));
    if (!mounted) return;
  }

  Printer _convertToPrinter(BluetoothDevice device) {
    return Printer(
      name: device.name ?? 'Unknown',
      macAddress: device.address!,
      isConnected: false,
      assignedArea: assignedArea,
      paperWidth: selectedPaperWidth,
      interface: selectedInterface,
      bluetoothInstance: _printer?.bluetoothInstance ?? bluetoothPrint, // Keep existing instance
    );
  }

  Future<void> initializeDevices() async {
    _subscription = bluetoothPrint.scanResults.listen((results) {
      if (!mounted) return;
      setState(() {
        devices = results.toSet().toList(); // Remove duplicates and convert to list
        uniqueDevices = devices.toSet().toList(); // Ensure the devices list is unique

        // Log the scanned devices for verification
        log('Scanned Devices:');
        for (var device in devices) {
          log('Device Name: ${device.name}, MAC Address: ${device.address}');
        }

        // Check for any duplicates in MAC Addresses
        var macAddresses = devices.map((device) => device.address).toList();
        if (macAddresses.length != macAddresses.toSet().length) {
          log('Warning: Duplicate MAC Addresses found!');
        }
      });
    });
  }

  int findPrinterIndex(List<Printer> printers, Printer printer) {
    return printers.indexWhere((p) => p.macAddress == printer.macAddress);
  }

  void addNewPrinter(WidgetRef ref) {
    if (_device != null && _device!.address != null) {
      setState(() {
        if (_printer != null) {
          final printers = ref.read(printerListProvider);
          final index = findPrinterIndex(printers, _printer!);
          if (index != -1) {
            // If the printer is already in the list, update it
            ref.read(printerListProvider.notifier).updatePrinter(index, _printer!);
            log('Updated printer: ${_printer!.toString()}');
          } else {
            // If the printer is not in the list, add it
            ref.read(printerListProvider.notifier).addPrinter(_printer!);
            log('Added new printer: ${_printer!.toString()}');
          }
          // Log the current list of printers
          log('Current list of printers: ${ref.read(printerListProvider).toString()}');
        }
      });
      // Navigate back to the previous page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Bluetooth Printer'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await bluetoothPrint?.startScan(timeout: const Duration(seconds: 5));
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Please select your printer & it's details",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (uniqueDevices.isEmpty)
                        const CircularProgressIndicator()
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              DropdownButton<BluetoothDevice>(
                                underline: Container(),
                                hint: const Text('Select a device'),
                                value: uniqueDevices.contains(_device) ? _device : null,
                                items: uniqueDevices.map((BluetoothDevice device) {
                                  return DropdownMenuItem<BluetoothDevice>(
                                    value: device,
                                    child: Text(device.name ?? device.address.toString()),
                                  );
                                }).toList(),
                                onChanged: (BluetoothDevice? newValue) {
                                  setState(() {
                                    _device = newValue;
                                    if (newValue != null) {
                                      // Add additional checks to ensure uniqueness
                                      log('Selected Device: Name: ${newValue.name}, MAC Address: ${newValue.address}');

                                      // Create or update the printer object
                                      _printer = _convertToPrinter(newValue);

                                      // Check if a device with the same MAC address is already in the list
                                      final existingDevice = uniqueDevices.firstWhereOrNull(
                                        (device) => device.address == newValue.address,
                                      );

                                      if (existingDevice != null) {
                                        log('Device already exists with MAC: ${existingDevice.address}');
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 50),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5), // Rounded border
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              'MAC Address: ${_printer?.macAddress ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Assigned Area:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ...areas.map((area) => GestureDetector(
                            onTap: () {
                              setState(() {
                                assignedArea = area;
                                if (_device != null) {
                                  _printer = _convertToPrinter(_device!);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: assignedArea == area ? Colors.white : Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                color: assignedArea == area ? Colors.green[800] : Colors.white,
                              ),
                              child: Text(
                                area,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: assignedArea == area ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Paper Width:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ...paperWidth.map((paper) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaperWidth = paper;
                                if (_device != null) {
                                  _printer = _convertToPrinter(_device!);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: selectedPaperWidth == paper ? Colors.white : Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                color: selectedPaperWidth == paper ? Colors.green[800] : Colors.white,
                              ),
                              child: Text(
                                paper,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedPaperWidth == paper ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Interface:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ...interface.map((itrface) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedInterface = itrface;
                                if (_device != null) {
                                  _printer = _convertToPrinter(_device!);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: selectedInterface == itrface ? Colors.white : Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                color: selectedInterface == itrface ? Colors.green[800] : Colors.white,
                              ),
                              child: Text(
                                itrface,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedInterface == itrface ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // const Divider(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Column(
                      children: <Widget>[
                        const Divider(),
                        OutlinedButton(
                          onPressed: () => addNewPrinter(ref),
                          child: const Text('Add Printer'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: StreamBuilder<bool>(
            stream: bluetoothPrint.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data == true) {
                return FloatingActionButton(
                  onPressed: () => bluetoothPrint.stopScan(),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                );
              } else {
                return FloatingActionButton(child: const Icon(Icons.search), onPressed: () => bluetoothPrint.startScan(timeout: const Duration(seconds: 5)));
              }
            },
          ),
        );
      },
    );
  }
}
