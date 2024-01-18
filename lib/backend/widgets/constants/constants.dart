import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppStyle {
  static const headingOne =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);

  static const headingTwo =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black);
}

String formatPaycheckDate(String date) {
  final paycheckDate = DateFormat.yMEd().parse(date);
  final currentDate = DateTime.now();
  final difference = paycheckDate.difference(currentDate).inDays;

  if (difference <= 60) {
    return DateFormat.yMEd().format(paycheckDate);
  } else {
    return DateFormat.yMd().format(paycheckDate);
  }
}

class RepeatShownStyle {
  static const inAlertShown = TextStyle(
      fontSize: 22,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold);
}

class PaycheckMonthModel {
  static Map<int, Color> monthColors = {
    1: const Color.fromARGB(255, 133, 187, 231), // January (Winter blue)
    2: const Color.fromARGB(255, 231, 131, 124), // February (Valentine's red)
    3: Colors.green, // March (Spring green)
    4: const Color.fromARGB(255, 205, 144, 247), // April (Sunny yellow)
    5: const Color.fromARGB(255, 255, 136, 175), // May (Cherry blossom pink)
    6: Colors.teal, // June (Ocean teal)
    7: const Color.fromARGB(255, 240, 181, 103), // July (Sunset amber)
    8: const Color.fromARGB(255, 212, 129, 5), // August (Beachy orange)
    9: const Color.fromARGB(255, 218, 206, 46), // September (Autumn purple)
    10: const Color.fromARGB(255, 226, 99, 25), // October (Halloween indigo)
    11: const Color.fromARGB(255, 141, 60, 5), // November (Fall lime)
    12: const Color.fromARGB(255, 25, 97, 28), // December (Christmas green)
  };

  static Map<int, String> textMonths = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'Aug',
    9: 'Sept',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  static Color getColorForMonth(int month) {
    return monthColors[month] ?? Colors.grey;
  }

  static String getMonthDate(int month) {
    return textMonths[month] ?? '';
  }
}
