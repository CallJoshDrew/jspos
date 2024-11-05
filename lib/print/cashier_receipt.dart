import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/client_profile.dart';
import 'package:jspos/models/selected_order.dart';
import 'package:jspos/print/split_text_into_lines.dart';

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
    return filteredRemarks.values.join(', ');
  }

  int calculatePriceXPosition(dynamic value, int baseXPosition) {
    int valueLength = value.toString().length;
    if (valueLength == 1) {
      return baseXPosition + 60; // Adjust for 1 digits
    } else if (valueLength == 2) {
      return baseXPosition + 40; // Adjust for 2 digits
    } else if (valueLength == 3) {
      return baseXPosition + 30; // Adjust for 3 digits
    } else if (valueLength == 4) {
      return baseXPosition + 20; // Adjust for 4 digits
    } else if (valueLength == 5) {
      return baseXPosition + 10; // Adjust for 5 digits
    } else if (valueLength == 6) {
      return baseXPosition - 10; // Adjust for 6 digits
    } else if (valueLength == 7) {
      return baseXPosition - 20; // Adjust for 7 digits
    } else if (valueLength == 8) {
      return baseXPosition - 30; // Adjust for 7 digits
    } else {
      return baseXPosition + 50; // Default adjustment
    }
  }

  String formatOneTextLine(String text) {
    const int lineLength = 32;

    // If text is already longer than lineLength, trim it
    if (text.length > lineLength) {
      return text.substring(0, lineLength);
    }

    // Pad the text to make it fit the exact line length
    return text + ' ' * (lineLength - text.length);
  }

  String formatRightAlignedText(String text) {
  const int lineLength = 48; // Adjust if necessary for your printer's width

  // Calculate the required spaces to place text at the far right with one trailing space
  int spaces = lineLength - text.length - 1;

  // Ensure spaces are non-negative
  if (spaces < 0) spaces = 0;

  return '${' ' * spaces}$text '; // Add one space after the text
}


  String formatTwoTextLine(String text1, String text2) {
    const int lineLength = 48;
    String quantityStr = text2.toString();

    // Calculate remaining space for itemName by subtracting the quantity and space between them
    int spaces = lineLength - text1.length - quantityStr.length;

    // Ensure spaces are non-negative
    if (spaces < 1) spaces = 1;

    return text1 + ' ' * spaces + quantityStr;
  }

  String formatThreeTextLine(String text1, String text2, String text3) {
    const int lineLength = 48; // Total line length
    const int spaceBetweenRightText = 10; // Space between second and third text

    // Convert second and third text to strings, in case they’re numbers
    String quantityStr = text2.toString();
    String priceStr = text3.toString();

    // Calculate available space after first text (for aligning the right side)
    int remainingSpace = lineLength - text1.length - quantityStr.length - spaceBetweenRightText - priceStr.length;

    // Ensure remaining space is non-negative
    if (remainingSpace < 1) remainingSpace = 1;

    // Construct the line with spaces between text1 and right-aligned quantity and price
    return text1 + ' ' * remainingSpace + quantityStr + ' ' * spaceBetweenRightText + priceStr;
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
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: formatOneTextLine(profile.address1),
        // content: 'Lot 14, Ground Floor Utama Zone 3 Commercial,',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    if (profile.address2 != null) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: formatOneTextLine(profile.address2!),
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    }
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
    int itemIndex = 1; // Initialize the index outside of the category loop for continuous increment

    for (var category in ['Cakes', 'Dishes', 'Drinks', 'Special', 'Add On']) {
      // Get items for the current category
      var categoryItems = selectedOrder.items.where((item) => item.category == category).toList();

      // If there are items in this category, print the category header
      // if (categoryItems.isNotEmpty) {
      //   list.add(LineText(
      //       type: LineText.TYPE_TEXT,
      //       content: category, // Category header
      //       align: LineText.ALIGN_LEFT,
      //       linefeed: 1));

      for (var item in categoryItems) {
        // Determine the item name based on your condition
        String itemName;
        int linefeed; // Define the linefeed variable

        if (item.selection && item.selectedChoice != null) {
          itemName = item.originalName;
          linefeed = 1; // Set linefeed to 1 for selectedChoice
        } else if (item.selectedDrink != null && item.selectedTemp != null) {
          itemName = item.originalName == item.selectedDrink!['name']
              ? item.originalName
              : '${item.originalName} ${item.selectedDrink?['name']} (${item.selectedTemp?['name']})';
          linefeed = 0; // Set linefeed to 0 for selectedDrink
        } else {
          itemName = item.name;
          linefeed = 0; // Default linefeed
        }

        String itemText = '$itemIndex.$itemName';

        // Calculate total price (unit price * quantity)
        double totalPrice = item.price * item.quantity;
        String priceText = totalPrice.toStringAsFixed(2); // Format the total price to 2 decimal places

        // Add the item to the print list with the correct linefeed
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: itemText,
          align: LineText.ALIGN_LEFT,
          x: 0,
          linefeed: linefeed, // Use the dynamic linefeed value
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: formatThreeTextLine(itemText, '${item.quantity}', priceText),
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          fontZoom: 1,
        ));

        if (item.selectedChoice != null) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '  ${item.selectedChoice!['name']}',
            align: LineText.ALIGN_LEFT,
            x: 0,
            linefeed: 0, // Stay on the same line
          ));
        }
        // // Add the quantity line
        // list.add(LineText(
        //     type: LineText.TYPE_TEXT,
        //     content: '${item.quantity}', // Dynamic quantity
        //     x: calculatePriceXPosition(item.quantity, 340), // Adjust x based on your printer width for quantity
        //     linefeed: 0));

        // list.add(LineText(
        //     type: LineText.TYPE_TEXT,
        //     content: priceText, // Dynamic price * quantity
        //     align: LineText.ALIGN_LEFT,
        //     x: calculatePriceXPosition(totalPrice, 460),
        //     linefeed: 1));

        // // Check and add selectedNoodlesType to the receipt
        // if (item.selection && item.selectedNoodlesType != null && item.selectedMeePortion != null) {
        //   if (item.selectedMeePortion!["name"] != "Normal Mee") {
        //     list.add(LineText(
        //       type: LineText.TYPE_TEXT,
        //       content: '  - ${item.selectedNoodlesType!["name"]} (${item.selectedMeePortion!['name']})',  // Directly reference sides['name']
        //       align: LineText.ALIGN_LEFT,
        //       x: 0,
        //       linefeed: 1));
        //   }
        // }

        String noodlesTypeText = '';

        if (item.selection && item.selectedNoodlesType != null && item.selectedNoodlesType!.isNotEmpty) {
          // Build the add-on names string with commas between them
          for (int i = 0; i < item.selectedNoodlesType!.length; i++) {
            var noodleType = item.selectedNoodlesType!.elementAt(i);
            noodlesTypeText += noodleType['name'];

            // Add a comma and space except for the last add-on
            if (i != item.selectedNoodlesType!.length - 1) {
              noodlesTypeText += ', ';
            }
          }
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatOneTextLine('- $noodlesTypeText'),
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));

          // // Use the addFormattedLines function for add-ons
          // addFormattedLines(
          //     text: noodlesTypeText,
          //     list: list,
          //     maxLength: 26,
          //     firstLinePrefix: '  - ', // Start the first line with "- "
          //     subsequentLinePrefix: '    ' // Start subsequent lines with two spaces
          //     );
        }
        String meeMeatPortionText = '';

        // Conditionally add selectedMeePortion if it's not null and not "Normal Mee"
        if (item.selectedMeePortion != null && item.selectedMeePortion!["name"] != "Normal Mee") {
          meeMeatPortionText = item.selectedMeePortion!['name'];
        }

        // Conditionally add selectedMeatPortion if it's not null and not "Normal Meat"
        if (item.selectedMeatPortion != null && item.selectedMeatPortion!["name"] != "Normal Meat") {
          // Add a space if meeMeatPortionText already has a value
          if (meeMeatPortionText.isNotEmpty) {
            meeMeatPortionText += ' ';
          }
          meeMeatPortionText += item.selectedMeatPortion!['name'];
        }

        // Add formatted text to list only if there is a value to display
        if (meeMeatPortionText.isNotEmpty) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatOneTextLine('- $meeMeatPortionText'),
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
        }

        // // Check and add selectedMeatPortion to the receipt
        // if (item.selection && item.selectedMeatPortion != null) {
        //   // Check if the selected meat portion is not "Normal"
        //   if (item.selectedMeatPortion!["name"] != "Normal Meat") {
        //     list.add(LineText(
        //         type: LineText.TYPE_TEXT,
        //         content: '  - ${item.selectedMeatPortion!["name"]}', // Print meat portion if not "Normal"
        //         align: LineText.ALIGN_LEFT,
        //         x: 0,
        //         linefeed: 1));
        //   }
        // }
        // Check and add remarks to the receipt
        if (item.selection && filterRemarks(item.itemRemarks).isNotEmpty) {
          String remarks = getFilteredRemarks(item.itemRemarks);
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatOneTextLine('- $remarks'), // Dynamic remarks with 'Remarks:' prefix
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));
        }
        // // Check and calculate total sides to the receipt
        // if (item.selection && item.selectedSide != null && item.selectedSide!.isNotEmpty) {
        //   list.add(LineText(
        //       type: LineText.TYPE_TEXT,
        //       content: ' Total Sides: ${item.selectedSide!.length}', // Print meat portion if not "Normal"
        //       align: LineText.ALIGN_LEFT,
        //       x: 0,
        //       linefeed: 1));
        // }
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
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: formatOneTextLine('- $sidesText'), // Dynamic remarks with 'Remarks:' prefix
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            fontZoom: 1,
          ));

          // // Use the addFormattedLines function for add-ons
          // addFormattedLines(
          //     text: sidesText,
          //     list: list,
          //     maxLength: 26,
          //     firstLinePrefix: '  - ', // Start the first line with "- "
          //     subsequentLinePrefix: '    ' // Start subsequent lines with two spaces
          //     );
        }
        // Increment the index for the next item across all categories
        itemIndex++;
      }
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
      content: formatOneTextLine('Subtotal ${selectedOrder.subTotal.toStringAsFixed(2)}'),
      align: LineText.ALIGN_RIGHT,
      fontZoom: 1,
      linefeed: 1,
    ));
    // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Subtotal', x: 340, linefeed: 0));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT, content: selectedOrder.subTotal.toStringAsFixed(2), x: calculatePriceXPosition(selectedOrder.subTotal, 460), linefeed: 1));
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
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: 'Total',
    //     // fontZoom: 2,
    //     weight: 1,
    //     x: 376,
    //     linefeed: 0));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: selectedOrder.totalPrice.toStringAsFixed(2),
    //     // fontZoom: 2,
    //     weight: 1,
    //     x: calculatePriceXPosition(selectedOrder.totalPrice, 460),
    //     linefeed: 1));
    // list.add(
    //     LineText(type: LineText.TYPE_TEXT, content: '-----------------------------------------------', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Amount Received (${selectedOrder.paymentMethod})', selectedOrder.amountReceived.toStringAsFixed(2)),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: formatTwoTextLine('Amount Change (${selectedOrder.amountChanged})', selectedOrder.amountChanged.toStringAsFixed(2)),
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
      fontZoom: 1,
    ));
    // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Amount Received (${selectedOrder.paymentMethod})', align: LineText.ALIGN_LEFT, x: 0, linefeed: 0));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: selectedOrder.amountReceived.toStringAsFixed(2),
    //     align: LineText.ALIGN_LEFT,
    //     x: calculatePriceXPosition(selectedOrder.amountReceived, 460),
    //     linefeed: 1));
    // list.add(LineText(type: LineText.TYPE_TEXT, content: 'Amount Change', align: LineText.ALIGN_LEFT, x: 0, linefeed: 0));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: selectedOrder.amountChanged.toStringAsFixed(2),
    //     align: LineText.ALIGN_LEFT,
    //     x: calculatePriceXPosition(selectedOrder.amountChanged, 460),
    //     linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '**************** Thank You ****************', align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }
}
