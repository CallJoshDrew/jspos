import 'package:jspos/shared/item.dart';

class SelectedTableOrder {
  // Properties 
  String orderNumber;
  String tableName;
  String orderType;
  DateTime? orderTime;
  DateTime? orderDate;
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
    items.add(item);
  }
}

