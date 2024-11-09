import 'package:hive/hive.dart';
import 'package:jspos/models/selected_order.dart';

part 'orders.g.dart'; // Hive TypeAdapter

@HiveType(typeId: 1)
class Orders {
  @HiveField(0)
  final List<SelectedOrder> data;

  Orders({List<SelectedOrder>? data}) : data = data ?? [];

  @override
  String toString() {
    return 'Orders: { $data }';
  }
}

  
