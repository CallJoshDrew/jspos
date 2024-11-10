import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

// StateNotifier to manage the order counter value
// OrderCounterNotifier with increment and decrement logic
class OrderCounterNotifier extends StateNotifier<int> {
  final Box _counterBox;

  OrderCounterNotifier(this._counterBox) : super(1) {
    _initializeOrderCounter();
  }

  // Initialize order counter from Hive
  Future<void> _initializeOrderCounter() async {
    try {
      int counter = _counterBox.get('orderCounter', defaultValue: 1);
      state = counter;
      log('Initialized orderCounter: $state');
    } catch (e) {
      log('Error initializing orderCounter: $e');
    }
  }

  // Increment counter by 1
  Future<void> incrementCounter() async {
    state += 1;
    await _counterBox.put('orderCounter', state);
    log('Order counter incremented to: $state');
  }

  // Decrement counter by 1, ensuring it does not go below 1
  Future<void> decrementCounter() async {
    if (state > 1) {
      state -= 1;
      await _counterBox.put('orderCounter', state);
      log('Order counter decremented to: $state');
    } else {
      log('Order counter cannot be less than 1');
    }
  }

  // Reset counter to 1
  Future<void> resetOrderCounter() async {
    state = 1;
    await _counterBox.put('orderCounter', 1);
    log('Order counter has been reset to 0001');
  }

  // Optional method to update counter with any arbitrary value
  Future<void> updateOrderCounter(int newCounter) async {
    state = newCounter;
    await _counterBox.put('orderCounter', newCounter);
    // log('Updated orderCounter: $newCounter');
  }
}

// Provider to expose OrderCounterNotifier
final orderCounterProvider =
    StateNotifierProvider<OrderCounterNotifier, int>((ref) {
  final box = Hive.box('orderCounter');
  return OrderCounterNotifier(box);
});
