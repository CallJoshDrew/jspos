import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspos/providers/shift_provider.dart';
import 'package:jspos/utils/date_utils.dart';

class ShiftPage extends ConsumerWidget {
  const ShiftPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the shifts state
    final shifts = ref.watch(shiftsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Shifts'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: shifts.isEmpty
            ? const Center(
                child: Text(
                  'No shifts recorded.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: shifts.length,
                itemBuilder: (context, index) {
                  final shift = shifts[index];
                  return Card(
                    child: ListTile(
                      title: Text(shift.userId),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('ID: ${shift.id}'),
                          // Text('UserID: ${shift.userId}'),
                          Text('Start Time: ${formatDateTime(shift.startTime)}'),
                          Text('End Time: ${shift.endTime != null ? formatDateTime(shift.endTime!) : 'Ongoing'}'),
                          Text('Cash Start Amount: RM ${shift.cashStartAmount.toStringAsFixed(2)}'),
                          if (shift.status == 'closed') ...[
                            Text('Cash End Amount: RM ${shift.cashEndAmount?.toStringAsFixed(2)}'),
                            Text(
                              'Total Sales: RM ${shift.totalSales}',
                              style: const TextStyle(
                                fontSize: 16, // Set the font size
                                color: Colors.green, // Set the font color
                                fontWeight: FontWeight.bold, // Optional: Set the font weight
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Text(
                        shift.status == 'closed' ? 'Closed' : 'Active',
                        style: TextStyle(
                          color: shift.status == 'closed' ? Colors.grey : Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
