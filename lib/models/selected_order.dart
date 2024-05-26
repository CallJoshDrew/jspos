import 'package:flutter/widgets.dart';
import 'package:jspos/models/item.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class SelectedOrder with ChangeNotifier {
  String orderNumber;
  String tableName;
  String orderType;
  String? orderDate;
  String? orderTime;
  String status;
  List<Item> items;
  double subTotal;
  double serviceCharge;
  double totalPrice;
  int quantity;
  String paymentMethod;
  String remarks;
  bool showEditBtn;
  Map<String, int> itemCounts;
  Map<String, int> itemQuantities;
  int totalItems = 0;
  int totalQuantity = 0;
  Map<String, Map<String, int>> categories;

  // constructor must have the same name as its class.
  SelectedOrder({
    required this.orderNumber,
    required this.tableName,
    required this.orderType,
    required this.orderTime,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.subTotal,
    required this.serviceCharge,
    required this.totalPrice,
    required this.quantity,
    this.paymentMethod = "Cash",
    this.remarks = "No Remarks",
    this.showEditBtn = false,
    required this.itemCounts,
    required this.itemQuantities,
    this.totalItems = 0,
    this.totalQuantity = 0,
    required List<String> categoryList,
  }) : categories = {
          for (var category in categoryList) category: {'itemCount': 0, 'itemQuantity': 0}
        };
  @override
  // methods
  String toString() {
    return '{\n\torderNumber: $orderNumber, \n\ttableName: $tableName, \n\torderType: $orderType, \n\tstatus: $status, \n\titems: [\n\t\t${items.join(',\n\t\t')}\n\t], \n\tsubTotal: $subTotal, \n\tserviceCharge: $serviceCharge, \n\ttotalPrice: $totalPrice, \n\tquantity: $quantity, \n\tpaymentMethod: $paymentMethod, \n\tremarks: $remarks, \n\tshowEditBtn: $showEditBtn\n}';
  }

  SelectedOrder newInstance(List<String> categoryList) {
    return SelectedOrder(
      orderNumber: "Order Number",
      tableName: "Table Name",
      orderType: "Dine-In",
      orderTime: "Order Time",
      orderDate: "Order Date",
      status: "Start Your Order",
      items: [], // Add your items here
      subTotal: 0,
      serviceCharge: 0,
      totalPrice: 0,
      quantity: 0,
      paymentMethod: "Cash",
      remarks: "No Remarks",
      showEditBtn: false,
      itemCounts: {},
      itemQuantities: {},
      totalItems: 0,
      totalQuantity: 0,
      categoryList: categoryList,
    );
  }

  SelectedOrder copyWith(List<String> categoryList) {
    return SelectedOrder(
      orderNumber: orderNumber,
      tableName: tableName,
      orderType: orderType,
      orderTime: orderTime,
      orderDate: orderDate,
      status: status,
      items: List.from(items), // Create a copy of the items list
      subTotal: subTotal,
      serviceCharge: serviceCharge,
      totalPrice: totalPrice,
      quantity: quantity,
      paymentMethod: paymentMethod,
      remarks: remarks,
      showEditBtn: showEditBtn,
      itemCounts: itemCounts,
      itemQuantities: itemQuantities,
      totalItems: totalItems,
      totalQuantity: totalQuantity,
      categoryList: categoryList,
    );
  }

  void addItem(Item item) {
    // If the item.selection is true, change the name and price of the item
    if (item.selection) {
      if (item.selectedChoice != null) {
        item.name = item.selectedChoice!['name'];
        item.price = item.selectedChoice!['price'];
      }
      if (item.selectedType != null) {
        double typePrice = item.selectedType!['price'] ?? 0.00;
        if (typePrice > 0.00) {
          item.price += typePrice;
        }
      }
      if (item.selectedMeatPortion != null) {
        double meatPrice = item.selectedMeatPortion!['price'] ?? 0.00;
        if (meatPrice > 0.00) {
          item.price += meatPrice;
        }
      }
      if (item.selectedMeePortion != null) {
        double meePrice = item.selectedMeePortion!['price'] ?? 0.00;
        if (meePrice > 0.00) {
          item.price += meePrice;
        }
      }
      // Try to find an item in items with the same properties as the new item
      var existingItem = items.firstWhereOrNull((i) {
        // Use MapEquality().equals for deep equality check
        bool areRemarksEqual = const MapEquality().equals(i.itemRemarks, item.itemRemarks);

        return i.name == item.name &&
            i.selectedChoice?['name'] == item.selectedChoice?['name'] &&
            i.selectedType?['name'] == item.selectedType?['name'] &&
            i.selectedMeatPortion?['name'] == item.selectedMeatPortion?['name'] &&
            i.selectedMeePortion?['name'] == item.selectedMeePortion?['name'] &&
            areRemarksEqual; // Use the result of the deep equality check
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
    // print('Added Item: ${item}');
  }

  // solely for item in the orderDetails which has selection is true
  void updateItem(Item item) {
    // Find the index of the item with the same id
    int index = items.indexWhere((i) => i.id == item.id);

    // If the item is found, update it
    if (index != -1) {
      items[index] = item;
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
    updateTotalCost(0);
    // calculateItemsAndQuantities();
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

  void makePayment() {
    updateSubTotal();
    updateServiceCharge(0);
    updateTotalPrice();
    updateStatus('Paid');
  }

  void calculateItemsAndQuantities() {
    // Reset the counts and quantities for each category
    for (var category in categories.keys) {
      categories[category] = {'itemCount': 0, 'itemQuantity': 0};
    }

    // Iterate over each item in the items list
    for (var item in items) {
      // Check if the item's category exists in the categories map
      if (categories.containsKey(item.category)) {
        categories[item.category]?['itemCount'] = (categories[item.category]?['itemCount'] ?? 0) + 1;
        categories[item.category]?['itemQuantity'] = (categories[item.category]?['itemQuantity'] ?? 0) + (item.quantity);

        // Print the itemCount and itemQuantity for the category
        // print('Category: ${item.category}');
        // print('itemCount: ${categories[item.category]?['itemCount']}');
        // print('itemQuantity: ${categories[item.category]?['itemQuantity']}');
      }
    }
  }
}


  // Add the print statements here
  // print('Existing item remarks: ${i.itemRemarks}');
  // print('New item remarks: ${item.itemRemarks}');
  // print('Existing item remarks type: ${i.itemRemarks.runtimeType}');
  // print('New item remarks type: ${item.itemRemarks.runtimeType}');
