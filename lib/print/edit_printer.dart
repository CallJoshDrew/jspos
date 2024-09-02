import 'dart:async';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jspos/models/printer.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPrint extends ConsumerStatefulWidget {
  final Printer printer;

  const EditPrint({super.key, required this.printer});

  @override
  EditPrintState createState() => EditPrintState();
}

class EditPrintState extends ConsumerState<EditPrint> {
  Printer? _printer;

  List<String> areas = ['Cashier', 'Kitchen', 'Beverage'];
  List<String> paperWidth = ['80 mm', '58 mm'];
  List<String> interface = ['Bluetooth', 'USB', 'Ethernet', 'Wifi'];
  String assignedArea = '';
  String selectedPaperWidth = '';
  String selectedInterface = '';

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    log('Initializing fields with printer: ${widget.printer.toString()}');
    _printer = widget.printer;
    assignedArea = widget.printer.assignedArea;
    selectedPaperWidth = widget.printer.paperWidth;
    selectedInterface = widget.printer.interface;
  }

  int findPrinterIndex(List<Printer> printers, Printer printer) {
    return printers.indexWhere((p) => p.macAddress == printer.macAddress);
  }

  void savePrinterEdits(WidgetRef ref) {
    log('Save button pressed');

    if (_printer != null) {
      log('Device selected: ${_printer!.name}, ${_printer!.macAddress}');

      setState(() {
        if (_printer != null) {
          log('Printer object exists: ${_printer!.toString()}');

          final printers = ref.read(printerListProvider);
          final index = findPrinterIndex(printers, _printer!);
          log('Index of the printer in the list: $index');

          if (index != -1) {
            ref.read(printerListProvider.notifier).updatePrinter(index, _printer!);
            log('Updated printer: ${_printer!.toString()}');
          } else {
            ref.read(printerListProvider.notifier).addPrinter(_printer!);
            log('Added new printer: ${_printer!.toString()}');
          }
          log('Current list of printers: ${ref.read(printerListProvider).toString()}');
        } else {
          log('Printer object is null');
        }
      });

      Navigator.pop(context);
    } else {
      log('No device selected or device address is null');
    }
  }

  Printer _convertToPrinter(String value) {
    return Printer(
      name: widget.printer.name,
      macAddress: widget.printer.macAddress,
      isConnected: widget.printer.isConnected,
      assignedArea: assignedArea,
      paperWidth: selectedPaperWidth,
      interface: selectedInterface,
      bluetoothInstance: widget.printer.bluetoothInstance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Bluetooth Printer'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        "Edit your printer & its details",
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            'Printer: ${_printer?.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                              log('Area selected: $area');
                              if (_printer != null) {
                                _printer = _convertToPrinter(area);
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
                              log('Area selected: $paper');
                              if (_printer != null) {
                                _printer = _convertToPrinter(paper);
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
                    ...interface.map((iface) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedInterface = iface;
                              log('Area selected: $iface');
                              if (_printer != null) {
                                _printer = _convertToPrinter(iface);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: selectedInterface == iface ? Colors.white : Colors.black),
                              borderRadius: BorderRadius.circular(5),
                              color: selectedInterface == iface ? Colors.green[800] : Colors.white,
                            ),
                            child: Text(
                              iface,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectedInterface == iface ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => savePrinterEdits(ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
