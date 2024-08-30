import 'package:hive/hive.dart';

part 'printer.g.dart';

@HiveType(typeId: 3)
class Printer extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String macAddress;

  @HiveField(2)
  bool isConnected;

  Printer({
    required this.name,
    required this.macAddress,
    required this.isConnected,
  });

  @override
  String toString() {
    return 'Printer(name: $name, macAddress: $macAddress, isConnected: $isConnected)';
  }
}