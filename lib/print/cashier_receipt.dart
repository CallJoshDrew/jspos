import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/selected_order.dart';

List<LineText> getCashierReceiptLines(SelectedOrder selectedOrder) {
  List<LineText> list = [];

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '**********************************************',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice ${selectedOrder.orderNumber}', // Dynamic invoice number
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

  // Loop through selectedOrder items to print each item
  for (var item in selectedOrder.items) {
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: item.name,  // Dynamic item name
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${item.quantity}',  // Dynamic quantity
        align: LineText.ALIGN_LEFT,
        x: 350,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${item.price}',  // Dynamic price
        align: LineText.ALIGN_LEFT,
        x: 500,
        relativeX: 0,
        linefeed: 1));
  }

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '**********************************************',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(linefeed: 1));

  return list;
}
