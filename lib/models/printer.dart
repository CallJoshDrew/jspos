import 'package:bluetooth_print/bluetooth_print.dart';
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

  @HiveField(3)
  String assignedArea;

  @HiveField(4)
  String paperWidth;

  @HiveField(5)
  String interface;

  // Non-persistent field
  BluetoothPrint? bluetoothInstance;

  Printer({
    required this.name,
    required this.macAddress,
    required this.isConnected,
    required this.assignedArea,
    required this.paperWidth,
    required this.interface,
    this.bluetoothInstance,
  });

  Printer copyWith({
    String? name,
    String? macAddress,
    bool? isConnected,
    String? assignedArea,
    String? paperWidth,
    String? interface,
    BluetoothPrint? bluetoothInstance,
  }) {
    return Printer(
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      isConnected: isConnected ?? this.isConnected,
      assignedArea: assignedArea ?? this.assignedArea,
      paperWidth: paperWidth ?? this.paperWidth,
      interface: interface ?? this.interface,
      bluetoothInstance: bluetoothInstance ?? this.bluetoothInstance,
    );
  }

  @override
  String toString() {
    return 'Printer(name: $name, macAddress: $macAddress, isConnected: $isConnected, assignedArea: $assignedArea, paperWidth: $paperWidth, interface: $interface)';
  }
}
