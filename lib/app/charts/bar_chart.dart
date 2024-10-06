import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeFrame { day, week, month, year }

class BarChartSample4 extends StatefulWidget {
  final TimeFrame timeFrame;
  final int? operationStart; // Optional parameters
  final int? operationClose;

  const BarChartSample4({
    super.key,
    required this.timeFrame,
    this.operationStart, // Pass them here
    this.operationClose,
  });

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  late DateTime today; // Declare the variable

  @override
  void initState() {
    super.initState();
    today = DateTime.now(); // Initialize the value in initState
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, color: Colors.white);
    String text = '';

    switch (widget.timeFrame) {
      case TimeFrame.day:
        // Use operationStart and operationClose if provided, otherwise fallback to default 6 AM to 6 AM
        int operationStart = widget.operationStart ?? 6; // Defaults to 6 AM
        int hour = operationStart + value.toInt(); // Adjust start time

        if (hour >= 24) {
          hour -= 24; // Wrap around after midnight
        }

        if (hour == 0) {
          text = '12 AM'; // Handle midnight
        } else if (hour < 12) {
          text = '$hour AM'; // Morning hours
        } else if (hour == 12) {
          text = '12 PM'; // Noon
        } else {
          text = '${hour - 12} PM'; // Afternoon and evening hours
        }
        break;

      case TimeFrame.week:
        // Define the days of the week
        List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        // Get today's date
        DateTime today = DateTime.now();

        // Calculate the start of the current week (assuming the week starts on Monday)
        DateTime mondayOfWeek = today.subtract(Duration(days: today.weekday - 1));

        // Add the current `value.toInt()` days to get the corresponding date
        DateTime currentDay = mondayOfWeek.add(Duration(days: value.toInt()));

        // Format the day (1st, 2nd, 3rd, etc.)
        String daySuffix(int day) {
          if (day >= 11 && day <= 13) {
            return 'th';
          }
          switch (day % 10) {
            case 1:
              return 'st';
            case 2:
              return 'nd';
            case 3:
              return 'rd';
            default:
              return 'th';
          }
        }

        // Get the day of the month and suffix
        String dayOfMonth = '${currentDay.day}${daySuffix(currentDay.day)}';

        // Get the month (using a list of month names)
        List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        String month = months[currentDay.month - 1];

        // Combine day of the week, day of the month, and month to create the full label
        text = '${days[value.toInt()]} ($dayOfMonth $month)';

        break;

      case TimeFrame.month:
        int dayOfMonth = value.toInt() + 1;
        text = dayOfMonth.toString();
        break;

      case TimeFrame.year:
        List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        text = months[value.toInt()];
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  // Dynamically calculate the number of bars based on the timeFrame
  int getBarCount() {
    switch (widget.timeFrame) {
      case TimeFrame.day:
        // Calculate bar count based on operational hours
        int operationStart = widget.operationStart ?? 6; // Default to 6 AM
        int operationClose = widget.operationClose ?? 6; // Default to 6 AM next day
        return operationClose - operationStart; // Number of operational hours
      case TimeFrame.week:
        return 7; // 7 days in a week
      case TimeFrame.month:
        return DateTime(today.year, today.month + 1, 0).day; // Days in current month
      case TimeFrame.year:
        return 12; // 12 months in a year
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 20, left: 10),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barCount = getBarCount();

                // Dynamically calculate barsWidth and barsSpace based on barCount
                final availableWidth = constraints.maxWidth * 0.8; // 80% for bars
                final totalBarsSpace = constraints.maxWidth * 0.2; // 20% for spaces

                final barsWidth = availableWidth / barCount;
                final barsSpace = totalBarsSpace / (barCount - 1); // Avoid dividing by zero

                List<BarChartGroupData> barGroups = getData(barsWidth, barsSpace);
                double highestValue = getHighestValue(barGroups);
                double maxY = getMaxY(highestValue);

                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    maxY: maxY,
                    backgroundColor: const Color(0xff1f2029),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8), // Padding for tooltip
                        tooltipRoundedRadius: 8, // Border radius for tooltip
                        tooltipMargin: 8, // Margin for tooltip
                        // getTooltipColor: Colors.blue, // Tooltip background color
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final value = rod.toY;
                          final NumberFormat formatter = NumberFormat('#,##0.00');
                          String formattedValue;

                          if (value % 1 == 0) {
                            formattedValue = NumberFormat('#,##0').format(value); // No decimal places
                          } else {
                            formattedValue = formatter.format(value); // Two decimal places
                          }

                          return BarTooltipItem(
                            formattedValue,
                            const TextStyle(
                              color: Colors.white, // Tooltip text color
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: bottomTitles,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) {
                        return value % 50 == 0 || value == maxY;
                      },
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1, // Set the border width
                      ),
                    ),
                    groupsSpace: barsSpace,
                    barGroups: barGroups,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Sales Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getHighestValue(List<BarChartGroupData> barGroups) {
    double highest = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > highest) {
          highest = rod.toY;
        }
      }
    }
    return highest;
  }

  double getMaxY(double highestValue) {
    return (highestValue * 1.1).ceilToDouble(); // Add 10% buffer to maxY
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    int barCount = getBarCount(); // Calculate based on time frame
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < barCount; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: (1000 + (i * 100)).toDouble(), // Sample data
              color: i % 2 == 0 ? Colors.green : Colors.white, // Alternate bar colors
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), // Use Radius.circular() here
                topRight: Radius.circular(5),
              ),

              width: barsWidth,
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, color: Colors.white);
    String formattedValue;

    if (value >= 1000 && value % 1000 == 0) {
      formattedValue = '${(value / 1000).toStringAsFixed(0)}k';
    } else if (value >= 1000 && value % 1000 != 0 && value % 100 == 0) {
      formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      final NumberFormat formatter = NumberFormat('#,##0');
      formattedValue = formatter.format(value);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(formattedValue, style: style),
    );
  }
}
