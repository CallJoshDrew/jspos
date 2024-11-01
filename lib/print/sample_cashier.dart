import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:jspos/models/client_profile.dart';

// if printer width is 58mm then use linelength 32, if it is 80mm then use linelength 48
String formatItemLine(String itemName, int quantity) {
  const int lineLength = 48;
  String quantityStr = quantity.toString();

  // Calculate remaining space for itemName by subtracting the quantity and space between them
  int spaces = lineLength - itemName.length - quantityStr.length;

  // Ensure spaces are non-negative
  if (spaces < 1) spaces = 1;

  return itemName + ' ' * spaces + quantityStr;
}

String formatTextLine(String text1, String text2) {
  const int lineLength = 48;
  String quantityStr = text2.toString();

  // Calculate remaining space for itemName by subtracting the quantity and space between them
  int spaces = lineLength - text1.length - quantityStr.length;

  // Ensure spaces are non-negative
  if (spaces < 1) spaces = 1;

  return text1 + ' ' * spaces + quantityStr;
}

List<LineText> getSampleCashierLines(ClientProfile profile) {
  List<LineText> list = [];

  list.add(LineText(type: LineText.TYPE_TEXT, content: 'JACKPOT 1288!!!', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '------------------------------------------------', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 1, linefeed: 1));

  // Headers for Items and Quantity (aligned to fit within 32 characters)
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: formatTextLine('No.Item ', 'Qty'),
    align: LineText.ALIGN_LEFT,
    linefeed: 1,
    fontZoom: 1,
  ));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '------------------------------------------------', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 1, linefeed: 1));

  // Use the helper function to format items
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: formatItemLine('1.Gong Xi Fa Cai', 888),
    align: LineText.ALIGN_LEFT,
    fontZoom: 1,
    linefeed: 1,
  ));

  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: formatItemLine('2.Prosperity & Joy Today', 999),
    align: LineText.ALIGN_LEFT,
    fontZoom: 1,
    linefeed: 1,
  ));

  // Footer for the details section
  list.add(LineText(type: LineText.TYPE_TEXT, content: '------------------------------------------------', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 1, linefeed: 1));
  list.add(LineText(
    type: LineText.TYPE_TEXT,
    content: 'Total 1,887',
    align: LineText.ALIGN_RIGHT,
    fontZoom: 1,
    linefeed: 1,
  ));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '------------', weight: 1, align: LineText.ALIGN_RIGHT, fontZoom: 1, linefeed: 1));
  list.add(LineText(linefeed: 1));

  return list;
}
  // list.add(LineText(type: LineText.TYPE_BARCODE, content: 'A12312112', size: 10, align: LineText.ALIGN_CENTER, linefeed: 1));
  // list.add(LineText(type: LineText.TYPE_QRCODE, content: 'qrcode i', size: 10, align: LineText.ALIGN_CENTER, x: 0, relativeX: 0,  linefeed: 1));

	// linefeed: 1: Moves the print head down by one line after printing the current line. This will result in the standard spacing between lines.
	// linefeed: 0: No line feed; the print head stays on the same line after printing the current content. This is useful if you want to print multiple items on the same line without moving to the next line.
	// linefeed: 2 or more: Moves the print head down by two or more lines. This increases the space between the current line and the next line, creating more vertical separation.
