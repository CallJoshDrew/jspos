// import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:jspos/models/item.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'selected_order.g.dart';

@HiveType(typeId: 1)
class SelectedOrder with ChangeNotifier {
  @HiveField(0)
  String orderNumber;
  @HiveField(1)
  String tableName;
  @HiveField(2)
  String orderType;
  @HiveField(3)
  String orderDate = "Today";
  @HiveField(4)
  String orderTime = "Now";
  @HiveField(5)
  String status;
  @HiveField(6)
  List<Item> items;
  @HiveField(7)
  double subTotal;
  @HiveField(8)
  double serviceCharge;
  @HiveField(9)
  double totalPrice;
  @HiveField(10)
  String paymentMethod;
  @HiveField(11)
  bool showEditBtn;
  @HiveField(12)
  Map<String, Map<String, int>> categories;
  @HiveField(13)
  double amountReceived = 0;
  @HiveField(14)
  double amountChanged = 0;
  @HiveField(15)
  double roundingAdjustment = 0;
  @HiveField(16)
  int totalQuantity = 0;
  @HiveField(17)
  String paymentTime = "Today";
  @HiveField(18)
  String cancelledTime = "Today";
  SelectedOrder({
    required this.orderNumber,
    required this.tableName,
    required this.orderType,
    required this.orderDate,
    required this.orderTime,
    required this.status,
    required this.items,
    required this.subTotal,
    required this.serviceCharge,
    required this.totalPrice,
    this.paymentMethod = "Cash",
    this.showEditBtn = false,
    required List<String> categoryList,
    this.amountReceived = 0,
    this.amountChanged = 0,
    this.roundingAdjustment = 0,
    this.totalQuantity = 0,
    this.paymentTime = "Today",
    this.cancelledTime = "Today",
  }) : categories = {
          for (var category in categoryList) category: {'itemCount': 0, 'itemQuantity': 0}
        };
  @override
  // methods
  String toString() {
    return 'SelectedOrder(\n'
        '\torderNumber: $orderNumber,\n'
        '\ttableName: $tableName,\n'
        '\torderType: $orderType,\n'
        '\torderDate: $orderDate,\n'
        '\torderTime: $orderTime,\n'
        '\tstatus: $status,\n'
        // temporary disable the items because it is too long in the log
        // '\titems: [\n\t\t${items.join(',\n\t\t')}\n\t],\n'
        //In this code, you're using the .join(',\n\t\t') method directly on the items list.
        // Issue: The .join() method works on a list of strings. However, items is a list of Item objects, not strings. Without a toString() method on the Item class, this won't work as expected. You would get a runtime error if the Item class doesn’t already have a proper toString() method defined.Our class item does have a proper toString. Just for info  and explaination.
        '\tsubTotal: $subTotal,\n'
        '\tserviceCharge: $serviceCharge,\n'
        '\ttotalPrice: $totalPrice,\n'
        '\tpaymentMethod: $paymentMethod,\n'
        '\tshowEditBtn: $showEditBtn,\n'
        '\tamountReceived: $amountReceived,\n'
        '\tamountChanged: $amountChanged,\n'
        '\troundingAdjustment: $roundingAdjustment\n'
        '\ttotalQuantity: $totalQuantity,\n'
        '\tpaymentTime: $paymentTime,\n'
        '\tcancelledTime: $cancelledTime,\n'
        '\tcategories: {\n\t\t${categories.entries.map((e) => '${e.key}: ${e.value}').join(',\n\t\t')}\n\t},\n'
        ')';
  }

  SelectedOrder newInstance(List<String> categoryList) {
    return SelectedOrder(
      orderNumber: "Order Number",
      tableName: "Table Name",
      orderType: "Dine-In",
      orderDate: "Order Date",
      orderTime: "Order Time",
      status: "Start Your Order",
      items: [], // Add your items here
      subTotal: 0,
      serviceCharge: 0,
      totalPrice: 0,
      paymentMethod: "Cash",
      showEditBtn: false,
      categoryList: categoryList,
      amountReceived: 0,
      amountChanged: 0,
      roundingAdjustment: 0,
      totalQuantity: 0,
      paymentTime: "Payment Time",
      cancelledTime: "Cancelled Time",
    );
  }

  SelectedOrder copyWith(List<String> categoryList) {
    return SelectedOrder(
      orderNumber: orderNumber,
      tableName: tableName,
      orderType: orderType,
      orderDate: orderDate,
      orderTime: orderTime,
      status: status,
      items: List.from(items), // Create a copy of the items list
      subTotal: subTotal,
      serviceCharge: serviceCharge,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
      showEditBtn: showEditBtn,
      categoryList: categoryList,
      amountReceived: amountReceived,
      amountChanged: amountChanged,
      roundingAdjustment: roundingAdjustment,
      totalQuantity: totalQuantity,
      paymentTime: paymentTime,
      cancelledTime: cancelledTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'tableName': tableName,
      'orderType': orderType,
      'orderDate': orderDate,
      'orderTime': orderTime,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(), // Convert each item to JSON
      'subTotal': subTotal,
      'serviceCharge': serviceCharge,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'amountReceived': amountReceived,
      'amountChanged': amountChanged,
      'roundingAdjustment': roundingAdjustment,
      'totalQuantity': totalQuantity,
      'paymentTime': paymentTime,
      'cancelledTime': cancelledTime,
    };
  }

  void addItem(Item item) {
    // If the item.selection is true, change the name and price of the item
    if (item.selection) {
      // if (item.selectedChoice != null) {
      //   item.name = item.selectedChoice!['name'];
      //   item.price = item.selectedChoice!['price'];
      // }
      // Try to find an item in items with the same properties as the new item
      var existingItem = items.firstWhereOrNull((i) {
        // Use MapEquality().equals for deep equality check
        bool areRemarksEqual = const MapEquality().equals(i.itemRemarks, item.itemRemarks);

        // Create a SetEquality with a MapEquality to compare sets of maps
        bool areAddOnsEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedAddOn, item.selectedAddOn);

        return i.name == item.name &&
            i.selectedDrink?['name'] == item.selectedDrink?['name'] &&
            i.selectedTemp?['name'] == item.selectedTemp?['name'] &&
            i.selectedChoice?['name'] == item.selectedChoice?['name'] &&
            i.selectedNoodlesType?['name'] == item.selectedNoodlesType?['name'] &&
            i.selectedMeatPortion?['name'] == item.selectedMeatPortion?['name'] &&
            i.selectedMeePortion?['name'] == item.selectedMeePortion?['name'] &&
            areRemarksEqual && // Use the result of the deep equality check
            areAddOnsEqual; // Check if the selectedAddOn sets are equal
      });

      if (existingItem != null) {
        // If an item with the same properties is found, increase its quantity
        existingItem.quantity += 1;
      } else {
        const uuid = Uuid();
        item.id = uuid.v4();
        items.add(item);
      }
    } else {
      // item selection is false
      // Try to find an item in items with the same id as the new item
      var existingItem = items.firstWhereOrNull((i) => i.name == item.name);
      if (existingItem != null) {
        existingItem.quantity += 1;
      } else {
        items.add(item);
      }
    }
    calculateItemsAndQuantities();
    notifyListeners();
  }

  // solely for item in the orderDetails which has selection is true
  void updateItem(Item item) {
    // Try to find an item in items with the same properties as the new item
    var existingItem = items.firstWhereOrNull((i) {
      // Use MapEquality().equals for deep equality check
      bool areRemarksEqual = const MapEquality().equals(i.itemRemarks, item.itemRemarks);

      // Create a SetEquality with a MapEquality to compare sets of maps
      bool areAddOnsEqual = const SetEquality<Map<String, dynamic>>(MapEquality()).equals(i.selectedAddOn, item.selectedAddOn);
      return i.id == item.id &&
          i.name == item.name &&
          i.selectedChoice?['name'] == item.selectedChoice?['name'] &&
          i.selectedNoodlesType?['name'] == item.selectedNoodlesType?['name'] &&
          i.selectedMeatPortion?['name'] == item.selectedMeatPortion?['name'] &&
          i.selectedMeePortion?['name'] == item.selectedMeePortion?['name'] &&
          areRemarksEqual && // Use the result of the deep equality check
          areAddOnsEqual; // Check if the selectedAddOn sets are equal
    });

    if (existingItem != null) {
      // If an item with the same properties is found, update it
      existingItem = item;
    } else {
      // If the item is not found, add it to the list
      items.add(item);
    }

    calculateItemsAndQuantities();
    notifyListeners();
  }

  void resetDefault() {
    orderNumber = "Order Number";
    tableName = "Table Name";
    status = "Start Your Order";
    items = [];
    orderTime = "Order Time";
    orderDate = "Order Date";
    subTotal = 0;
    serviceCharge = 0;
    totalPrice = 0;
    paymentMethod = "Cash";
    showEditBtn = false;
    categories = categories;
    amountReceived = 0;
    amountChanged = 0;
    roundingAdjustment = 0;
    totalQuantity = 0;
    paymentTime = "Today";
  }

  void handleCancelOrder() {
    status = "Cancelled";
    paymentMethod = "None";
    paymentTime = "None";
    showEditBtn = true;
  }

  void updateSubTotal() {
    double total = items.fold(0, (total, item) => total + item.price * item.quantity);
    subTotal = double.parse(total.toStringAsFixed(2));
  }

  void updateServiceCharge(double rate) {
    double charge = subTotal * rate;
    serviceCharge = double.parse(charge.toStringAsFixed(2));
  }

  void updateTotalPrice() {
    double total = subTotal + serviceCharge;
    totalPrice = double.parse(total.toStringAsFixed(2));
  }

  void updateTotalCost(double serviceChargeRate) {
    updateSubTotal();
    updateServiceCharge(serviceChargeRate);
    updateTotalPrice();
  }

  void updateStatus(String newStatus) {
    status = newStatus;
  }

  void updateOrderDateTime() {
    DateTime now = DateTime.now();
    orderDate = DateFormat('d MMMM yyyy').format(now); // Outputs: 5 May 2024
    orderTime = DateFormat('h:mm a').format(now); // Outputs: 1:03 AM
  }

  void addPaymentDateTime() {
    DateTime now = DateTime.now();
    paymentTime = DateFormat('h:mm a, d MMMM yyyy').format(now); // Outputs: 1:03 AM, 5 May 2024
  }

  void addCancelDateTime() {
    DateTime now = DateTime.now();
    cancelledTime = DateFormat('h:mm a, d MMMM yyyy').format(now); // Outputs: 1:03 AM, 5 May 2024
  }

  void updateShowEditBtn(bool editBtn) {
    showEditBtn = editBtn;
  }

  void placeOrder() {
    updateSubTotal();
    updateServiceCharge(0);
    updateTotalPrice();
    updateStatus('Placed Order');
    updateShowEditBtn(true);
    updateOrderDateTime();
  }

  void calculateItemsAndQuantities() {
    // Reset the counts and quantities for each category
    for (var category in categories.keys) {
      categories[category] = {'itemCount': 0, 'itemQuantity': 0};
    }
    // Reset totalQuantity
    totalQuantity = 0;
    for (var item in items) {
      // Check if the item's category exists in the categories map
      if (categories.containsKey(item.category)) {
        categories[item.category]?['itemCount'] = (categories[item.category]?['itemCount'] ?? 0) + 1;
        categories[item.category]?['itemQuantity'] = (categories[item.category]?['itemQuantity'] ?? 0) + (item.quantity);
        totalQuantity += item.quantity;
      }
    }
    // log('Total Quantity: $totalQuantity');
  }
}



// if (item.selectedType != null) {
//   double typePrice = item.selectedType!['price'] ?? 0.00;
//   if (typePrice > 0.00) {
//     item.price += typePrice;
//   }
// }
// if (item.selectedMeatPortion != null) {
//   double meatPrice = item.selectedMeatPortion!['price'] ?? 0.00;
//   if (meatPrice > 0.00) {
//     item.price += meatPrice;
//   }
// }
// if (item.selectedMeePortion != null) {
//   double meePrice = item.selectedMeePortion!['price'] ?? 0.00;
//   if (meePrice > 0.00) {
//     item.price += meePrice;
//   }
// }
// if (item.selectedAddOn != null) {
//   for (var addOn in item.selectedAddOn!) {
//     double addOnPrice = addOn['price'] ?? 0.00;
//     if (addOnPrice > 0.00) {
// item.price += addOnPrice;
//     }
//   }
// }

// quantity: 0,
// remarks: "No Remarks",
// itemCounts: {},
// itemQuantities: {},
// totalItems: 0,

// quantity: quantity,
// remarks: remarks,
// itemCounts: itemCounts,
// itemQuantities: itemQuantities,
// totalItems: totalItems,

// void makePayment() {
//   updateSubTotal();
//   updateServiceCharge(0);
//   updateTotalPrice();
//   updateStatus('Paid');
// }

// void makePayment(double amountReceived, double amountChanged, double roundingAdjustment, String selectedPaymentMethod) {
//   updateSubTotal();
//   updateServiceCharge(0);
//   totalPrice = amountReceived - amountChanged;
//   amountReceived = amountReceived;
//   amountChanged = amountChanged;
//   roundingAdjustment = roundingAdjustment;
//   paymentMethod = selectedPaymentMethod;
//   updateStatus("Paid");
//   print('totalPrice: $totalPrice');
//   print('amountReceived: $amountReceived');
//   print('amountChanged: $amountChanged');
//   print('roundingAdjustment: $roundingAdjustment');
//   print('status: $status');
//   print('paymentMethod: $paymentMethod');
// }

// Print the itemCount and itemQuantity for the category
// print('Category: ${item.category}');
// print('itemCount: ${categories[item.category]?['itemCount']}');
// print('itemQuantity: ${categories[item.category]?['itemQuantity']}');

// Add the print statements here
// print('Existing item remarks: ${i.itemRemarks}');
// print('New item remarks: ${item.itemRemarks}');
// print('Existing item remarks type: ${i.itemRemarks.runtimeType}');
// print('New item remarks type: ${item.itemRemarks.runtimeType}');
