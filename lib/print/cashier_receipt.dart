import 'package:bluetooth_print/bluetooth_print_model.dart';
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
      return baseXPosition + 60;  // Adjust for 1 digits
    } else if (valueLength == 2) {
      return baseXPosition + 40;  // Adjust for 2 digits
    } else if (valueLength == 3) {
      return baseXPosition + 30;  // Adjust for 3 digits
    } else if (valueLength == 4) {
      return baseXPosition + 20;  // Adjust for 4 digits
    } else if (valueLength == 5) {
      return baseXPosition + 10;  // Adjust for 5 digits
    } else if (valueLength == 6) {
      return baseXPosition - 10;  // Adjust for 6 digits
    } else if (valueLength == 7) {
      return baseXPosition - 20;  // Adjust for 7 digits
    } else if (valueLength == 8) {
      return baseXPosition - 30;  // Adjust for 7 digits
    } else {
      return baseXPosition + 50;  // Default adjustment
    }
  }
  
  // printer width is 72mm for Cashier
  List<LineText> getCashierReceiptLines(SelectedOrder selectedOrder) {
    List<LineText> list = [];
    
    list.add(LineText(
        type: LineText.TYPE_TEXT, 
        content: 'Restaurant Sing Ming Hing', 
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Lot 16, Block B, Utara Place 1, Jalan Utara,',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'IJM Batu 6, Sandakan, Malaysia',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Contact: +6016 822 6188',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Date: ${selectedOrder.orderDate}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Time: ${selectedOrder.orderTime}',
      align: LineText.ALIGN_LEFT,
      x: 380,
      linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice: ${selectedOrder.orderNumber}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Type: ${selectedOrder.orderType}',
      align: LineText.ALIGN_LEFT,
      x: 380,
      linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-----------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: "No.Item",
      align: LineText.ALIGN_LEFT,
      x: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Qyt',
      align: LineText.ALIGN_LEFT,
      x: 380, 
      linefeed: 0));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Amt(RM)',
      align: LineText.ALIGN_LEFT,
      x: 470,
      linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '-----------------------------------------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1));

    // Loop through selectedOrder items to print each item
    int itemIndex = 1; // Initialize the index outside of the category loop for continuous increment

    for (var category in ['Cakes', 'Dishes', 'Drinks', 'Add On']) {
      // Get items for the current category
      var categoryItems = selectedOrder.items.where((item) => item.category == category).toList();
      
      // If there are items in this category, print the category header
      if (categoryItems.isNotEmpty) {
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: category,  // Category header
          align: LineText.ALIGN_LEFT,
          linefeed: 1
        ));

        for (var item in categoryItems) {
          // Determine the item name based on your condition
          String itemName;
          if (item.selection && item.selectedChoice != null) {
            itemName = item.originalName == item.selectedChoice!['name']
                ? item.originalName
                : '${item.originalName} ${item.selectedChoice!['name']}';
          } else if (item.selectedDrink != null && item.selectedTemp != null) {
            itemName = item.originalName == item.selectedDrink!['name']
                ? item.originalName
                : '${item.originalName} ${item.selectedDrink?['name']} (${item.selectedTemp?['name']})';
          } else {
            itemName = item.name;
          }

         
          String itemText = '$itemIndex.$itemName';
          String quantityText = item.quantity.toString();

          // Calculate total price (unit price * quantity)
          double totalPrice = item.price * item.quantity;
          String priceText = totalPrice.toStringAsFixed(2);  // Format the total price to 2 decimal places

          // Use the new function to print item text, quantity, and total price
          printItemWithQuantityAndPrice(
            itemText: itemText,
            quantity: quantityText,
            price: priceText,
            list: list,
            maxLength: 30  // Set your character limit here
          );
          // // Determine the relativeX position based on the totalQuantity's number of digits
          // int quantityXPosition = 340+40;  // Default for 2 digits
          // if (item.quantity.toString().length == 1) {
          //   quantityXPosition = 340+60;  // Adjust for 1 digit
          // } else if (item.quantity.toString().length == 3) {
          //   quantityXPosition = 340+30;  // Adjust for 3 digits
          // }
          
          // Add the quantity line
          list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '${item.quantity}', // Dynamic quantity
              x: calculatePriceXPosition(item.quantity, 340), // Adjust x based on your printer width for quantity
              linefeed: 0));
          
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: priceText,  // Dynamic price * quantity
            align: LineText.ALIGN_LEFT,
            x: calculatePriceXPosition(totalPrice, 460),
            linefeed: 1));

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
                content: '  - ${item.selectedMeatPortion!["name"]}',  // Print meat portion if not "Normal"
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
              content: '  - $remarks',  // Dynamic remarks with 'Remarks:' prefix
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
              firstLinePrefix: '  - ',  // Start the first line with "- "
              subsequentLinePrefix: '    '  // Start subsequent lines with two spaces
            );
          }
          // Increment the index for the next item across all categories
          itemIndex++;
        }
      }
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-----------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Subtotal',
        x: 340,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.subTotal.toStringAsFixed(2),
        x: calculatePriceXPosition(selectedOrder.subTotal, 460),
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total',
        // fontZoom: 2,
        weight: 1,
        x: 376,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.totalPrice.toStringAsFixed(2),
        // fontZoom: 2,
        weight: 1,
        x: calculatePriceXPosition(selectedOrder.totalPrice, 460),
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-----------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Amount Received (${selectedOrder.paymentMethod})',
        align: LineText.ALIGN_LEFT,
        x:0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.amountReceived.toStringAsFixed(2),
        align: LineText.ALIGN_LEFT,
        x: calculatePriceXPosition(selectedOrder.amountReceived, 460),
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Amount Change',
        align: LineText.ALIGN_LEFT,
        x:0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.amountChanged.toStringAsFixed(2),
        align: LineText.ALIGN_LEFT,
        x: calculatePriceXPosition(selectedOrder.amountChanged, 460),
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '*********** Thank You **********',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }
}