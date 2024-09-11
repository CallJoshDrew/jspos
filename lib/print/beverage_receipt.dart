import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/selected_order.dart';

// printer width is 58mm for Beverage
List<LineText> getBeverageReceiptLines(SelectedOrder selectedOrder) {
  List<LineText> list = [];

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderNumber,
      x: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderType,
      relativeX: 300,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderDate,
      x: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderTime,
      relativeX: 300,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));

  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: "Item",
    x: 0,
    linefeed: 0));
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: 'Qyt',
    relativeX: 330,
    linefeed: 1));
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: '--------------------------------',
    weight: 1,
    align: LineText.ALIGN_CENTER,
    linefeed: 1));

  // Loop through selectedOrder items to print each item
  for (var item in selectedOrder.items) {
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: item.name,
        x: 0,
        linefeed: 0));

  // Check the length of the quantity
  int quantityXPosition = 340;  // Default for 2 digits
    if (item.quantity.toString().length == 1) {
      quantityXPosition = 350;  // Adjust for 1 digit
    } else if (item.quantity.toString().length == 3) {
      quantityXPosition = 330;  // Adjust for 3 digits
    }

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '${item.quantity}',
      relativeX: quantityXPosition,
      linefeed: 1));
}


  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Total:',
      x: 0,
      relativeX: 240,
      linefeed: 0));
  // Determine the relativeX position based on the totalQuantity's number of digits
  int totalQuantityXPosition = 340;  // Default for 2 digits
  if (selectedOrder.totalQuantity.toString().length == 1) {
    totalQuantityXPosition = 350;  // Adjust for 1 digit
  } else if (selectedOrder.totalQuantity.toString().length == 3) {
    totalQuantityXPosition = 330;  // Adjust for 3 digits
  }

  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: selectedOrder.totalQuantity.toString(),
    relativeX: totalQuantityXPosition,  // Use the calculated relativeX value
    linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '-------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      x: 220,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));

  return list;
}