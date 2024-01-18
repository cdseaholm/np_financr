import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../widgets/constants/constants.dart';
import '../../finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';

Stream<Future<CalendarDataSource<Object?>>> fetchData(WidgetRef ref) async* {
  final paycheckList = ref.watch(paycheckListProvider);

  List<Appointment> paychecks = <Appointment>[];

  for (var paycheck in paycheckList) {
    var paycheckReoccurance = 'Never';

    final dateParts = paycheck.datepaycheck.split(', ');
    final dateOnly = dateParts[1];
    final newFormat = DateFormat('MM/dd/yyyy');
    final parsedDate = newFormat.parse(dateOnly);
    final month = parsedDate.month;

    final Appointment oncepaycheck = Appointment(
        startTime: parsedDate,
        endTime: parsedDate.add(const Duration(minutes: 30)),
        isAllDay: false,
        subject: paycheck.paycheckTitle,
        color: PaycheckMonthModel.getColorForMonth(month),
        startTimeZone: null,
        endTimeZone: null,
        id: paycheck.docID);

    paychecks.add(oncepaycheck);

    final Appointment reoccuringpaycheck = Appointment(
        startTime: parsedDate,
        recurrenceRule: paycheckReoccurance,
        endTime: parsedDate.add(const Duration(minutes: 30)),
        isAllDay: false,
        subject: paycheck.paycheckTitle,
        color: PaycheckMonthModel.getColorForMonth(month),
        startTimeZone: null,
        endTimeZone: null,
        id: paycheck.docID);

    paychecks.add(reoccuringpaycheck);
  }

  yield* fetchData(ref);
}
