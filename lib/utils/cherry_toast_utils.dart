import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

IconData _getIconData(String iconText) {
  const iconMap = {
    'check_circle': Icons.check_circle,
    'info': Icons.info,
    'cancel': Icons.cancel,
  };

  return iconMap[iconText] ?? Icons.info; // Default to 'info' if not found
}

void showCherryToast(
  BuildContext context, // Pass the context as an argument
  String iconText,
  Color iconColor,
  String titleText,
  int toastDu, // Toast duration in milliseconds
  int animateDu, // Animation duration in milliseconds
) {
  CherryToast(
    icon: _getIconData(iconText), // Retrieve the corresponding icon
    iconColor: iconColor,
    themeColor: const Color.fromRGBO(46, 125, 50, 1),
    backgroundColor: Colors.white,
    title: Text(
      titleText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    toastPosition: Position.top,
    toastDuration: Duration(milliseconds: toastDu), // Use the passed duration
    animationType: AnimationType.fromTop,
    animationDuration: Duration(milliseconds: animateDu), // Use the passed animation duration
    autoDismiss: true,
    displayCloseButton: false,
  ).show(context);
}