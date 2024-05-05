import 'package:jspos/shared/item.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class SelectedTableOrder {
  // Properties
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
  SelectedTableOrder({
    required this.orderNumber,
    required this.tableName,
    required this.orderType,
    this.orderTime,
    this.orderDate,
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
    return 'TableOrder: {\n\torderNumber: $orderNumber, \n\ttableName: $tableName, \n\torderType: $orderType, \n\tstatus: $status, \n\titems: [\n\t\t${items.join(',\n\t\t')}\n\t], \n\tsubTotal: $subTotal, \n\tserviceCharge: $serviceCharge, \n\ttotalPrice: $totalPrice, \n\tquantity: $quantity, \n\tpaymentMethod: $paymentMethod, \n\tremarks: $remarks, \n\tshowEditBtn: $showEditBtn\n}';
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
        double meatPrice = item.selectedMeatPortion!['price'] ??
            0.00; // Use 0.00 if selectedType.price is null
        if (meatPrice > 0.00) {
          // Only add meatPrice if it's greater than 0.00
          item.price += meatPrice;
        }
      }
      if (item.selectedMeePortion != null) {
        double meePrice = item.selectedMeePortion!['price'] ??
            0.00; // Use 0.00 if selectedType.price is null
        if (meePrice > 0.00) {
          // Only add meePrice if it's greater than 0.00
          item.price += meePrice;
        }
      }
    }

    // Try to find an item in items with the same id as the new item
    var existingItem = items.firstWhereOrNull((i) => i.id == item.id);
    if (existingItem != null) {
      // If an item with the same id is found, increase its quantity and price
      existingItem.quantity += 1;
      existingItem.price = (num.tryParse(
                  (existingItem.originalPrice * existingItem.quantity)
                      .toStringAsFixed(2)) ??
              0)
          .toDouble();
    } else {
      // If no item with the same id is found, add the new item
      items.add(item);
    }
  }

  void updateSubTotal() {
    subTotal =
        items.fold(0, (total, item) => total + item.price * item.quantity);
  }

  void updateServiceCharge(double rate) {
    serviceCharge = subTotal * rate;
  }

  void updateTotalPrice() {
    totalPrice = subTotal + serviceCharge;
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
    updateOrderDateTime();
  }

  void makePayment() {
    updateSubTotal();
    updateServiceCharge(0);
    updateTotalPrice();
    updateStatus('Paid');
  }
}
