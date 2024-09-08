import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/selected_order.dart';

// printer width is 58mm for Kitchen
List<LineText> getKitchenReceiptLines(SelectedOrder selectedOrder) {
  List<LineText> list = [];

  list.add(LineText(
      type: LineText.TYPE_TEXT, 
      content: 'Restaurant Sing Ming Hing', 
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Lot 16, Block B, Utara Place 1, Jalan Utara, IJM Batu 6,',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Sandakan, Malaysia',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice ${selectedOrder.orderNumber}', // Dynamic invoice number
      align: LineText.ALIGN_LEFT,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Date: ${selectedOrder.orderDate} ${selectedOrder.orderTime}', // Dynamic invoice number
      align: LineText.ALIGN_LEFT,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Order Type: ${selectedOrder.orderType}', // Dynamic invoice number
      align: LineText.ALIGN_LEFT,
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
    align: LineText.ALIGN_LEFT,
    x: 0,
    relativeX: 0,
    linefeed: 0));
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: 'Qyt',
    align: LineText.ALIGN_LEFT,
    x: 240, 
    relativeX: 0,
    linefeed: 0));

  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: 'Amt(RM)',
    align: LineText.ALIGN_LEFT,
    x: 300,
    relativeX: 0,
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
        content: item.name,  // Dynamic item name
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));  // Adds a linefeed after the item name to move to next line
    
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${item.quantity}',  // Dynamic quantity
        align: LineText.ALIGN_LEFT,
        x: 250,  // Adjust x based on your printer width for quantity
        relativeX: 0,
        linefeed: 0));  // No linefeed needed here yet
    
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: item.price.toStringAsFixed(2),  // Dynamic price
        align: LineText.ALIGN_LEFT,
        x: 310,  // Adjust x based on your printer width for price
        relativeX: 0,
        linefeed: 1));  // Add linefeed after price to move to the next row
  }


  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Subtotal',
      x: 180,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.subTotal.toStringAsFixed(2),
      x: 310,
      relativeX: 0,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Total',
      // fontZoom: 2,
      weight: 1,
      x: 216,
      relativeX: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.totalPrice.toStringAsFixed(2),
      // fontZoom: 2,
      weight: 1,
      x: 310,
      relativeX: 0,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Amount Received (${selectedOrder.paymentMethod})',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.amountReceived.toStringAsFixed(2),
      align: LineText.ALIGN_LEFT,
      x: 310,
      relativeX: 0,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Amount Change',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.amountChanged.toStringAsFixed(2),
      align: LineText.ALIGN_LEFT,
      x: 310,
      relativeX: 0,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '*********** Thank You **********',
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));
  return list;
}

	// linefeed: 1: Moves the print head down by one line after printing the current line. This will result in the standard spacing between lines.
	// linefeed: 0: No line feed; the print head stays on the same line after printing the current content. This is useful if you want to print multiple items on the same line without moving to the next line.
	// linefeed: 2 or more: Moves the print head down by two or more lines. This increases the space between the current line and the next line, creating more vertical separation.
