import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/user.dart';

class CurrentUserNotifier extends StateNotifier<User?> {
  static const String _boxName = 'currentUser';

  CurrentUserNotifier() : super(null);

  /// Set the current user and update `isCheckIn` status.
  Future<void> setUser(User user, {bool isCheckIn = false}) async {
    final updatedUser = user.copyWith(isCheckIn: isCheckIn);
    state = updatedUser; // Update the state
    final box = await Hive.openBox<User>(_boxName);
    await box.put('currentUser', updatedUser); // Save the user to Hive
  }

  /// Load the current user from Hive storage.
  Future<void> loadUser() async {
    final box = await Hive.openBox<User>(_boxName);
    final user = box.get('currentUser');
    state = user;

    // If the user exists, ensure `isCheckIn` is synced with the state.
    if (user != null) {
      state = user.copyWith(isCheckIn: user.isCheckIn);
    }
  }

  /// Clear the current user and reset `isCheckIn` to false.
  Future<void> clearUser() async {
    state = null;
    final box = await Hive.openBox<User>(_boxName);
    await box.delete('currentUser');
  }

  void updateActiveShiftId(String shiftId) {
    if (state != null) {
      state = state!.copyWith(activeShiftId: shiftId);
    }
  }

  /// Toggle `isCheckIn` status for the current user.
  Future<void> toggleCheckInState() async {
    if (state != null) {
      final updatedCheckIn = !(state!.isCheckIn);
      await setUser(state!.copyWith(isCheckIn: updatedCheckIn));
    }
  }

  /// Update `isCheckIn` status explicitly for the current user.
  Future<void> updateCheckInStatus(bool isCheckIn) async {
    if (state != null) {
      final updatedUser = state!.copyWith(isCheckIn: isCheckIn);
      state = updatedUser;
      final box = await Hive.openBox<User>(_boxName);
      await box.put('currentUser', updatedUser); // Save updated state to Hive
    }
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>(
  (ref) => CurrentUserNotifier(),
);
