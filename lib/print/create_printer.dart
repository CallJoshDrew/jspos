import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/print/receipt.dart';
import 'package:hive/hive.dart';

class CreatePrint extends StatefulWidget {
  const CreatePrint({super.key});

  @override
  CreatePrintState createState() => CreatePrintState();
}

class CreatePrintState extends State<CreatePrint> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  Printer? _printer;
  String tips = 'no device connect';

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
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
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
    );
  }

  Future<void> _savePrinter(Printer printer) async {
    final box = await Hive.openBox<Printer>('printers');
    await box.add(printer);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                    StreamBuilder<List<BluetoothDevice>>(
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
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5), // Rounded border
                              border: Border.all(color: Colors.black), // Black border color
                            ),
                            child: DropdownButton<BluetoothDevice>(
                              underline: Container(),
                              hint: const Text('Select a device'),
                              value: _device,
                              items: snapshot.data!.map((BluetoothDevice device) {
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
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 50),
                    if (_printer != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15), // Add padding for spacing
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(5), // Rounded border
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              'MAC Address: ${_printer!.macAddress}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 50),
                          Visibility(
                            visible: _printer!.isConnected,
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
                                          _savePrinter(_printer!);
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
                                    await bluetoothPrint.disconnect();
                                    setState(() {
                                      _connected = false;
                                      if (_printer != null) {
                                        _printer!.isConnected = false;
                                        _savePrinter(_printer!);
                                      }
                                    });
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
      ),
    );
  }
}
