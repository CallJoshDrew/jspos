import 'package:bluetooth_print/bluetooth_print_model.dart';

List<LineText> getCashierReceiptLines() {
  List<LineText> list = [];

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '**********************************************',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice 123',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      fontZoom: 2,
      linefeed: 1));
  list.add(LineText(linefeed: 1));

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '----------------------Details---------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Items',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Name',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 350,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Quantity',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 500,
      relativeX: 0,
      linefeed: 1));

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Nasi Goreng',
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '3',
      align: LineText.ALIGN_LEFT,
      x: 350,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '12.0',
      align: LineText.ALIGN_LEFT,
      x: 500,
      relativeX: 0,
      linefeed: 1));

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '**********************************************',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(linefeed: 1));

  return list;
}