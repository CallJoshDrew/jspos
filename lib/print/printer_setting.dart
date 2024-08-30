import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/print/create_printer.dart';
import 'package:jspos/providers/printer_provider.dart';

class PrinterSetting extends ConsumerWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectedPrinter = ref.watch(printerListProvider).firstWhereOrNull((printer) => printer.isConnected);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: connectedPrinter != null
          ? ListTile(
              title: Text(connectedPrinter.name),
              subtitle: Text(connectedPrinter.macAddress),
              trailing: const Icon(Icons.check, color: Colors.green),
            )
          : const Center(child: Text('No connected printers')),
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