import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class InvoiceProvider extends StateNotifier<int> {
  InvoiceProvider() : super(0);

  // Initialize the counter from Hive or Cloud
  Future<void> initializeInvoiceCounter() async {
    // Open Hive box
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
    var settingsBox = Hive.box('settings');

    // Fetch the latest invoice counter from the cloud
    int cloudCounter = await fetchLatestInvoiceCounterFromCloud();

    // Use the highest of local or cloud counter
    int localCounter = settingsBox.get('invoiceCounter', defaultValue: 0) as int;
    int initialCounter = (cloudCounter > localCounter) ? cloudCounter : localCounter;

    // Save the counter in Hive and set state
    settingsBox.put('invoiceCounter', initialCounter);
    state = initialCounter;
  }

  // Fetch the latest invoice counter from the cloud
  Future<int> fetchLatestInvoiceCounterFromCloud() async {
    // Simulate cloud API call
    // Replace with actual cloud fetching logic
    return 1; // Example: Replace this with the cloud's current counter
  }

  // Generate the next invoice number
  Future<String> generateInvoiceNumber() async {
    // Use the current state for the invoice number
    int currentCounter = state;

    // Save to Hive with incremented value for the next call
    var settingsBox = Hive.box('settings');
    settingsBox.put('invoiceCounter', currentCounter + 1);

    // Update state for the next number
    state = currentCounter + 1;

    // Sync with cloud storage
    await syncInvoiceCounterToCloud(currentCounter + 1);

    // Return formatted invoice number
    return "INV#${currentCounter.toString().padLeft(4, '0')}";
  }

  // Sync the counter to cloud storage
  Future<void> syncInvoiceCounterToCloud(int counter) async {
    // Simulate cloud sync logic
    // Replace this with actual cloud saving logic
    log('Invoice counter synced to cloud: $counter');
  }

  // Reset the invoice counter
  Future<void> resetInvoiceCounter() async {
    try {
      // Default reset value
      const int defaultCounter = 0;

      // Update Hive
      var settingsBox = Hive.box('settings');
      settingsBox.put('invoiceCounter', defaultCounter);

      // Update state
      state = defaultCounter;

      // Optionally, sync the reset counter with the cloud
      await syncInvoiceCounterToCloud(defaultCounter);

      log('Invoice counter has been reset to $defaultCounter.');
    } catch (e) {
      log('Failed to reset the invoice counter: $e');
      rethrow;
    }
  }
}

final invoiceProvider = StateNotifierProvider<InvoiceProvider, int>((ref) {
  return InvoiceProvider();
});
