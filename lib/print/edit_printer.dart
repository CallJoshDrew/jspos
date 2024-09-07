import 'dart:developer';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
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
  List<String> paperWidth = ['80 mm', '72 mm', '58 mm'];
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

  void savePrinterEdits(WidgetRef ref, BuildContext context) {
    log('Save button pressed');

    if (_printer != null) {
      // Fetch the current list of printers
      final printers = ref.read(printerListProvider);

      // Find if the printer with the same MAC address already exists
      final existingPrinterIndex = printers.indexWhere((p) => p.macAddress == _printer!.macAddress);

      if (existingPrinterIndex != -1) {
        // Make all updates in one go at the save action
        final updatedPrinter = _printer!.copyWith(
          assignedArea: assignedArea,
          paperWidth: selectedPaperWidth,
          interface: selectedInterface,
        );
        // Update the existing printer by its MAC address
        ref.read(printerListProvider.notifier).updatePrinter(updatedPrinter);
        log('Updated printer at index: $existingPrinterIndex with new values: ${updatedPrinter.toString()}');
      } else {
        // Add a new printer if no printer with the same MAC address exists
        ref.read(printerListProvider.notifier).addPrinter(_printer!);
        log('Added new printer: ${_printer!.toString()}');
      }

      Navigator.pop(context); // Close the dialog
    } else {
      log('No printer selected');
    }
  }

  // Printer _convertToPrinter(String value) {
  //   // Use copyWith to update only the changed fields
  //   return _printer!.copyWith(
  //     assignedArea: value != assignedArea ? assignedArea : null,
  //     paperWidth: value != selectedPaperWidth ? selectedPaperWidth : null,
  //     interface: value != selectedInterface ? selectedInterface : null,
  //   );
  // }

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
                  onPressed: () {
                    savePrinterEdits(ref, context);
                    CherryToast(
                      icon: Icons.info,
                      iconColor: Colors.green,
                      themeColor: Colors.green,
                      backgroundColor: Colors.white,
                      title: const Text(
                        'You haved saved the details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      toastPosition: Position.top,
                      toastDuration: const Duration(milliseconds: 3000),
                      animationType: AnimationType.fromTop,
                      animationDuration: const Duration(milliseconds: 200),
                      autoDismiss: true,
                      displayCloseButton: false,
                    ).show(context);
                  }, // Pass both ref and context
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
