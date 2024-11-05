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

  List<LineText> getOrderReceiptLines(SelectedOrder selectedOrder, String paperWidth, List<String> categories) {
    List<LineText> list = [];

    // Use the helper function to get the configuration based on paperWidth
    // PaperSizeConfig paperSizeConfig = getPaperSizeConfig(paperWidth);

    // Access the configuration values from the enum
    // int orderTypeWidth = paperSizeConfig.orderTypeWidth;
    // int orderTimeWidth = paperSizeConfig.orderTimeWidth;
    // int qtyWidth = paperSizeConfig.qtyWidth;
    // String dottedLineWidth = paperSizeConfig.dottedLineWidth;
    // int itemQtyWidth = paperSizeConfig.itemQtyWidth;
    // int totalWidth = paperSizeConfig.totalWidth;
    // int totalDottedLineWidth = paperSizeConfig.totalDottedLineWidth;
    // int totalQtyWidth = paperSizeConfig.totalQtyWidth;
    // String lastDottedLineWidth = paperSizeConfig.lastDottedLineWidth;

    // Calculate the total quantity using an anonymous function
    int totalQuantityByCategory = (() {
      int totalQuantity = 0;
      for (var item in selectedOrder.items) {
        if (categories.contains(item.category)) {
          totalQuantity += item.quantity;
        }
      }
      return totalQuantity;
    })();

    String formatRightAlignedText(String text) {
      int lineLength = paperWidth == '58 mm' ? 32 : 48;
      // Calculate the required spaces to place text at the far right with one trailing space
      int spaces = lineLength - text.length - 1;

      // Ensure spaces are non-negative
      if (spaces < 0) spaces = 0;

      return '${' ' * spaces}$text '; // Add one space after the text
    }

    String formatTwoTextLine(String text1, String text2) {
      int lineLength = paperWidth == '58 mm' ? 32 : 48;
      String quantityStr = text2.toString();
      int spaces = lineLength - text1.length - quantityStr.length - 1;

      // Ensure spaces are non-negative
      if (spaces < 1) spaces = 1;

      return text1 + ' ' * spaces + quantityStr;
    }

    list.add(
        LineText(type: LineText.TYPE_TEXT, content: 'Table ${selectedOrder.tableName}', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine(selectedOrder.orderNumber, selectedOrder.orderType),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine(selectedOrder.orderDate, selectedOrder.orderTime),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: paperWidth == '58 mm' ? '--------------------------------' : '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    // list.add(LineText(type: LineText.TYPE_TEXT, content: '------------------------------------------------', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 1, linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine("No.Item", 'Qyt'),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: paperWidth == '58 mm' ? '--------------------------------' : '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    // Initialize the index outside of the category loop for continuous increment
    int itemIndex = 1;
    // Loop through selectedOrder items to print each item
    for (var item in selectedOrder.items) {
      // Only print the item if its category is "Drinks"
      if (categories.contains(item.category)) {
        // Determine the item name and drink based on conditions
        String itemName = '';
        String itemDrinkName = '';

        // If the item has a selection and selected choice
        if (item.selection && item.selectedChoice != null) {
          // Print the originalName first, but do not add a newline if the selectedChoice is also printed
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatTwoTextLine('$itemIndex.${item.originalName}', "x${item.quantity}"),
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: item.originalName != item.selectedChoice!['name'] ? 0 : 1, // New line only if no selectedChoice
          ));

          // Only print the selectedChoice if it’s different from the originalName
          if (item.originalName != item.selectedChoice!['name']) {
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: "  - ${item.selectedChoice!['name']}",
              align: LineText.ALIGN_LEFT,
              fontZoom: 1,
              linefeed: 1, // Ensure new line after the selectedChoice
            ));
          }
        } else if (item.selection && item.selectedDrink != null && item.selectedTemp != null) {
          // Check if originalName is the same as selectedDrink's name
          if (item.originalName == item.selectedDrink?['name']) {
            itemDrinkName = '${item.selectedDrink?['name']} (${item.selectedTemp?['name']})';
          } else {
            itemDrinkName = '${item.originalName} ${item.selectedDrink?['name']}(${item.selectedTemp?['name']})';
          }

          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatTwoTextLine('$itemIndex.$itemDrinkName', "x${item.quantity}"),
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        } else {
          // Default case for items without selection and selected choice
          itemName = formatTwoTextLine("$itemIndex.${item.originalName}", "x${item.quantity}");

          // Add the item name with linefeed set to 1 to ensure a new line after each item
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: itemName,
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }

        if (item.selection && item.selectedSoupOrKonLou != null) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '  - ${item.selectedSoupOrKonLou!["name"]}',
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }
        String noodlesTypeText = '';

        if (item.selectedNoodlesType != null && item.selectedNoodlesType!.isNotEmpty) {
          for (int i = 0; i < item.selectedNoodlesType!.length; i++) {
            var noodleType = item.selectedNoodlesType!.elementAt(i);
            noodlesTypeText += noodleType['name'];

            // Add a comma and space except for the last noodle type
            if (i != item.selectedNoodlesType!.length - 1) {
              noodlesTypeText += ', ';
            }
          }

          // Add the fully built noodlesTypeText to the list, outside of the loop
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '  - $noodlesTypeText',
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }

        String formatMeeAndMeatPortion(item) {
          // Conditionally include selectedMeePortion if it's not "Normal Mee"
          String meePortionText = '';
          if (item.selectedMeePortion != null && item.selectedMeePortion!["name"] != "Normal Mee") {
            meePortionText = item.selectedMeePortion!["name"];
          }

          // Conditionally include selectedMeatPortion if it's not "Normal Meat"
          String meatPortionText = '';
          if (item.selectedMeatPortion != null && item.selectedMeatPortion!["name"] != "Normal Meat") {
            meatPortionText = item.selectedMeatPortion!["name"];
          }

          // Combine meePortionText and meatPortionText if they are not empty
          List<String> portions = [];
          if (meePortionText.isNotEmpty) portions.add(meePortionText);
          if (meatPortionText.isNotEmpty) portions.add(meatPortionText);

          // Return combined text if any are available, else return an empty string
          return portions.isNotEmpty ? '  - ${portions.join(', ')}' : '';
        }

        // Now use this function to generate the line content for Mee and Meat portions
        String lineMeeAndMeatPortion = formatMeeAndMeatPortion(item);

        if (lineMeeAndMeatPortion.isNotEmpty) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: lineMeeAndMeatPortion,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
        }

        // Check and add remarks to the receipt
        if (item.selection && filterRemarks(item.itemRemarks).isNotEmpty) {
          String remarks = getFilteredRemarks(item.itemRemarks);
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '  - $remarks', // Dynamic remarks with 'Remarks:' prefix
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
        }
        String sidesText = '';
        // Check and calculate total sides to the receipt
        if (item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty) {
          for (int i = 0; i < item.selectedSide!.length; i++) {
            var side = item.selectedSide!.elementAt(i);
            sidesText += side['name'];

            // Add a comma and space except for the last add-on
            if (i != item.selectedSide!.length - 1) {
              sidesText += ', ';
            }
          }
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '  - ${item.selectedSide!.length} Sides: $sidesText', // Print meat portion if not "Normal"
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
          // Check and display Tapao if it is true
          if (item.tapao != false) {
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '(Take Away / Tapao)',
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              fontZoom: 1,
            ));
          }
        }
        // Increment the index for the next item across all categories
        itemIndex++;
      }
    }
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: paperWidth == '58 mm' ? '--------------------------------' : '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: formatRightAlignedText('Total: ${totalQuantityByCategory.toString()}'),
        align: LineText.ALIGN_RIGHT,
        fontZoom: 1,
        linefeed: 1));
    // // Determine the relativeX position based on the totalQuantity's number of digits
    // int totalQuantityXPosition = totalQtyWidth + 40; // Default for 2 digits
    // if (selectedOrder.totalQuantity.toString().length == 1) {
    //   totalQuantityXPosition = totalQtyWidth + 50; // Adjust for 1 digit
    // } else if (selectedOrder.totalQuantity.toString().length == 3) {
    //   totalQuantityXPosition = totalQtyWidth + 30; // Adjust for 3 digits
    // }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-----------',
        // content: paperWidth == '58 mm' ? '-------------' : '-------------',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        fontZoom: 1,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    // if (paperWidth == '58 mm') {
    //   list.add(LineText(linefeed: 1));
    //   list.add(LineText(linefeed: 1));
    // }

    return list;
  }
}
