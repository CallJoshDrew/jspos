import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jspos/providers/current_user_provider.dart';
import 'package:jspos/utils/cherry_toast_utils.dart';

final cashProvider = StateProvider<double>((ref) => 0.0);

class CheckOutPage extends ConsumerStatefulWidget {
  final void Function() toggleCheckInState;
  const CheckOutPage({super.key, required this.toggleCheckInState});

  @override
  CheckOutPageState createState() => CheckOutPageState();
}

class CheckOutPageState extends ConsumerState<CheckOutPage> {
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

  IconData _getIconData(String iconText) {
    const iconMap = {'check_circle': Icons.check_circle, 'info': Icons.info, 'cancel': Icons.cancel};

    return iconMap[iconText] ?? Icons.info; // Default to 'help' if not found
  }

  // void _showCherryToast(
  //   String iconText,
  //   iconColor,
  //   String titleText,
  //   int toastDu, // Changed to int for duration
  //   int animateDu,
  // ) {
  //   CherryToast(
  //     icon: _getIconData(iconText), // Retrieve the corresponding icon
  //     iconColor: iconColor,
  //     themeColor: const Color.fromRGBO(46, 125, 50, 1),
  //     backgroundColor: Colors.white,
  //     title: Text(
  //       titleText,
  //       style: const TextStyle(
  //         fontSize: 14,
  //         color: Colors.black,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     toastPosition: Position.top,
  //     toastDuration: Duration(milliseconds: toastDu), // Use the passed duration
  //     animationType: AnimationType.fromTop,
  //     animationDuration: Duration(milliseconds: animateDu), // Use the passed animation duration
  //     autoDismiss: true,
  //     displayCloseButton: false,
  //   ).show(context);
  // }

  @override
  void dispose() {
    _cashController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cashAmount = ref.watch(cashProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content vertically
            children: [
              const Text(
                'Check Out Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth * 0.5,
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepOrange, width: 1),
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
                          Text(
                            'Date: $currentDate',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Time: $currentTime',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0), // Border color when focused
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
                              "Today's Collected Cash",
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
                                borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0), // Border color when focused
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
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
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
                              log('Current User name is: ${currentUser?.name}');
                              final password = _passwordController.text;
                              final cashValue = _cashController.text;
                              // Validation: Check if password and cash are entered
                              if (password.isEmpty || cashValue.isEmpty || double.tryParse(cashValue) == null) {
                                showCherryToast(
                                  context,
                                  'cancel', // Icon for error
                                  Colors.deepOrange,
                                  'Please enter both a valid password and cash amount.',
                                  3000, // Duration in milliseconds
                                  1000, // Animation duration
                                );
                                return; // Exit the function if validation fails
                              }
                              // Validate the password
                              if (currentUser?.password == password) {
                                // Password is valid, proceed with check-out logic
                                widget.toggleCheckInState();

                                // Update the provider to clear the current user
                                ref.read(currentUserProvider.notifier).clearUser();

                                showCherryToast(
                                  context,
                                  'check_circle',
                                  Colors.green,
                                  'Goodbye ${currentUser?.name}! Cash increased to RM${double.parse(cashValue).toStringAsFixed(2)}',
                                  3000,
                                  1000,
                                );
                              } else {  
                                // Password is incorrect
                                showCherryToast(
                                  context,
                                  'cancel',
                                  Colors.deepOrange,
                                  'Please enter the correct password.',
                                  3000,
                                  1000,
                                );
                              }
                            },
                            child: const Text('Check Out'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
