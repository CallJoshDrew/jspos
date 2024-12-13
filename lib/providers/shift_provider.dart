import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/shift.dart';
import 'package:jspos/providers/current_user_provider.dart';

final shiftsProvider = StateNotifierProvider<ShiftsNotifier, List<Shift>>((ref) {
  return ShiftsNotifier(); // No need to pass the Hive box here
});

class ShiftsNotifier extends StateNotifier<List<Shift>> {
  late final Box<Shift> _shiftsBox; // Declare the box
  ShiftsNotifier() : super([]) {
    _shiftsBox = Hive.box<Shift>('shifts'); // Initialize the box
    _loadShifts();
  }

  void _loadShifts() {
    state = _shiftsBox.values.toList();
  }

  Future<void> addShift(Shift shift, WidgetRef ref) async {
  final shiftId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique key
  shift.id = shiftId; // Assign the shift ID to the Shift object
  await _shiftsBox.put(shiftId, shift);
  _loadShifts();

  // Save the shiftId to currentUserProvider for easy access
  ref.read(currentUserProvider.notifier).updateActiveShiftId(shiftId);
}



  Future<void> updateShift(String shiftId, Shift updatedShift) async {
    if (_shiftsBox.containsKey(shiftId)) {
      await _shiftsBox.put(shiftId, updatedShift);
      _loadShifts();
    }
  }

  Future<void> closeShift(String shiftId, double cashEndAmount, double totalSales) async {
    final shift = _shiftsBox.get(shiftId);
    if (shift != null) {
      shift.endTime = DateTime.now();
      shift.cashEndAmount = cashEndAmount;
      shift.totalSales = totalSales;
      shift.status = 'closed';

      await _shiftsBox.put(shiftId, shift);
      _loadShifts();
    }
  }

  Future<void> deleteShift(String shiftId) async {
    await _shiftsBox.delete(shiftId);
    _loadShifts();
  }
}
