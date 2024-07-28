
// import 'package:flutter/services.dart';
// import 'dart:convert';

// class PrintService {
//   static Future<void> printReceipt(BluetoothPrint bluetoothPrint, bool printersConnected) async {
//     if (printersConnected) {
//       Map<String, dynamic> config = {};

//       List<LineText> list = [];
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '******************************', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '打印单据头', weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));
//       list.add(LineText(linefeed: 1));

//       list.add(LineText(type: LineText.TYPE_TEXT, content: '-------------明细------------', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '物资名称规格型号', weight: 1, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 0));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '单位', weight: 1, align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '数量', weight: 1, align: LineText.ALIGN_LEFT, x: 500, relativeX: 0, linefeed: 1));

//       list.add(LineText(type: LineText.TYPE_TEXT, content: '混凝土C30', align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 0));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '吨', align: LineText.ALIGN_LEFT, x: 350, relativeX: 0, linefeed: 0));
//       list.add(LineText(type: LineText.TYPE_TEXT, content: '12.0', align: LineText.ALIGN_LEFT, x: 500, relativeX: 0, linefeed: 1));

//       list.add(LineText(type: LineText.TYPE_TEXT, content: '******************************', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
//       list.add(LineText(linefeed: 1));

//       await bluetoothPrint.printReceipt(config, list);
//     }
//   }
// }
