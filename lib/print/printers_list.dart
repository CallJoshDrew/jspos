import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/print/create_printer.dart';
import 'package:jspos/print/edit_printer.dart';
import 'package:jspos/print/print_jobs.dart';
import 'package:jspos/providers/printer_provider.dart';
import 'package:bluetooth_print/bluetooth_print.dart';

class ListOfPrinters extends ConsumerStatefulWidget {
  const ListOfPrinters({super.key});

  @override
  ListOfPrintersState createState() => ListOfPrintersState();
}

class ListOfPrintersState extends ConsumerState<ListOfPrinters> {
  BluetoothPrint? bluetoothPrint;

  @override
  Widget build(BuildContext context) {
    final printerList = ref.watch(printerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: printerList.isNotEmpty
          ? ListView.builder(
              itemCount: printerList.length,
              itemBuilder: (context, index) {
                // Sort the printerList based on the assignedArea
                printerList.sort((a, b) {
                  const areaOrder = {'Cashier': 1, 'Kitchen': 2, 'Beverage': 3};
                  return areaOrder[a.assignedArea]!.compareTo(areaOrder[b.assignedArea]!);
                });
                final printer = printerList[index];
                return ListTile(
                  title: Text(
                    '${printer.assignedArea} Area',
                    style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(printer.name),
                      Text(printer.macAddress),
                      Text(
                        'Paper: ${printer.paperWidth}',
                      ),
                      Text(
                        'Interface: ${printer.interface}',
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Connection:',
                      //       style: TextStyle(
                      //         color: printer.isConnected ? Colors.green : Colors.red,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     Icon(printer.isConnected ? Icons.check : Icons.cancel, color: printer.isConnected ? Colors.green : Colors.red, size: 18),
                      //   ],
                      // ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // if (!printer.isConnected)
                      //   ElevatedButton(
                      //     onPressed: () async {
                      //       await ref.read(printerListProvider.notifier).connectPrinter(index);
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      //       textStyle: const TextStyle(fontSize: 14),
                      //       foregroundColor: Colors.black,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     child: const Text('Connect'),
                      //   ),
                      // const SizedBox(width: 10),
                      // if (printer.isConnected)
                      //   ElevatedButton(
                      //     onPressed: () async {
                      //       await ref.read(printerListProvider.notifier).disconnectPrinter(index);
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      //       textStyle: const TextStyle(fontSize: 14),
                      //       foregroundColor: Colors.black,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     child: const Text('Disconnect'),
                      //   ),
                      // const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          handleTestPrint(context, ref, printer.assignedArea);
                          CherryToast(
                            icon: Icons.print,
                            iconColor: Colors.green,
                            themeColor: Colors.green,
                            backgroundColor: Colors.white,
                            title: Text(
                              'Printing for ${printer.assignedArea} are is in progress',
                              style: const TextStyle(
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
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Test Receipt'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditPrint(printer: printer)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.deepOrange, width: 1),
                                ),
                                content: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    maxHeight: 80,
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(
                                            'Are you sure?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "This action cannot be undone",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                    ),
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      ref.read(printerListProvider.notifier).deletePrinter(index);
                                      Navigator.of(context).pop(); // Close the dialog after deleting
                                      CherryToast(
                                        icon: Icons.print_rounded,
                                        iconColor: Colors.green,
                                        themeColor: Colors.green,
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          'Printer ${printer.name} is removed',
                                          style: const TextStyle(
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
                                    },
                                  ),
                                  const SizedBox(width: 2),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(12, 5, 12, 5)),
                                    ),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: Text('No printers available')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePrint()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
