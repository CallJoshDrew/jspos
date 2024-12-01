import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final cashProvider = StateProvider<double>((ref) => 0.0);

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key});

  @override
  CheckInPageState createState() => CheckInPageState();
}

class CheckInPageState extends ConsumerState<CheckInPage> {
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final String currentDate;
  late final String currentTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    String daySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
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

    currentDate = '${DateFormat('d').format(now)}${daySuffix(now.day)} ${DateFormat('MMM yyyy (EEEE)').format(now)}';
    currentTime = DateFormat('h:mm a').format(now).replaceAll("AM", "A.M.").replaceAll("PM", "P.M.");
  }

  @override
  void dispose() {
    _cashController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cashAmount = ref.watch(cashProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(46, 125, 50, 1), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            "Today's Date",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black12), // Set border color here
                          ),
                          child: Text(
                            currentDate,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            "Current Time",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black12), // Set border color here
                          ),
                          child: Text(
                            currentTime,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        "Your Password",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Key in Your Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), // Add border radius if desired
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromRGBO(46, 125, 50, 1), width: 2.0), // Border color when focused
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26, width: 1.0), // Border color when enabled (unfocused)
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(cashProvider.notifier).state = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        "Today's Cash",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cashController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Cash Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), // Add border radius if desired
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromRGBO(46, 125, 50, 1), width: 2.0), // Border color when focused
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26, width: 1.0), // Border color when enabled (unfocused)
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(cashProvider.notifier).state = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(46, 125, 50, 1)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(14, 6, 14, 6),
                        ),
                      ),
                      onPressed: () {
                        final password = _passwordController.text;
            
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password: $password, Cash: \$${cashAmount.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                      child: const Text('Check In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}