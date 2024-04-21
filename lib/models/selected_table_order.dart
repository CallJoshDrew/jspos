
class Item {
  final String name;
  final int quantity;
  final double price;
  final String image;
  Item({required this.name, required this.quantity, required this.price, required this.image});
  @override
  String toString() {
    return 'Item: {name: $name, price: $price, quantity: $quantity, image: $image}';
  }
}
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
    required this.paymentMethod,
    this.remarks = "No Remarks",
    this.showEditBtn = false,
  });
  @override
  // methods
  String toString() {
    return 'TableOrder: {orderNumber: $orderNumber, tableName: $tableName, orderType: $orderType, status: $status, items: $items, subTotal: $subTotal, serviceCharge: $serviceCharge, totalPrice: $totalPrice, quantity: $quantity, paymentMethod: $paymentMethod, remarks: $remarks, showEditBtn: $showEditBtn}';
  }
  void addItem(Item item) {
    items.add(item);
  }
}

