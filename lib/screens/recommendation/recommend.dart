import 'package:flutter/material.dart';
import 'package:jspos/app/charts/bar_chart.dart';
// import 'package:intl/intl.dart';
import 'package:jspos/screens/recommendation/top_five.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  List tabs = ['Day', 'Week', 'Month', 'Year'];
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
    // int? operationStart;
    // int? operationClose;

    // // Set operational hours only if the selected tab is "Day"
    // if (selectedTab == 'Day') {
    //   operationStart = 7; // 7 AM
    //   operationClose = 20; // 8 PM in 24-hour format
    // }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          children: [
            // Tab Selection Row
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

            // Display the relevant total tab based on the selected tab
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: TopFivePage(_getTotalTab(selectedTab))),
                  ],
                ),
              ),
            ),

            // top 10 table list
          ],
        ),
      ),
    );
  }

  // Helper method to return the appropriate total tab based on the selected tab
  Widget _getTotalTab(String tab) {
    switch (tab) {
      case 'Day':
        return _totalSumTab(title: "Daily Top 5", amount: todayTotal);
      case 'Week':
        return _totalSumTab(title: "Weekly Top 5", amount: weekTotal);
      case 'Month':
        return _totalSumTab(title: "Monthly Top 5", amount: monthTotal);
      case 'Year':
        return _totalSumTab(title: "Yearly Top 5", amount: yearTotal);
      default:
        return _totalSumTab(title: "Daily Top 5", amount: todayTotal);
    }
  }

  // Widget to create each tab item
  Widget _itemTab({
    required String title,
    required bool isActive,
  }) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isActive ? const Color.fromRGBO(46, 125, 50, 1) : const Color(0xff1f2029),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display the total summary tab
  Widget _totalSumTab({required String title, required double amount}) {
    // final NumberFormat formatter = NumberFormat('#,##0.00');
    // String formattedAmount;

    // if (amount % 1 == 0) {
    //   formattedAmount = NumberFormat('#,##0').format(amount); // No decimal places
    // } else {
    //   formattedAmount = formatter.format(amount); // Two decimal places
    // }

    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10),
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
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
