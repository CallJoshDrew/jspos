import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/print/receipt.dart';
import 'package:hive/hive.dart';
import 'package:jspos/providers/printer_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePrint extends ConsumerStatefulWidget {
  const CreatePrint({super.key});

  @override
  CreatePrintState createState() => CreatePrintState();
}

class CreatePrintState extends ConsumerState<CreatePrint> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  // bool _connected = false;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
    initializeDevices();
  }

  @override
  void dispose() {
    bluetoothPrint.stopScan();
    super.dispose();
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    // bool isConnected = await bluetoothPrint.isConnected ?? false;

    // bluetoothPrint.state.listen((state) {
    //   if (!mounted) return;
    //   log('******************* current device status: $state');

    //   switch (state) {
    //     case BluetoothPrint.CONNECTED:
    //       setState(() {
    //         _connected = true;
    //       });
    //       break;
    //     case BluetoothPrint.DISCONNECTED:
    //       setState(() {
    //         _connected = false;
    //       });
    //       break;
    //     default:
    //       break;
    //   }
    // });

    if (!mounted) return;

    // if (isConnected) {
    //   setState(() {
    //     _connected = true;
    //   });
    // }
  }

  Printer _convertToPrinter(BluetoothDevice device) {
    return Printer(
      name: device.name ?? 'Unknown',
      macAddress: device.address!,
      isConnected: false,
      assignedArea: assignedArea,
      paperWidth: selectedPaperWidth,
      interface: selectedInterface,
    );
  }

  int findPrinterIndex(List<Printer> printers, Printer printer) {
    return printers.indexWhere((p) => p.macAddress == printer.macAddress);
  }

  Future<void> initializeDevices() async {
    bluetoothPrint.scanResults.listen((results) {
      setState(() {
        devices = results.toSet().toList();
        uniqueDevices = devices.toSet().toList();
      });
    });
  }

  void addNewPrinter(WidgetRef ref) {
    if (_device != null && _device!.address != null) {
      setState(() {
        if (_printer != null) {
          final printers = ref.read(printerListProvider); // Get the list of printers
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
            onRefresh: () => bluetoothPrint.startScan(timeout: const Duration(seconds: 5)),
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
                                      _printer = _convertToPrinter(newValue);
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
                          // Visibility(
                          //   visible: _printer?.isConnected ?? false,
                          //   replacement: const Row(
                          //     children: <Widget>[
                          //       Text(
                          //         'Connected:',
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       Icon(Icons.cancel_rounded, color: Colors.red), // Show cancel icon if not connected
                          //     ],
                          //   ),
                          //   child: const Row(
                          //     children: <Widget>[
                          //       Text(
                          //         'Connected:',
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       Icon(Icons.check_circle, color: Colors.green), // Show checkmark icon if connected
                          //     ],
                          //   ),
                          // ),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     OutlinedButton(
                        //       onPressed: _connected
                        //           ? null
                        //           : () async {
                        //               if (_device != null && _device!.address != null) {
                        //                 await bluetoothPrint.connect(_device!);
                        //                 setState(() {
                        //                   _connected = true;
                        //                   if (_printer != null) {
                        //                     _printer!.isConnected = true;
                        //                     final printers = ref.read(printerListProvider); // Get the list of printers
                        //                     final index = findPrinterIndex(printers, _printer!);

                        //                     if (index != -1) {
                        //                       // If the printer is already in the list, update it
                        //                       ref.read(printerListProvider.notifier).updatePrinter(index, _printer!);
                        //                     } else {
                        //                       // If the printer is not in the list, add it
                        //                       ref.read(printerListProvider.notifier).addPrinter(_printer!);
                        //                     }
                        //                   }
                        //                 });
                        //               } else {
                        //                 log('please select device');
                        //               }
                        //             },
                        //       child: const Text('connect'),
                        //     ),
                        //     const SizedBox(width: 10.0),
                        //     OutlinedButton(
                        //       onPressed: _connected
                        //           ? () async {
                        //               try {
                        //                 await bluetoothPrint.disconnect();
                        //                 setState(() {
                        //                   _connected = false;
                        //                   if (_printer != null) {
                        //                     final printers = ref.read(printerListProvider); // Get the list of printers
                        //                     final index = findPrinterIndex(printers, _printer!);

                        //                     if (index != -1) {
                        //                       // If the printer is in the list, delete it
                        //                       ref.read(printerListProvider.notifier).deletePrinter(index);
                        //                     }
                        //                     // Update _printer's isConnected status after successful disconnection
                        //                     _printer!.isConnected = false;
                        //                   }
                        //                 });
                        //               } catch (e) {
                        //                 log('Failed to disconnect');
                        //               }

                        //               // Log the connected printer
                        //               final connectedPrinter = ref.watch(printerListProvider).firstWhereOrNull((printer) => printer.isConnected);
                        //               log(connectedPrinter?.toString() ?? 'No connected printer');
                        //             }
                        //           : null,
                        //       child: const Text('disconnect'),
                        //     ),
                        //   ],
                        // ),
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
