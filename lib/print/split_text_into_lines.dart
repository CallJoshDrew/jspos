// Define a reusable function for splitting text into multiple lines based on a max length
import 'package:bluetooth_print/bluetooth_print_model.dart';

// Function to split long text into multiple lines based on the max characters per line
List<String> splitTextIntoLines(String text, int maxLength) {
  List<String> lines = [];
  
  // Split text into chunks of maxLength
  while (text.length > maxLength) {
    int splitIndex = text.lastIndexOf(' ', maxLength);  // Find last space within the limit
    if (splitIndex == -1) splitIndex = maxLength;  // If no space, split at maxLength
    lines.add(text.substring(0, splitIndex).trim());  // Add trimmed line
    text = text.substring(splitIndex).trim();  // Move to the next part
  }

  // Add the remaining text
  if (text.isNotEmpty) {
    lines.add(text);
  }

  return lines;
}

// Define a function to add lines with dynamic content and prefixes
void addFormattedLines({
  required String text, 
  required List<LineText> list, 
  required int maxLength, 
  String firstLinePrefix = '', 
  String subsequentLinePrefix = '  '  // Two spaces by default for subsequent lines
}) {
  // Split the text into lines based on the character limit
  List<String> lines = splitTextIntoLines(text, maxLength);

  // Add each line to the list
  for (int i = 0; i < lines.length; i++) {
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: (i == 0 ? firstLinePrefix : subsequentLinePrefix) + lines[i],  // Add prefix based on line position
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 1
    ));
  }
}

// Function to handle printing item with name, quantity, and price
void printItemWithQuantityAndPrice({
  required String itemText,
  required String quantity,
  required String price,
  required List<LineText> list,
  required int maxLength,
}) {
  // Split the item text if it exceeds maxLength
  List<String> lines = splitTextIntoLines(itemText, maxLength);

  // Add the first line with item text, quantity, and price
  if (lines.isNotEmpty) {
    // The first line includes item text, quantity, and price
    String firstLine = lines[0].padRight(maxLength);
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: firstLine,
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0,
    ));
  }

  // Add remaining lines for long item names, without quantity and price
  for (int i = 1; i < lines.length; i++) {
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '  ${lines[i]}',  // Add spaces for indentation
      align: LineText.ALIGN_LEFT,
      x: 0,
      relativeX: 0,
      linefeed: 0,
    ));
  }
}