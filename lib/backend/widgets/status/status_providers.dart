import 'package:intl/intl.dart';

String determinepaycheckStatus(String datepaycheck) {
  final currentDate = DateTime.now();
  final paycheckDate = DateFormat.yMEd().parse(datepaycheck);

  if (datepaycheck == 'mm/dd/yy') {
    return '';
  } else if (currentDate.isBefore(paycheckDate)) {
    return 'Upcoming';
  } else if (currentDate.day == paycheckDate.day &&
      currentDate.month == paycheckDate.month &&
      currentDate.year == paycheckDate.year) {
    return 'Due Today';
  } else if (currentDate.isAfter(paycheckDate)) {
    return 'Overdue';
  } else {
    return '';
  }
}
