import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/selected_order.dart';

// printer width is 58mm for Beverage
List<LineText> getBeverageReceiptLines(SelectedOrder selectedOrder, String paperWidth) {
  List<LineText> list = [];

  int orderTypeWidth = 300;
  int orderTimeWidth = 300;
  int qtyWidth = 330;
  String dottedLineWidth = '--------------------------------';
  int itemQtyWidth = 300;
  int totalWidth = 300;
  int totalDottedLineWidth = 220;
  int totalQtyWidth = 300;

  String lastDottedLineWidth = '-------------';
  log('Paper Width is: ${paperWidth.toString()}');
  if (paperWidth == '58 mm') {
    orderTypeWidth = 280;
    orderTimeWidth = 280;
    qtyWidth = 330;
    dottedLineWidth = '--------------------------------';
    itemQtyWidth = 300;
    totalWidth = 240;
    totalDottedLineWidth = 220;
    totalQtyWidth = 300;
    lastDottedLineWidth = '-------------';
  } else if (paperWidth == '80 mm') {
    orderTypeWidth = 320;
    orderTimeWidth = 260;
    qtyWidth = 450;
    dottedLineWidth = '------------------------------------------------';
    itemQtyWidth = 470;
    totalWidth = 400;
    totalDottedLineWidth = 390;
    totalQtyWidth = 470;
    lastDottedLineWidth = '---------------';
  }

  int calculateTotalDrinksQuantity(SelectedOrder selectedOrder) {
    int totalDrinksQuantity = 0;

    // Loop through selectedOrder items and sum quantities for "Drinks"
    for (var item in selectedOrder.items) {
      if (item.category == "Drinks") {
        totalDrinksQuantity += item.quantity;
      }
    }

    return totalDrinksQuantity;
  }

   // Calculate the total quantity of drinks
  int totalDrinksQuantity = calculateTotalDrinksQuantity(selectedOrder);

  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderNumber,
      x: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content:selectedOrder.orderType,
      relativeX: orderTypeWidth,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderDate,
      x: 0,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: selectedOrder.orderTime,
      relativeX: orderTimeWidth,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: dottedLineWidth,
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
    relativeX: qtyWidth,
    linefeed: 1));
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: dottedLineWidth,
    weight: 1,
    align: LineText.ALIGN_CENTER,
    linefeed: 1));

  // Loop through selectedOrder items to print each item
  for (var item in selectedOrder.items) {
    // Only print the item if its category is "Drinks"
    if (item.category == "Drinks") {
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: item.name,
          x: 0,
          linefeed: 0));

      // Adjust X position based on the paper width
    int quantityXPosition = itemQtyWidth + 40; // Default

    // Further adjustments based on quantity length
    if (item.quantity.toString().length == 1) {
      quantityXPosition = itemQtyWidth + 50;  // Adjust for 1 digit
    } else if (item.quantity.toString().length == 3) {
      quantityXPosition = itemQtyWidth + 30;  // Adjust for 3 digits
    }

    // Add the quantity line
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${item.quantity}',
        x: quantityXPosition,
        linefeed: 1));
        }
  }


  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: dottedLineWidth,
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Total:',
      x: totalWidth,
      relativeX: 0,
      linefeed: 0));
  // Determine the relativeX position based on the totalQuantity's number of digits
  int totalQuantityXPosition = totalQtyWidth+40;  // Default for 2 digits
  if (selectedOrder.totalQuantity.toString().length == 1) {
    totalQuantityXPosition = totalQtyWidth+50;  // Adjust for 1 digit
  } else if (selectedOrder.totalQuantity.toString().length == 3) {
    totalQuantityXPosition = totalQtyWidth+30;  // Adjust for 3 digits
  }

  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: totalDrinksQuantity.toString(),
    x: totalQuantityXPosition,  // Use the calculated relativeX value
    linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: lastDottedLineWidth,
      weight: 1,
      align: LineText.ALIGN_CENTER,
      x: totalDottedLineWidth,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));
  if (paperWidth == '80 mm') {
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
  }

  return list;
}