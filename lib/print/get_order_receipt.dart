// import 'dart:developer';

import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/paper_size_config.dart';
import 'package:jspos/models/selected_order.dart';
// import 'package:jspos/print/split_text_into_lines.dart';
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
    if (filteredRemarks.isEmpty) {
      return ''; // Return an empty string if no filtered remarks exist
    }
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

    list.add(LineText(type: LineText.TYPE_TEXT, content: selectedOrder.tableName, weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
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
        String itemName = '';
        String itemDrinkName = '';

        // Determine prefix based on itemIndex
        String prefix = itemIndex > 9 ? "   - " : "  - ";

        if (item.selection && item.selectedChoice != null) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatTwoTextLine('$itemIndex.${item.originalName}', "x${item.quantity}"),
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));

          if (item.originalName != item.selectedChoice!['name']) {
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: "$prefix${item.selectedChoice!['name']}",
              align: LineText.ALIGN_LEFT,
              fontZoom: 1,
              linefeed: 1,
            ));
          }
        } else if (item.selection && item.selectedDrink != null && item.selectedTemp != null) {
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
          itemName = formatTwoTextLine("$itemIndex.${item.originalName}", "x${item.quantity}");
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: itemName,
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }

        if (item.selection && item.selectedSoupOrKonLou != null) {
          String addMilkText = '';

          // Check if selectedAddMilk is not null and its name is not 'No Milk'
          if (item.selectedAddMilk != null && item.selectedAddMilk!['name'] != 'No Milk') {
            addMilkText = ' + ${item.selectedAddMilk!['name']}';
            log('Milk: $addMilkText');
          }

          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '$prefix${item.selectedSoupOrKonLou!["name"]}$addMilkText',
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }

        String noodlesTypeText = '';
        if (item.selectedNoodlesType != null && item.selectedNoodlesType!.isNotEmpty) {
          // Filter out entries with "None" as the name
          var filteredNoodlesType = item.selectedNoodlesType!.where((noodleType) => noodleType['name'] != 'None');

          for (int i = 0; i < filteredNoodlesType.length; i++) {
            var noodleType = filteredNoodlesType.elementAt(i);
            noodlesTypeText += noodleType['name'];
            if (i != filteredNoodlesType.length - 1) {
              noodlesTypeText += ', ';
            }
          }

          if (noodlesTypeText.isNotEmpty) {
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '$prefix$noodlesTypeText',
              align: LineText.ALIGN_LEFT,
              fontZoom: 1,
              linefeed: 1,
            ));
          }
        }

        String formatMeeAndMeatPortion(item) {
          String meePortionText = '';
          if (item.selectedMeePortion != null && item.selectedMeePortion!["name"] != "Normal Mee") {
            meePortionText = item.selectedMeePortion!["name"];
          }

          String meatPortionText = '';
          if (item.selectedMeatPortion != null && item.selectedMeatPortion!["name"] != "Normal Meat") {
            meatPortionText = item.selectedMeatPortion!["name"];
          }

          List<String> portions = [];
          if (meePortionText.isNotEmpty) portions.add(meePortionText);
          if (meatPortionText.isNotEmpty) portions.add(meatPortionText);

          return portions.isNotEmpty ? '$prefix${portions.join(', ')}' : '';
        }

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

        if (item.selection) {
          final filteredRemarks = filterRemarks(item.itemRemarks);
          if (filteredRemarks.isNotEmpty) {
            log('Item Remarks are: ${item.itemRemarks}');
            String remarks = getFilteredRemarks(item.itemRemarks);

            // Only add LineText if remarks are not empty
            if (remarks.isNotEmpty) {
              String content = '$prefix$remarks';
              list.add(LineText(
                type: LineText.TYPE_TEXT,
                content: content,
                align: LineText.ALIGN_LEFT,
                linefeed: 1,
                fontZoom: 1,
              ));
            }
          }
        }

        String sidesText = '';
        if (item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty) {
          for (int i = 0; i < item.selectedSide!.length; i++) {
            var side = item.selectedSide!.elementAt(i);
            sidesText += side['name'];
            if (i != item.selectedSide!.length - 1) {
              sidesText += ', ';
            }
          }
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '$prefix${item.selectedSide!.length} Sides: $sidesText',
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));

          if (item.tapao != false) {
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: prefix + 'Tapao',
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              fontZoom: 1,
            ));
          }
        }
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
