import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/print/create_printer.dart';
import 'package:jspos/providers/printer_provider.dart';

class PrinterSetting extends ConsumerWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printers = ref.watch(printerListProvider);
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: ListView(
        children: printers
            .map((printer) => ListTile(
                  title: Text(printer.name),
                  subtitle: Text(printer.macAddress),
                  trailing: printer.isConnected
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePrint()
      ),
    );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}