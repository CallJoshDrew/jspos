import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/printer.dart';

final printerBoxProvider = Provider<Box<Printer>>((ref) {
  return Hive.box<Printer>('printersBox');
});

final printerListProvider = StateNotifierProvider<PrinterListNotifier, List<Printer>>((ref) {
  final box = ref.read(printerBoxProvider);
  return PrinterListNotifier(box);
});

class PrinterListNotifier extends StateNotifier<List<Printer>> {
  final Box<Printer> box;

  PrinterListNotifier(this.box) : super(box.values.toList());

  void addPrinter(Printer printer) {
    box.add(printer);
    state = box.values.toList();
  }

  void updatePrinter(int index, Printer printer) {
    box.putAt(index, printer);
    state = box.values.toList();
  }

  void deletePrinter(int index) {
    box.deleteAt(index);
    state = box.values.toList();
  }
}