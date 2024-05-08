import 'package:jspos/models/item.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class SelectedOrder {
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
  });
  @override
  // methods
  String toString() {
    return '{\n\torderNumber: $orderNumber, \n\ttableName: $tableName, \n\torderType: $orderType, \n\tstatus: $status, \n\titems: [\n\t\t${items.join(',\n\t\t')}\n\t], \n\tsubTotal: $subTotal, \n\tserviceCharge: $serviceCharge, \n\ttotalPrice: $totalPrice, \n\tquantity: $quantity, \n\tpaymentMethod: $paymentMethod, \n\tremarks: $remarks, \n\tshowEditBtn: $showEditBtn\n}';
  }

  void addItem(Item item) {
    // If the item.selection is true, change the name and price of the item
    if (item.selection) {
      if (item.selectedChoice != null) {
        item.name = item.selectedChoice!['name'];
        item.price = item.selectedChoice!['price'];
      }
      if (item.selectedType != null) {
        double typePrice = item.selectedType!['price'] ??
            0.00; // Use 0.00 if selectedType.price is null
        if (typePrice > 0.00) {
          // Only add typePrice if it's greater than 0.00
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
      var existingItem = items.firstWhereOrNull((i) =>
          i.name == item.name &&
          (i.selectedChoice != null ? i.selectedChoice!['name'] : null) ==
              (item.selectedChoice != null
                  ? item.selectedChoice!['name']
                  : null) &&
          (i.selectedType != null ? i.selectedType!['name'] : null) ==
              (item.selectedType != null ? item.selectedType!['name'] : null) &&
          (i.selectedMeatPortion != null
                  ? i.selectedMeatPortion!['name']
                  : null) ==
              (item.selectedMeatPortion != null
                  ? item.selectedMeatPortion!['name']
                  : null) &&
          (i.selectedMeePortion != null
                  ? i.selectedMeePortion!['name']
                  : null) ==
              (item.selectedMeePortion != null
                  ? item.selectedMeePortion!['name']
                  : null));
      if (existingItem != null) {
        // If an item with the same properties is found, increase its quantity and price
        existingItem.quantity += 1;
      } else {
        const uuid = Uuid();
        item.id = uuid.v4();
        items.add(item);
      }
    } else {
      // Try to find an item in items with the same id as the new item
      var existingItem = items.firstWhereOrNull((i) => i.id == item.id);
      if (existingItem != null) {
        existingItem.quantity += 1;
      } else {
        items.add(item);
      }
    }
  }

  void resetDefault() {
    orderNumber = "Order Number";
    tableName = "Table Name";
    status = "Start Your Order";
    items = [];
    orderTime = "Order Time";
    orderDate = "Order Date";
    updateTotalCost(0);
  }

  void updateSubTotal() {
    double total =
        items.fold(0, (total, item) => total + item.price * item.quantity);
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

  void placeOrder() {
    updateSubTotal();
    updateServiceCharge(0);
    updateTotalPrice();
    updateStatus('Placed Order');
    // tableName = "Table Name";
    // orderNumber = "Order Number";
    updateOrderDateTime();
  }

  void makePayment() {
    updateSubTotal();
    updateServiceCharge(0);
    updateTotalPrice();
    updateStatus('Paid');
  }
}
