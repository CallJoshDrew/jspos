import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/hive/current_user_storage.dart';
import 'package:jspos/models/user.dart';

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null);

  // Set the current user
  Future<void> setUser(User user) async {
    state = user; // Update state
    await CurrentUserStorage.saveUser(user); // Save to Hive
  }

  // Load the current user from Hive
  Future<void> loadUser() async {
    final user = await CurrentUserStorage.getUser();
    state = user;
  }

  // Clear the current user
  Future<void> clearUser() async {
    state = null;
    await CurrentUserStorage.clearUser();
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>(
  (ref) => CurrentUserNotifier(),
);
