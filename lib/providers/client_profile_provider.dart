import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/client_profile.dart';
import 'package:jspos/data/client_data.dart';
import 'package:jspos/utils/client_profile_utils.dart'; // Import utility functions

/// Provider to open the Hive box for the single client profile
final clientProfileBoxProvider = FutureProvider<Box<ClientProfile>>((ref) async {
  final box = await Hive.openBox<ClientProfile>('clientProfiles');

  // Add hardcoded client data to Hive if the box is empty
  if (box.isEmpty) {
    final profile = mapToClientProfile(clientData); // Convert Map to ClientProfile
    await box.add(profile);
    log('Hardcoded client profile added to Hive.');
  }

  log('Client profile loaded from Hive.');
  return box;
});

/// Notifier for managing a single client profile
class ClientProfileNotifier extends StateNotifier<ClientProfile?> {
  final Ref ref;

  ClientProfileNotifier(this.ref) : super(null);

  /// Load the client profile from Hive
  Future<void> loadProfile() async {
    final box = await ref.read(clientProfileBoxProvider.future);
    if (box.isNotEmpty) {
      state = box.getAt(0); // Assume a single profile stored
    }
  }

  /// Update the client profile in Hive and provider
  Future<void> updateProfile(ClientProfile profile) async {
    final box = await ref.read(clientProfileBoxProvider.future);
    if (box.isNotEmpty) {
      await box.putAt(0, profile);
    } else {
      await box.add(profile);
    }
    state = profile;
  }
}

/// Provider for managing the single client profile (source of truth)
final clientProfileProvider =
    StateNotifierProvider<ClientProfileNotifier, ClientProfile?>((ref) {
  return ClientProfileNotifier(ref);
});
