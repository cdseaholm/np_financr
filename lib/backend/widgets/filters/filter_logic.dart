import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../data/models/app_models/paycheck_model.dart';

final user = FirebaseAuth.instance.currentUser?.uid;

class FilterStates {
  final format = DateFormat.yMEd();

  //all

  List<PaycheckModel> clearSort(
    List<PaycheckModel> paychecks,
  ) {
    return paychecks;
  }

  // Paycheck
  void sortByPaycheck(List<PaycheckModel> paychecks, String paycheck) {
    if (paycheck != 'No Paycheck') {
      paychecks.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    }
  }

// Completed
  void sortByCompleted(List<PaycheckModel> paychecks) {
    var dateList = <DateTime>[];
    for (var paycheck in paychecks) {
      final DateTime creationTime = format.parse(paycheck.creationDate);
      dateList.add(creationTime);
    }
    dateList.sort((a, b) => a.compareTo(b));

    var paychecksIndex = 0;
    for (var creationTime in dateList) {
      paychecks[paychecksIndex++] = paychecks.firstWhere(
          (paycheck) => paycheck.creationDate == creationTime.toString());
    }
  }

// Date
  void sortByDate(List<PaycheckModel> paychecks) {
    var dateList = <DateTime>[];
    for (var paycheck in paychecks) {
      final DateTime paycheckTime = format.parse(paycheck.datepaycheck);
      dateList.add(paycheckTime);
    }
    dateList.sort((a, b) => a.compareTo(b));

    var paychecksIndex = 0;
    for (var paycheckTime in dateList) {
      final format = DateFormat.yMEd();
      final String paycheckDate = format.format(paycheckTime);
      paychecks[paychecksIndex++] = paychecks
          .firstWhere((paycheck) => paycheck.datepaycheck == paycheckDate);
    }
  }

// New->Old
  void sortNewestToOldest(List<PaycheckModel> paychecks) {
    var paycheckCreationList = <DateTime>[];
    for (var paycheck in paychecks) {
      final DateTime creationTime = format.parse(paycheck.creationDate);
      paycheckCreationList.add(creationTime);
    }
    paycheckCreationList.sort((a, b) => a.compareTo(b));

    var paychecksIndex = 0;
    for (var creationTime in paycheckCreationList) {
      final format = DateFormat.yMEd();
      final String createdDate = format.format(creationTime);
      paychecks[paychecksIndex++] = paychecks
          .firstWhere((paycheck) => paycheck.creationDate == createdDate);
    }
  }

// Old->New
  void sortOldestToNewest(List<PaycheckModel> paychecks) {
    var paycheckCreationList = <DateTime>[];
    for (var paycheck in paychecks) {
      final DateTime creationTime = format.parse(paycheck.creationDate);
      paycheckCreationList.add(creationTime);
    }
    paycheckCreationList.sort((a, b) => a.compareTo(b));

    var paychecksIndex = 0;
    for (var creationTime in paycheckCreationList.reversed) {
      final format = DateFormat.yMEd();
      final String createdDate = format.format(creationTime);
      paychecks[paychecksIndex++] = paychecks
          .firstWhere((paycheck) => paycheck.creationDate == createdDate);
    }
  }

// Overdue(Checked)
  void sortByOverdue(List<PaycheckModel> paychecks) {
    final today = DateTime.now();
    paychecks.retainWhere((paycheck) {
      final DateTime dateOfpaycheck = format.parse(paycheck.datepaycheck);
      return dateOfpaycheck.isBefore(today);
    });
    paychecks.sort((a, b) => a.datepaycheck.compareTo(b.datepaycheck));
  }

// Upcoming(Checked)
  void sortByUpcoming(List<PaycheckModel> paychecks) {
    final today = DateTime.now();
    paychecks.retainWhere((paycheck) {
      final DateTime dateOfpaycheck = format.parse(paycheck.datepaycheck);
      return dateOfpaycheck.isAfter(today);
    });
    paychecks.sort((a, b) => a.datepaycheck.compareTo(b.datepaycheck));
  }
}
