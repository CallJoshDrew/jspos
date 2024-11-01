import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:hive/hive.dart';

part 'printer.g.dart';

@HiveType(typeId: 4)
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


// Model Printer MPT-11, Printing width: 48mm, Paper Width: 57.5 +-0.5mm So basically 58mm
// Charaters Printing Per line: ANK: 48, 42, 32; GBK: 24, 16
// ANK stands for “Alphanumeric Katakana,” a character set that includes standard Latin letters, numbers, symbols, and some Katakana characters.
// 48 characters per line is typically for a smaller font.
// 42 characters per line would be for a medium-sized font.
// 32 characters per line is for a larger font, which takes up more space.

// GBK is a character encoding commonly used for Chinese characters (Hanzi) and is also applicable to some other East Asian languages.
// 24 characters per line for a smaller font.
// 16 characters per line for a larger font.

// Printing Characters: 8x16, 9x17, 9x24, 12x24; GBK:24x24
// Printing Character Sizes (8x16, 9x17, 9x24, 12x24):
// These sizes represent the width x height of each printed character in pixels.
// 8x16: Each character is 8 pixels wide and 16 pixels tall.
// 9x17: Each character is 9 pixels wide and 17 pixels tall.
// 9x24: Each character is 9 pixels wide and 24 pixels tall.
// 12x24: Each character is 12 pixels wide and 24 pixels tall.
// These sizes affect readability and how much text fits on a line. For example, 8x16 will fit more characters per line than 12x24, which will have larger text but take up more space.

// GBK: 24x24:
// GBK refers to the Chinese GBK encoding (a commonly used encoding standard for simplified Chinese characters).
// 24x24 specifies the character size for Chinese characters when using GBK encoding, meaning each Chinese character is 24 pixels wide and 24 pixels tall.

// Model Printer RPP02N Printing width: 72mm, Paper Width: 80mm