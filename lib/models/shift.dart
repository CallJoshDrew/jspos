import 'package:hive/hive.dart';

part 'shift.g.dart'; // Run build_runner to generate the Hive adapter.

@HiveType(typeId: 7) // Assign a unique typeId for the Shift model
class Shift extends HiveObject {
  @HiveField(0)
  String id; // UUID for future Supabase integration

  @HiveField(1)
  String userId; // Link to the user's ID

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  double cashStartAmount;

  @HiveField(5)
  double? cashEndAmount;

  @HiveField(6)
  double? totalSales;

  @HiveField(7)
  String status; // Active, closed, etc.

  @HiveField(8)
  String? deviceId; // Terminal identifier

  Shift({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.cashStartAmount,
    this.cashEndAmount,
    this.totalSales,
    required this.status,
    this.deviceId,
  });
}
