import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/client_profile.dart';
import 'package:jspos/models/selected_order.dart';
// import 'package:jspos/print/split_text_into_lines.dart';

class CashierReceiptGenerator {
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

  // below is the length printing width. This is used for printing restaurant info on top.
  String formatCenterTextLine(String text) {
    const int lineLength = 48;
    List<String> lines = [];

    int start = 0;
    while (start < text.length) {
      // Extract up to 38 characters for the current line
      int end = (start + lineLength < text.length) ? start + lineLength : text.length;
      String line = text.substring(start, end);

      // Calculate padding to center-align the line
      int padding = (lineLength - line.length) ~/ 2;
      line = ' ' * padding + line;

      // Add centered line to the list
      lines.add(line);
      start += lineLength;
    }

    // Join all lines with a newline separator
    return lines.join('\n');
  }

  String formatOneTextLine(String text, int itemIndex) {
    if (text.trim().isEmpty) {
      return ''; // Immediately return if input text is empty or just whitespace
    }

    const int lineLength = 34;
    List<String> lines = [];

    // Determine the prefix based on the itemIndex
    String prefix = itemIndex > 9 ? "     " : "    ";

    // Add lines with proper prefixes
    for (int i = 0; i < text.length; i += lineLength) {
      String segment = text.substring(i, (i + lineLength > text.length) ? text.length : i + lineLength);
      lines.add(i == 0 ? segment : prefix + segment); // Prefix only for subsequent lines
    }

    return lines.join('\n'); // Trim to remove trailing newlines
  }

  String formatRightAlignedText(String text) {
    const int lineLength = 48; // Adjust if necessary for your printer's width
    int spaces = lineLength - text.length;
    // Ensure spaces are non-negative
    if (spaces < 0) spaces = 0;

    return ' ' * spaces + text; // Add one space after the text
  }

  String formatTwoTextLine(String text1, String text2) {
    const int lineLength = 48;
    String quantityStr = text2.toString();
    int spaces = lineLength - text1.length - quantityStr.length;

    // Ensure spaces are non-negative
    if (spaces < 1) spaces = 1;

    return text1 + ' ' * spaces + quantityStr;
  }

  String formatThreeTextLine(String text1, String text2, String text3) {
    const int lineLength = 48; // Total line length
    const int text2FixedPosition = 36; // Fixed starting position for text2

    String quantityStr = text2.toString();
    String priceStr = text3.toString();

    // Calculate remaining space between text1 and the fixed position of text2
    int spaceBeforeText2 = text2FixedPosition - text1.length;
    if (spaceBeforeText2 < 1) spaceBeforeText2 = 1; // Ensure at least 1 space

    // Calculate the remaining space for aligning text3 to the right end of the line
    int spaceBeforeText3 = lineLength - text2FixedPosition - quantityStr.length - priceStr.length;
    if (spaceBeforeText3 < 1) spaceBeforeText3 = 1;

    // Construct the line
    return text1 + ' ' * spaceBeforeText2 + quantityStr + ' ' * spaceBeforeText3 + priceStr;
  }

  // printer width is 72mm for Cashier
  List<LineText> getCashierReceiptLines(SelectedOrder selectedOrder, ClientProfile profile) {
    List<LineText> list = [];

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: profile.name,
        // content: 'TryMee IJM',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: profile.address1, weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    if (profile.address2 != null) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: profile.address2,
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    }
    // if (profile.tradingLicense != null) {
    //   list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: profile.address3,
    //     // content: formatCenterTextLine(profile.address3!), // remove formatCenterText same as address1
    //     weight: 1,
    //     align: LineText.ALIGN_CENTER,
    //     linefeed: 1,
    //   ));
    // }
    
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Trading License: ${profile.tradingLicense}',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Contact: ${profile.contactNumber}',
        // content: 'Contact: +6011 5873 0128',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Date: ${selectedOrder.orderDate}', 'Time: ${selectedOrder.orderTime}'),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Invoice: ${selectedOrder.orderNumber}', 'Type: ${selectedOrder.orderType}'),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatThreeTextLine("No.Item", 'Qyt', 'Amt(RM)'),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));

    // Loop through selectedOrder items to print each item
    int itemIndex = 1;

    for (var item in selectedOrder.items) {
      String itemName = '';
      String itemDrinkName = '';
      // Calculate total price (unit price * quantity)
      double totalPrice = item.price * item.quantity;
      String priceText = totalPrice.toStringAsFixed(2);
      // Determine prefix based on itemIndex
      String prefix = itemIndex > 9 ? "   - " : "  - ";

      if (item.selection && item.selectedChoice != null) {
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: formatThreeTextLine('$itemIndex.${item.originalName}', "x${item.quantity}", priceText),
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
          content: formatThreeTextLine('$itemIndex.$itemDrinkName', "x${item.quantity}", priceText),
          align: LineText.ALIGN_LEFT,
          fontZoom: 1,
          linefeed: 1,
        ));
      } else {
        itemName = formatThreeTextLine("$itemIndex.${item.originalName}", "x${item.quantity}", priceText);
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: itemName,
          align: LineText.ALIGN_LEFT,
          fontZoom: 1,
          linefeed: 1,
        ));
      }

      if (item.selection && item.selectedSetDrink != null) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '$prefix${item.selectedSetDrink!["name"]}',
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }
        if (item.selection && item.selectedSoupOrKonLou != null) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '$prefix${item.selectedSoupOrKonLou!["name"]}',
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
            content: formatOneTextLine('$prefix$noodlesTypeText', itemIndex),
            align: LineText.ALIGN_LEFT,
            fontZoom: 1,
            linefeed: 1,
          ));
        }
      }

      String formatMeeAndMeatPortion(item) {
        String meePortionText = '';
        if (item.selectedMeePortion != null && item.selectedMeePortion!["name"] != "Normal") {
          meePortionText = '${item.selectedMeePortion!["name"]} Mee';
        }

        String meatPortionText = '';
        if (item.selectedMeatPortion != null && item.selectedMeatPortion!["name"] != "Normal") {
          meatPortionText = '${item.selectedMeatPortion!["name"]} Meat';
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
          content: formatOneTextLine(lineMeeAndMeatPortion, itemIndex),
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          fontZoom: 1,
        ));
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
          content: formatOneTextLine('$prefix${item.selectedSide!.length} Sides: $sidesText', itemIndex),
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
          String content = remarks.isNotEmpty ? '$prefix$remarks' : '';
          String formattedText = formatOneTextLine(content, itemIndex);

          if (formattedText.trim().isNotEmpty) {
            // Ensure only non-empty content is added
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: formattedText,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              fontZoom: 1,
            ));
          }
        }
      }
      if (item.tapao != false) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: prefix + 'TAPAO',
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
        }
      // Increment the index for the next item across all categories
      itemIndex++;
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatRightAlignedText('Subtotal ${selectedOrder.subTotal.toStringAsFixed(2)}'),
      align: LineText.ALIGN_RIGHT,
      fontZoom: 1,
      linefeed: 1,
    ));
    if (selectedOrder.discount > 0) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: formatRightAlignedText('Discount ${(selectedOrder.subTotal * (selectedOrder.discount / 100)).toStringAsFixed(2)}'),
        align: LineText.ALIGN_RIGHT,
        fontZoom: 1,
        linefeed: 1,
      ));
    }
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatRightAlignedText('Total ${selectedOrder.totalPrice.toStringAsFixed(2)}'),
      align: LineText.ALIGN_RIGHT,
      fontZoom: 1,
      linefeed: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 1,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Amount Received (${selectedOrder.paymentMethod})', selectedOrder.amountReceived.toStringAsFixed(2)),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Amount Change', selectedOrder.amountChanged.toStringAsFixed(2)),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '**************** Thank You ****************', align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }
}
