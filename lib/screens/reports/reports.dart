import 'package:flutter/material.dart';
import 'package:jspos/app/charts/bar_chart.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List tabs = ['Day', 'Week', 'Month', 'Year'];
  List sumTabs = ['Today', 'This Week', 'This Month', 'This Year'];
  String selectedTab = 'Day';
  double todayTotal = 100.00;
  double weekTotal = 500.00;
  double monthTotal = 2000.00;
  double yearTotal = 24000.00;
  TimeFrame getTimeFrameFromString(String selectedTab) {
    switch (selectedTab) {
      case 'Day':
        return TimeFrame.day;
      case 'Week':
        return TimeFrame.week;
      case 'Month':
        return TimeFrame.month;
      case 'Year':
        return TimeFrame.year;
      default:
        return TimeFrame.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    int? operationStart;
    int? operationClose;

    // Set operational hours only if the selected tab is "Day"
    if (selectedTab == 'Day') {
      operationStart = 7; // 7 AM
      operationClose = 20; // 5 PM in 24-hour format
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...tabs.map((tab) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = tab;
                          });
                        },
                        child: _itemTab(
                          title: tab,
                          isActive: selectedTab == tab,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 10, bottom: 0),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: _totalSumTab(title: "Today", amount: todayTotal),
                    ),
                    Expanded(
                      child: _totalSumTab(title: "This Week", amount: weekTotal),
                    ),
                    Expanded(
                      child: _totalSumTab(title: "This Month", amount: monthTotal),
                    ),
                    Expanded(
                      child: _totalSumTab(title: "This Year", amount: yearTotal),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff1f2029), // Set your desired background color here
                        borderRadius: BorderRadius.circular(5), // Set your desired border radius here
                      ),
                      child: BarChartSample4(
                        timeFrame: getTimeFrameFromString(selectedTab),
                        operationStart: operationStart, // Pass operational hours if "Day"
                        operationClose: operationClose,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTab({
    // required String icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff1f2029),
          border: isActive ? Border.all(color: Colors.deepOrangeAccent, width: 2) : Border.all(color: const Color(0xff1f2029), width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }

  Widget _totalSumTab({required String title, required double amount}) {
    final NumberFormat formatter = NumberFormat('#,##0.00');
    String formattedAmount;

    if (amount % 1 == 0) {
      formattedAmount = NumberFormat('#,##0').format(amount); // No decimal places
    } else {
      formattedAmount = formatter.format(amount); // Two decimal places
    }

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff1f2029),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "RM $formattedAmount",
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
