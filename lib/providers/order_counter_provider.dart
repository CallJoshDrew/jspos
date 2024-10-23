import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

// StateNotifier to manage the order counter value
class OrderCounterNotifier extends StateNotifier<int> {
  final Box _counterBox;

  OrderCounterNotifier(this._counterBox) : super(1) {
    _initializeOrderCounter();
  }

  // Load or initialize the order counter
  Future<void> _initializeOrderCounter() async {
    try {
      int counter = _counterBox.get('orderCounter', defaultValue: 1);
      state = counter;
      log('Initialized orderCounter: $state');
    } catch (e) {
      log('Error initializing orderCounter: $e');
    }
  }

  // Update the counter and save to Hive
  Future<void> updateOrderCounter(int newCounter) async {
    state = newCounter;
    await _counterBox.put('orderCounter', newCounter);
    log('Updated orderCounter: $newCounter');
  }
}

// Provider to expose the OrderCounterNotifier
final orderCounterProvider =
    StateNotifierProvider<OrderCounterNotifier, int>((ref) {
  final box = Hive.box('orderCounter');
  return OrderCounterNotifier(box);
});
