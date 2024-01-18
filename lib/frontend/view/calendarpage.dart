import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/paycheck_models/paycheck_details.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../backend/finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import '../../data/models/app_models/paycheck_model.dart';

import '../../backend/services/main_function_services/calendar_services.dart';
import '../../data/models/app_models/calendar_model.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  final CalendarController _controller = CalendarController();
  CalendarPaycheckDataSource? calendarPaychecks;
  List<PaycheckModel>? fullPaychecks;
  bool isInitialLoaded = false;

  List<CalendarPaycheck> paycheckDetails = <CalendarPaycheck>[];
  List<PaycheckModel> paycheckModelDetails = <PaycheckModel>[];

  @override
  void initState() {
    super.initState();
    _controller;

    getDataFromDatabase().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.black54),
                      left: BorderSide(width: 1, color: Colors.black54),
                      right: BorderSide(width: 1, color: Colors.black54))),
              child: SfCalendar(
                view: CalendarView.month,
                controller: _controller,
                showNavigationArrow: true,
                cellEndPadding: 5,
                cellBorderColor: Colors.black,
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                  CalendarView.schedule,
                ],
                todayTextStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                showTodayButton: true,
                showDatePickerButton: true,
                showCurrentTimeIndicator: true,
                dataSource: calendarPaychecks,
                timeSlotViewSettings: TimeSlotViewSettings(
                    timeTextStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    minimumAppointmentDuration: const Duration(minutes: 5),
                    timeIntervalHeight:
                        MediaQuery.of(context).size.height / 10),
                monthViewSettings: const MonthViewSettings(
                    numberOfWeeksInView: 6,
                    navigationDirection: MonthNavigationDirection.horizontal,
                    showAgenda: false,
                    monthCellStyle: MonthCellStyle(
                      trailingDatesBackgroundColor: Colors.black12,
                      leadingDatesBackgroundColor: Colors.black12,
                    )),
                onTap: calendarTapped,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5045,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.black54),
                      bottom: BorderSide(width: 1, color: Colors.black54),
                      left: BorderSide(width: 1, color: Colors.black54),
                      right: BorderSide(width: 1, color: Colors.black54))),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
                itemCount: paycheckDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.all(2),
                      color: paycheckDetails[index].background,
                      child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                paycheckDetails[index].isAllDay!
                                    ? ''
                                    : DateFormat('MM/dd/yyyy')
                                        .format(paycheckDetails[index].from!),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.7,
                                ),
                              ),
                              Text('\$${paycheckModelDetails[index].amount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 2,
                                  ))
                            ],
                          ),
                          title: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              paycheckDetails[index].eventName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              if (index >= 0 &&
                                  index < paycheckModelDetails.length) {
                                await showModalBottomSheet(
                                  showDragHandle: true,
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  context: context,
                                  builder: (context) => PaycheckDetails(
                                    selectedPaycheck:
                                        paycheckModelDetails[index],
                                  ),
                                );
                              } else {}
                            },
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0x000fffff))),
                            child: const Text(
                              'Paycheck Details',
                              style: TextStyle(fontSize: 12),
                            ),
                          )));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getDataFromDatabase() async {
    final paycheckList = ref.read(paycheckListProvider);

    if (paycheckList.isNotEmpty) {
      List<CalendarPaycheck> calendarPaycheckList = paycheckList
          .map((paycheck) => CalendarPaycheck(
                eventName: paycheck.paycheckTitle,
                from: formatDateTime(paycheck.datepaycheck),
                to: formatDateTime(paycheck.datepaycheck)
                    .add(const Duration(minutes: 30)),
                background: getMonthColor(paycheckList),
                isAllDay: false,
                key: paycheck.docID,
              ))
          .toList();
      setState(() {
        calendarPaychecks = CalendarPaycheckDataSource(calendarPaycheckList);
      });
      setState(() {
        fullPaychecks = paycheckList
            .map((paycheck) => PaycheckModel(
                  docID: paycheck.docID,
                  paycheckTitle: paycheck.paycheckTitle,
                  description: paycheck.description,
                  datepaycheck: paycheck.datepaycheck,
                  ruleID: paycheck.ruleID,
                  ruleName: paycheck.ruleName,
                  amount: paycheck.amount,
                  selectedAccount: paycheck.selectedAccount,
                  creationDate: paycheck.creationDate,
                ))
            .toList();
      });
    }
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        paycheckDetails =
            calendarTapDetails.appointments!.cast<CalendarPaycheck>();
        paycheckModelDetails = paycheckDetails.map((calendarPaycheck) {
          final matchingPaycheckModel = fullPaychecks!.firstWhere(
            (paycheckModel) => paycheckModel.docID == calendarPaycheck.key,
          );
          return matchingPaycheckModel;
        }).toList();
      });
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {}
  }
}
