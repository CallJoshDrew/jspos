import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/selected_order.dart';

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
    list.add(LineText(linefeed: 1));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Date: ${selectedOrder.orderDate}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Time: ${selectedOrder.orderTime}',
      align: LineText.ALIGN_LEFT,
      x: 380,
      relativeX: 0,
      linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice: ${selectedOrder.orderNumber}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Type: ${selectedOrder.orderType}',
      align: LineText.ALIGN_LEFT,
      x: 380,
      relativeX: 0,
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
      relativeX: 0,
      linefeed: 0));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Qyt',
      align: LineText.ALIGN_LEFT,
      x: 390, 
      relativeX: 0,
      linefeed: 0));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Amt(RM)',
      align: LineText.ALIGN_LEFT,
      x: 470,
      relativeX: 0,
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

          // Add the item with the index number
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '$itemIndex.$itemName',  // Add the item index before the item name
            align: LineText.ALIGN_LEFT,
            x: 0,
            relativeX: 0,
            linefeed: 0));

          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: '${item.quantity}',  // Dynamic quantity
            align: LineText.ALIGN_LEFT,
            x: 400,  // Adjust x based on your printer width for quantity
            relativeX: 0,
            linefeed: 0));

          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: item.price.toStringAsFixed(2),  // Dynamic price
            align: LineText.ALIGN_LEFT,
            x: 480,  // Adjust x based on your printer width for price
            relativeX: 0,
            linefeed: 1));

          // Check and add remarks to the receipt
          if (item.selection && filterRemarks(item.itemRemarks).isNotEmpty) {
            String remarks = getFilteredRemarks(item.itemRemarks);
            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '- $remarks',  // Dynamic remarks with 'Remarks:' prefix
              align: LineText.ALIGN_LEFT,
              x: 0,
              relativeX: 0,
              linefeed: 1));
          }
           // Check and add selected add-ons to the receipt
        if (item.selection && item.selectedAddOn != null && item.selectedAddOn!.isNotEmpty) {
          for (var addOn in item.selectedAddOn!) {
            // Print each add-on with its name and optional price
            String addOnText = addOn['price'] != null
                ? '${addOn['name']} (+${addOn['price'].toStringAsFixed(2)})'
                : addOn['name'];

            list.add(LineText(
              type: LineText.TYPE_TEXT,
              content: '- $addOnText',  // Add-on details
              align: LineText.ALIGN_LEFT,
              x: 0,
              relativeX: 0,
              linefeed: 1));
          }
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
        x: 350,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.subTotal.toStringAsFixed(2),
        x: 480,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total',
        // fontZoom: 2,
        weight: 1,
        x: 386,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.totalPrice.toStringAsFixed(2),
        // fontZoom: 2,
        weight: 1,
        x: 480,
        relativeX: 0,
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
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: selectedOrder.amountReceived.toStringAsFixed(2),
        align: LineText.ALIGN_LEFT,
        x: 480,
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
        x: 480,
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
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }
}