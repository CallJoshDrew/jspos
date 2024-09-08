import 'package:bluetooth_print/bluetooth_print_model.dart';

// printer width is 58mm for Kitchen
List<LineText> getSampleReceiptLines() {
  List<LineText> list = [];

  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Restaurant Sing Ming Hing', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Lot 16, Block B, Utara Place 1, Jalan Utara,',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      fontZoom: 2,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'IJM Batu 6, Sandakan, Sandakan, Malaysia',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      fontZoom: 2,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Invoice 100001',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      fontZoom: 2,
      linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(
      LineText(type: LineText.TYPE_TEXT, content: '--------------------Details---------------------', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));

  // Headers for Items, Quantity, and Amount
  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Items', weight: 0, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0,linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Qty', weight: 0, align: LineText.ALIGN_CENTER, x: 350, relativeX: 0, linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Amount(RM)', weight: 0, align: LineText.ALIGN_RIGHT, x: 450, relativeX: 0,  linefeed: 0));

  list.add(LineText(linefeed: 1));

  // Adding "Nasi Goreng" with Quantity and Amount
  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Nasi Goreng Ayam Campur', weight: 0, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0,  linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '1', weight: 0, align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '10.00', weight: 0, align: LineText.ALIGN_LEFT, x: 450, relativeX: 0,linefeed: 0));

  list.add(LineText(linefeed: 1));
  list.add(LineText(type: LineText.TYPE_TEXT, content: 'Nasi Kuey Tiaw', weight: 0, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '2', weight: 0, align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
  list.add(LineText(type: LineText.TYPE_TEXT, content: '20.00', weight: 0, align: LineText.ALIGN_LEFT, x: 450, relativeX: 0, linefeed: 0));

  
  list.add(LineText(linefeed: 1));
  list.add(
      LineText(type: LineText.TYPE_TEXT, content: '----------------------End-----------------------', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
  // list.add(LineText(linefeed: 1));
  // list.add(LineText(type: LineText.TYPE_BARCODE, content: 'A12312112', size: 10, align: LineText.ALIGN_CENTER, linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(type: LineText.TYPE_QRCODE, content: 'qrcode i', size: 10, align: LineText.ALIGN_CENTER, x: 0, relativeX: 0,  linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));
  list.add(LineText(linefeed: 1));
  return list;
}

	// linefeed: 1: Moves the print head down by one line after printing the current line. This will result in the standard spacing between lines.
	// linefeed: 0: No line feed; the print head stays on the same line after printing the current content. This is useful if you want to print multiple items on the same line without moving to the next line.
	// linefeed: 2 or more: Moves the print head down by two or more lines. This increases the space between the current line and the next line, creating more vertical separation.
