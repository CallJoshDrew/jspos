import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jspos/app/jpos.dart';
import 'package:jspos/hive/hive_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeHive();
    final categories = await setupCategories();
    runApp(ProviderScope(child: JPOSApp(categories: categories)));
  } catch (e) {
    log('An error occurred at Main App: $e');
  }
}

/// Reads the categories from Hive and ensures they are initialized
Future<List<String>> setupCategories() async {
  var categoriesBox = Hive.box('categories');
  String? categoriesString = categoriesBox.get('categories');
  return categoriesString?.split(',') ?? [];
}



// Main color green
// const Color.fromRGBO(46, 125, 50, 1)
// Second Color
// Colors.deepOrangeAccent
// Nice Color Blue
// Colors.blueGrey
// Black Color
// const Color(0xff1f2029),
// Grey
// Colors.grey



  // await Hive.openBox('selectedOrder'); // why this got issues if openBox here? some of the fields are null it said.
  // however due to the design, selectedOrder is never to be openBox here because there will be another selecetedOrder for tapao
  // var tablesData = (tablesBox.get('tables') as List).map((item) => Map<String, dynamic>.from(item)).toList();
  // log('Tables: $tablesData');


  