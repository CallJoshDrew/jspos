// import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:jspos/models/item.dart';
// import 'package:intl/intl.dart';
// import 'package:collection/collection.dart';
// import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'selected_order.g.dart';

@HiveType(typeId: 2)
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
  double totalPrice;
  @HiveField(9)
  String paymentMethod;
  @HiveField(10)
  bool showEditBtn;
  @HiveField(11)
  Map<String, Map<String, int>> categories;
  @HiveField(12)
  double amountReceived = 0;
  @HiveField(13)
  double amountChanged = 0;
  @HiveField(14)
  int totalQuantity = 0;
  @HiveField(15)
  String paymentTime = "Today";
  @HiveField(16)
  String cancelledTime = "Today";
  @HiveField(17)
  List<String> categoryList;
  @HiveField(18)
  int discount = 0; // Default to 0% discount

  SelectedOrder({
    required this.orderNumber,
    required this.tableName,
    required this.orderType,
    required this.orderDate,
    required this.orderTime,
    required this.status,
    required this.items,
    required this.subTotal,
    required this.totalPrice,
    this.paymentMethod = "Cash",
    this.showEditBtn = false,
    required this.categoryList,  // Modify constructor to accept categoryList
    this.amountReceived = 0,
    this.amountChanged = 0,
    this.totalQuantity = 0,
    this.paymentTime = "Today",
    this.cancelledTime = "Today",
    this.discount = 0,
  }) : categories = {
          for (var category in categoryList) category: {'itemCount': 0, 'itemQuantity': 0}
        };

  @override
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
        '\ttotalPrice: $totalPrice,\n'
        '\tpaymentMethod: $paymentMethod,\n'
        '\tshowEditBtn: $showEditBtn,\n'
        '\tamountReceived: $amountReceived,\n'
        '\tamountChanged: $amountChanged,\n'
        '\ttotalQuantity: $totalQuantity,\n'
        '\tpaymentTime: $paymentTime,\n'
        '\tcancelledTime: $cancelledTime,\n'
        '\tdiscount: $discount,\n'
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
      items: [],
      subTotal: 0,
      totalPrice: 0,
      paymentMethod: "Cash",
      showEditBtn: false,
      categoryList: categoryList,
      amountReceived: 0,
      amountChanged: 0,
      totalQuantity: 0,
      paymentTime: "Payment Time",
      cancelledTime: "Cancelled Time",
      discount: 0,
    );
  }

  SelectedOrder copyWith({
    String? orderNumber,
    String? tableName,
    String? orderType,
    String? orderDate,
    String? orderTime,
    String? status,
    List<Item>? items,
    double? subTotal,
    double? totalPrice,
    String? paymentMethod,
    bool? showEditBtn,
    Map<String, Map<String, int>>? categories,
    double? amountReceived,
    double? amountChanged,
    int? totalQuantity,
    String? paymentTime,
    String? cancelledTime,
    List<String>? categoryList,
    int? discount,
  }) {
    return SelectedOrder(
      orderNumber: orderNumber ?? this.orderNumber,
      tableName: tableName ?? this.tableName,
      orderType: orderType ?? this.orderType,
      orderDate: orderDate ?? this.orderDate,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      items: items ?? List.from(this.items),
      subTotal: subTotal ?? this.subTotal,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      showEditBtn: showEditBtn ?? this.showEditBtn,
      categoryList: categoryList ?? this.categoryList,
      amountReceived: amountReceived ?? this.amountReceived,
      amountChanged: amountChanged ?? this.amountChanged,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      paymentTime: paymentTime ?? this.paymentTime,
      cancelledTime: cancelledTime ?? this.cancelledTime,
      discount: discount ?? this.discount,
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
      'items': items.map((item) => item.toJson()).toList(),  // Convert each item to JSON
      'subTotal': subTotal,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'amountReceived': amountReceived,
      'amountChanged': amountChanged,
      'totalQuantity': totalQuantity,
      'paymentTime': paymentTime,
      'cancelledTime': cancelledTime,
      'discount': discount,
      'categories': categories,
      'categoryList': categoryList,
    };
  }
}