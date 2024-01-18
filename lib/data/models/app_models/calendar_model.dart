import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../backend/widgets/constants/constants.dart';
import 'paycheck_model.dart';

class CalendarPaycheckDataSource extends CalendarDataSource {
  CalendarPaycheckDataSource(List<CalendarPaycheck> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  // Add other necessary methods and properties as needed

  int getAppointmentCount() {
    return appointments!.length;
  }
}

class CalendarPaycheck {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? key;
  String? reoccurance;
  DateTime? created;

  CalendarPaycheck(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.key,
      this.reoccurance,
      this.created});

  static CalendarPaycheck fromFireBaseSnapShotData(
      PaycheckModel paycheck, WidgetRef ref) {
    var paycheckReoccurance = 'Never';
    final dateParts = paycheck.datepaycheck.split(', ');
    final dateOnly = dateParts[1];
    final newFormat = DateFormat('MM/dd/yyyy');
    final parsedDate = newFormat.parse(dateOnly);
    final month = parsedDate.month;

    return CalendarPaycheck(
        eventName: paycheck.paycheckTitle,
        from: DateFormat('dd/MM/yyyy').parse(paycheck.datepaycheck),
        to: DateFormat('dd/MM/yyyy')
            .parse(paycheck.datepaycheck)
            .add(const Duration(minutes: 15)),
        background: PaycheckMonthModel.getColorForMonth(month),
        isAllDay: false,
        key: paycheck.docID,
        reoccurance: paycheckReoccurance,
        created: DateFormat('MM/dd/yyyy').parse(paycheck.datepaycheck));
  }
}
