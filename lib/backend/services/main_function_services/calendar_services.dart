import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../widgets/constants/constants.dart';
import '../../../data/models/app_models/paycheck_model.dart';

class CalendarServices {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // READ

  // UPDATE

  Future<void> updateCalendarViewPreference(CalendarView preferredView) async {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;

    if (userID != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userID);
      await userDoc
          .update({'calendarViewPreference': preferredView.toString()});
    }
  }

  //DELETE
}

DateTime formatDateTime(String datePaycheck) {
  final format = DateFormat.yMEd();
  final outputFormat = DateFormat('MM/dd/yyyy');
  final parsedDate = format.parse(datePaycheck);

  final formattedDate = outputFormat.format(parsedDate);
  final date = DateFormat('MM/dd/yyyy').parse(formattedDate);

  return date;
}

Color getMonthColor(List<PaycheckModel> paycheckList) {
  int month = 0;
  for (var paycheck in paycheckList) {
    final dateParts = paycheck.datepaycheck.split(', ');

    final dateOnly = dateParts[1];
    final newFormat = DateFormat('MM/dd/yyyy');
    final parsedDate = newFormat.parse(dateOnly);
    month = parsedDate.month;
  }
  return PaycheckMonthModel.getColorForMonth(month);
}
