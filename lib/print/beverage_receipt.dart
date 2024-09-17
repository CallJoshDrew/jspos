import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/paper_size_config.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/total_quantity_calculator.dart';

class BeverageReceiptGenerator with TotalQuantityCalculator {
    // use enum for fixed value of either 58mm or 80mm
    PaperSizeConfig getPaperSizeConfig(String paperWidth) {
    switch (paperWidth) {
      case '58 mm':
        return PaperSizeConfig.mm58;
      case '80 mm':
        return PaperSizeConfig.mm80;
      default:
        throw Exception('Unsupported paper width: $paperWidth');
    }
  }

List<LineText> getBeverageReceiptLines(SelectedOrder selectedOrder, String paperWidth) {
  List<LineText> list = [];
  
  // Use the helper function to get the configuration based on paperWidth
  PaperSizeConfig paperSizeConfig = getPaperSizeConfig(paperWidth);

  // Access the configuration values from the enum
  int orderTypeWidth = paperSizeConfig.orderTypeWidth;
  int orderTimeWidth = paperSizeConfig.orderTimeWidth;
  int qtyWidth = paperSizeConfig.qtyWidth;
  String dottedLineWidth = paperSizeConfig.dottedLineWidth;
  int itemQtyWidth = paperSizeConfig.itemQtyWidth;
  int totalWidth = paperSizeConfig.totalWidth;
  int totalDottedLineWidth = paperSizeConfig.totalDottedLineWidth;
  int totalQtyWidth = paperSizeConfig.totalQtyWidth;
  String lastDottedLineWidth = paperSizeConfig.lastDottedLineWidth; 

   // Calculate the total quantity of drinks
  int totalDrinksQuantity = calculateTotalQuantityByCategory(selectedOrder, "Drinks");

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
}}