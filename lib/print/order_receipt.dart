import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/paper_size_config.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/split_text_into_lines.dart';
import 'package:jspos/print/total_quantity_calculator.dart';

class OrderReceiptGenerator with TotalQuantityCalculator {
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

  Map<String, dynamic> filterRemarks(Map<String, dynamic>? itemRemarks) {
    Map<String, dynamic> filteredRemarks = {};
    if (itemRemarks != null) {
      itemRemarks.forEach((key, value) {
        // Add your conditions here
        if (key != '98' && key != '99') {
          filteredRemarks[key] = value;
        }
      });
    }
    return filteredRemarks;
  }

  String getFilteredRemarks(Map<String, dynamic>? itemRemarks) {
    final filteredRemarks = filterRemarks(itemRemarks);
    return filteredRemarks.values.join(', ');
  }

  List<LineText> getOrderReceiptLines(SelectedOrder selectedOrder, String paperWidth, String category) {
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
    int totalQuantityByCategory = calculateTotalQuantityByCategory(selectedOrder, category);

    list.add(LineText(type: LineText.TYPE_TEXT, content: selectedOrder.orderNumber, x: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: selectedOrder.orderType, relativeX: orderTypeWidth, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: selectedOrder.orderDate, x: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: selectedOrder.orderTime, relativeX: orderTimeWidth, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: dottedLineWidth, weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: "No.Item", x: 0, linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Qyt', relativeX: qtyWidth, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: dottedLineWidth, weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    int itemIndex = 1; // Initialize the index outside of the category loop for continuous increment
    // Loop through selectedOrder items to print each item
    for (var item in selectedOrder.items) {
      // Only print the item if its category is "Drinks"
      if (item.category == category) {
        log(category);
        // Determine the item name based on the provided conditions
        String itemName;
        if (item.selection && item.selectedChoice != null) {
          itemName = item.originalName == item.selectedChoice!['name'] ? item.originalName : '${item.originalName} ${item.selectedChoice!['name']}';
        } else if (item.selectedDrink != null && item.selectedTemp != null) {
          itemName = item.originalName == item.selectedDrink!['name']
              ? item.originalName
              : '${item.originalName} ${item.selectedDrink?['name']} (${item.selectedTemp?['name']})';
        } else {
          itemName = item.name;
        }

        // Add item name to the list
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '$itemIndex.$itemName',
          x: 0,
          linefeed: 0,
        ));

        // Adjust X position based on the paper width
        int quantityXPosition = itemQtyWidth + 40; // Default

        // Further adjustments based on quantity length
        if (item.quantity.toString().length == 1) {
          quantityXPosition = itemQtyWidth + 50; // Adjust for 1 digit
        } else if (item.quantity.toString().length == 3) {
          quantityXPosition = itemQtyWidth + 30; // Adjust for 3 digits
        }

        // Add the quantity line
        list.add(LineText(type: LineText.TYPE_TEXT, content: '${item.quantity}', x: quantityXPosition, linefeed: 1));

        // Check and add selectedNoodlesType to the receipt
        if (item.selection && item.selectedNoodlesType != null) {
            // Always print selectedNoodlesType
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '  - ${item.selectedNoodlesType!["name"]}',  // Print selectedNoodlesType
              align: LineText.ALIGN_LEFT,
              x: 0,
              linefeed: 0,
            ));

            // Conditionally print selectedMeePortion if it's not equal to "Normal Mee"
            if (item.selectedMeePortion != null && item.selectedMeePortion!["name"] != "Normal Mee") {
                list.add(LineText(
                  type: LineText.TYPE_TEXT,
                  content: '  (${item.selectedMeePortion!["name"]})',  // Print selectedMeePortion if it's not "Normal Mee"
                  align: LineText.ALIGN_LEFT,
                  x: 0,
                  linefeed: 1,
                ));
              }
          }
        // Check and add selectedMeatPortion to the receipt
        if (item.selection && item.selectedMeatPortion != null) {
          // Check if the selected meat portion is not "Normal"
          if (item.selectedMeatPortion!["name"] != "Normal Meat") {
            list.add(LineText(
                type: LineText.TYPE_TEXT,
                content: '  - ${item.selectedMeatPortion!["name"]}', // Print meat portion if not "Normal"
                align: LineText.ALIGN_LEFT,
                x: 0,
                linefeed: 1));
          }
        }
        // Check and add remarks to the receipt
        if (item.selection && filterRemarks(item.itemRemarks).isNotEmpty) {
          String remarks = getFilteredRemarks(item.itemRemarks);
          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '  - $remarks', // Dynamic remarks with 'Remarks:' prefix
              align: LineText.ALIGN_LEFT,
              x: 0,
              linefeed: 1));
        }
        // Check and add selected add-ons to the receipt
        String sidesText = '';

        if (item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty) {
          // Build the add-on names string with commas between them
          for (int i = 0; i < item.selectedSide!.length; i++) {
            var side = item.selectedSide!.elementAt(i);
            sidesText += side['name'];

            // Add a comma and space except for the last add-on
            if (i != item.selectedSide!.length - 1) {
              sidesText += ', ';
            }
          }

          // Use the addFormattedLines function for add-ons
          addFormattedLines(
              text: sidesText,
              list: list,
              maxLength: 26,
              firstLinePrefix: '  - ', // Start the first line with "- "
              subsequentLinePrefix: '    ' // Start subsequent lines with two spaces
              );
        }
        // Increment the index for the next item across all categories
          itemIndex++;
      }
    }
    list.add(LineText(type: LineText.TYPE_TEXT, content: dottedLineWidth, weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Total:', x: totalWidth, relativeX: 0, linefeed: 0));
    // Determine the relativeX position based on the totalQuantity's number of digits
    int totalQuantityXPosition = totalQtyWidth + 40; // Default for 2 digits
    if (selectedOrder.totalQuantity.toString().length == 1) {
      totalQuantityXPosition = totalQtyWidth + 50; // Adjust for 1 digit
    } else if (selectedOrder.totalQuantity.toString().length == 3) {
      totalQuantityXPosition = totalQtyWidth + 30; // Adjust for 3 digits
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: totalQuantityByCategory.toString(),
        x: totalQuantityXPosition, // Use the calculated relativeX value
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: lastDottedLineWidth, weight: 1, align: LineText.ALIGN_CENTER, x: totalDottedLineWidth, linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    if (paperWidth == '80 mm') {
      list.add(LineText(linefeed: 1));
      list.add(LineText(linefeed: 1));
    }

    return list;
  }
}
