import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspos/shared/print_service.dart';

class PrinterSetting extends StatefulWidget {
  final BluetoothPrint bluetoothPrint;
  final ValueNotifier<BluetoothDevice?> printerDevices;
  final ValueNotifier<bool> printersConnected;
  const PrinterSetting({super.key, required this.bluetoothPrint, required this.printerDevices, required this.printersConnected});

  @override
  PrinterSettingState createState() => PrinterSettingState();
}

class PrinterSettingState extends State<PrinterSetting> {
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    widget.bluetoothPrint.startScan(timeout: const Duration(seconds: 20));

    bool isConnected = await widget.bluetoothPrint.isConnected ?? false;

    widget.bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            widget.printersConnected.value = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            widget.printersConnected.value = false;
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
        widget.printersConnected.value = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Printer Setting'),
        ),
        body: RefreshIndicator(
          onRefresh: () => widget.bluetoothPrint.startScan(timeout: const Duration(seconds: 20)),
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
                StreamBuilder<List<BluetoothDevice>>(
                  stream: widget.bluetoothPrint.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  widget.printerDevices.value = d;
                                });
                              },
                              trailing: widget.printerDevices.value != null && widget.printerDevices.value!.address == d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
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
                            onPressed: widget.printersConnected.value
                                ? null
                                : () async {
                                    if (widget.printerDevices.value != null && widget.printerDevices.value!.address != null) {
                                      setState(() {
                                        tips = 'connecting...';
                                      });
                                      await widget.bluetoothPrint.connect(widget.printerDevices.value!);
                                    } else {
                                      setState(() {
                                        tips = 'please select device';
                                      });
                                      print('please select device');
                                    }
                                  },
                            child: const Text('connect'),
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            onPressed: widget.printersConnected.value
                                ? () async {
                                    setState(() {
                                      tips = 'disconnecting...';
                                    });
                                    await widget.bluetoothPrint.disconnect();
                                  }
                                : null,
                            child: const Text('disconnect'),
                          ),
                        ],
                      ),
                      const Divider(),
                      // OutlinedButton(
                      //   onPressed: widget.printersConnected.value ? () => PrintService.printReceipt(widget.bluetoothPrint, widget.printersConnected.value) : null,
                      //   child: const Text('print receipt(esc)'),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: widget.bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return FloatingActionButton(
                onPressed: () => widget.bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  child: const Icon(Icons.search), onPressed: () => widget.bluetoothPrint.startScan(timeout: const Duration(seconds: 20)));
            }
          },
        ),
      ),
    );
  }
}
// ByteData data = await rootBundle.load("assets/images/bluetooth_print.png");
// List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// String base64Image = base64Encode(imageBytes);
// list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

// List<LineText> list1 = [];
// ByteData data = await rootBundle.load("assets/images/guide3.png");
// List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// String base64Image = base64Encode(imageBytes);
// list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));