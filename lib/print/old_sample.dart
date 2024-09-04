import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/print/beverage_receipt.dart';
import 'package:hive/hive.dart';
import 'package:jspos/providers/printer_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPrint extends StatefulWidget {
  const EditPrint({super.key, required Printer printer});

  @override
  EditPrintState createState() => EditPrintState();
}

class EditPrintState extends State<EditPrint> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  Printer? _printer;
  String tips = 'No Printer is Connected';

  String assignedArea = '';
  String paperWidth = '';
  String interface = '';
  String printerModel = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      log('******************* current device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Device is connected successfully!';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'You have disconnected the device!';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  Printer _convertToPrinter(BluetoothDevice device) {
    return Printer(
      name: device.name ?? 'Unknown',
      macAddress: device.address!,
      isConnected: _connected,
      assignedArea: assignedArea,
      paperWidth: paperWidth,
      interface: interface,
    );
  }

  int findPrinterIndex(List<Printer> printers, Printer printer) {
    return printers.indexWhere((p) => p.macAddress == printer.macAddress);
  }

  Future<void> initializeDevices() async {
    List<BluetoothDevice> devices = await bluetoothPrint.scanResults.first;
    List<BluetoothDevice> uniqueDevices = devices.toSet().toList();

    if (_device == null && uniqueDevices.isNotEmpty) {
      _device = uniqueDevices.first;
      _printer = _convertToPrinter(_device!);
      tips = _printer?.isConnected == false
                ? 'Device is already connected!'
                : 'You have disconnected the device!';
    } else if (!uniqueDevices.contains(_device)) {
      _device = null;
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
            onRefresh: () => bluetoothPrint.startScan(timeout: const Duration(seconds: 5)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(tips),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<void>(
                        future: initializeDevices(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return StreamBuilder<List<BluetoothDevice>>(
                              stream: bluetoothPrint.scanResults,
                              initialData: const [],
                              builder: (c, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text('No devices found');
                                } else {
                                  List<BluetoothDevice> uniqueDevices = snapshot.data!.toSet().toList();

                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5), // Rounded border
                                      border: Border.all(color: Colors.black), // Black border color
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
                                                _printer = _convertToPrinter(newValue);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 50),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15), // Add padding for spacing
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
                          Visibility(
                            visible: _printer?.isConnected ?? false,
                            replacement: const Row(
                              children: <Widget>[
                                Text(
                                  'Connected:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.cancel_rounded, color: Colors.red), // Show cancel icon if not connected
                              ],
                            ),
                            child: const Row(
                              children: <Widget>[
                                Text(
                                  'Connected:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.check_circle, color: Colors.green), // Show checkmark icon if connected
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlinedButton(
                              onPressed: _connected
                                  ? null
                                  : () async {
                                      if (_device != null && _device!.address != null) {
                                        setState(() {
                                          tips = 'connecting...';
                                        });
                                        await bluetoothPrint.connect(_device!);
                                        setState(() {
                                          _connected = true;
                                          if (_printer != null) {
                                            _printer!.isConnected = true;
                                            final printers = ref.read(printerListProvider); // Get the list of printers
                                            final index = findPrinterIndex(printers, _printer!);

                                            if (index != -1) {
                                              // If the printer is already in the list, update it
                                              ref.read(printerListProvider.notifier).updatePrinter(index, _printer!);
                                            } else {
                                              // If the printer is not in the list, add it
                                              ref.read(printerListProvider.notifier).addPrinter(_printer!);
                                            }
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          tips = 'please select device';
                                        });
                                        log('please select device');
                                      }
                                    },
                              child: const Text('connect'),
                            ),
                            const SizedBox(width: 10.0),
                            OutlinedButton(
                              onPressed: _connected
                                  ? () async {
                                      setState(() {
                                        tips = 'disconnecting...';
                                      });

                                      try {
                                        await bluetoothPrint.disconnect();
                                        setState(() {
                                          _connected = false;
                                          if (_printer != null) {
                                            final printers = ref.read(printerListProvider); // Get the list of printers
                                            final index = findPrinterIndex(printers, _printer!);

                                            if (index != -1) {
                                              // If the printer is in the list, delete it
                                              ref.read(printerListProvider.notifier).deletePrinter(index);
                                            }
                                            // Update _printer's isConnected status after successful disconnection
                                            _printer!.isConnected = false;
                                          }
                                        });
                                      } catch (e) {
                                        setState(() {
                                          tips = 'Failed to disconnect';
                                        });
                                      }

                                      // Log the connected printer
                                      final connectedPrinter = ref.watch(printerListProvider).firstWhereOrNull((printer) => printer.isConnected);
                                      log(connectedPrinter?.toString() ?? 'No connected printer');
                                    }
                                  : null,
                              child: const Text('disconnect'),
                            ),
                          ],
                        ),
                        const Divider(),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  List<LineText> list = getReceiptLines();
                                  Map<String, dynamic> config = {};
                                  await bluetoothPrint.printReceipt(config, list);
                                }
                              : null,
                          child: const Text('print receipt(esc)'),
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


// Printer _convertToPrinter(BluetoothDevice device) {
//     return Printer(
//       name: device.name ?? 'Unknown',
//       macAddress: device.address!,
//       isConnected: _connected,
//       assignedArea: assignedArea,
//       paperWidth: selectedPaperWidth,
//       interface: selectedInterface,
//       printerModel: printerModel,
//     );
//   }

// List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];
//   List<String> paperWidth = ['80 mm', '58 mm'];
//   List<String> interface = ['Bluetooth', 'USB', 'Ethernet', 'Wifi'];
//   String assignedArea = '';
//   String selectedPaperWidth = '';
//   String selectedInterface = '';
//   String printerModel = '';