import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/print/create_printer.dart';
import 'package:jspos/providers/printer_provider.dart';

class PrinterSetting extends ConsumerWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerList = ref.watch(printerListProvider);

    // Debug print to check if the widget rebuilds and the state
    log('Rebuilding PrinterSetting');
    log('Connected Printer: $printerList');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: printerList.isNotEmpty
          ? ListView.builder(
              itemCount: printerList.length,
              itemBuilder: (context, index) {
                final printer = printerList[index];
                return ListTile(
                  title: Text(printer.name),
                  subtitle: Text(printer.macAddress),
                  trailing: printer.isConnected ? const Icon(Icons.check, color: Colors.green) : null,
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
