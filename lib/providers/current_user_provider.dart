import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/user.dart';

class CurrentUserNotifier extends StateNotifier<User?> {
  static const String _boxName = 'currentUser';

  CurrentUserNotifier() : super(null);

  // Set the current user
  Future<void> setUser(User user, {bool isCheckIn = false}) async {
    final updatedUser = user.copyWith(isCheckIn: isCheckIn);
    state = updatedUser; // Update state
    final box = await Hive.openBox<User>(_boxName);
    await box.put('currentUser', updatedUser); // Save to Hive
  }

  // Load the current user from Hive
  Future<void> loadUser() async {
    final box = await Hive.openBox<User>(_boxName);
    state = box.get('currentUser');
  }

  // Clear the current user
  Future<void> clearUser() async {
    state = null;
    final box = await Hive.openBox<User>(_boxName);
    await box.delete('currentUser');
  }

  // Update check-in status
  Future<void> updateCheckInStatus(bool isCheckIn) async {
    if (state != null) {
      final updatedUser = state!.copyWith(isCheckIn: isCheckIn);
      state = updatedUser;
      final box = await Hive.openBox<User>(_boxName);
      await box.put('currentUser', updatedUser);
    }
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>(
  (ref) => CurrentUserNotifier(),
);

