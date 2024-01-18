// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/widgets/constants/constants.dart';
import 'package:np_financr/backend/services/main_function_services/services_bills_instances.dart';
import 'package:np_financr/backend/finances_main/monthly_update/edit_monthly_update.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';

import '../../../data/models/app_models/month_bills_summary_model.dart';

class MonthlyModelCardWidget extends ConsumerStatefulWidget {
  const MonthlyModelCardWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonthlyModelCardWidgetState();
}

class _MonthlyModelCardWidgetState
    extends ConsumerState<MonthlyModelCardWidget> {
  var instanceAmount = '';
  @override
  Widget build(BuildContext context) {
    final monthlyUpdates = ref.watch(monthlyUpdateListProvider);
    var currentmonthlyUpdate = monthlyUpdates[widget.getIndex];
    final instances = ref.watch(billInstancesListProvider);

    for (var element in instances) {
      if (element.billInstanceID == currentmonthlyUpdate.docID) {
        setState(() {
          instanceAmount = element.instanceAmount;
        });
      }
    }
    final dateParts = currentmonthlyUpdate.datemonthlyModel.split(' ');
    final dateOnly = dateParts[1];
    final newFormat = DateFormat('MM/dd/yyyy');
    final parsedDate = newFormat.parse(dateOnly);
    final month = parsedDate.month;
    final textMonth = PaycheckMonthModel.getMonthDate(month);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: .5)),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: PaycheckMonthModel.getColorForMonth(month),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: textMonth.split('').map((letter) {
                return Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: BorderSide.strokeAlignCenter),
                            maximumSize: const Size(80, 45),
                            backgroundColor: const Color(0xFFD5E8FA),
                            foregroundColor: Colors.blue.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1, color: Colors.black12))),
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            context: context,
                            builder: (context) => EditMonthlyUpdateModel(
                              monthlyUpdateToUpdate: currentmonthlyUpdate,
                              onmonthlyUpdateUpdated: (monthlyUpdate) {
                                setState(() {
                                  currentmonthlyUpdate = monthlyUpdate;
                                });
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text(
                        currentmonthlyUpdate.monthlyModelTitle,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        currentmonthlyUpdate.notes,
                        maxLines: 1,
                      ),
                      trailing: Transform.scale(
                        scale: 1.2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                      showDragHandle: true,
                                      isDismissible: false,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Container();
                                      },
                                    );
                                  },
                                  style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(
                                      Size(
                                          MediaQuery.of(context).size.width /
                                              5.8,
                                          MediaQuery.of(context).size.height /
                                              22),
                                    ),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xFFD5E8FA)),
                                    foregroundColor: MaterialStatePropertyAll(
                                        Colors.blue.shade800),
                                    elevation:
                                        const MaterialStatePropertyAll(0),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                                width: 1,
                                                color: Colors.black12))),
                                  ),
                                  child: const Text(
                                    'Details',
                                    style: TextStyle(fontSize: 12),
                                  )),
                            ],
                          ),
                        ),
                      )),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1.5,
                          color: Colors.black38,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              if (currentmonthlyUpdate.datemonthlyModel ==
                                  'mm/dd/yy')
                                const Text('No Date set')
                              else if (currentmonthlyUpdate.datemonthlyModel !=
                                  'mm/dd/yy')
                                Text(formatPaycheckDate(
                                    currentmonthlyUpdate.datemonthlyModel))
                            ]),
                            Column(
                              children: [
                                Text('Amount: \$$instanceAmount'),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ))
        ]));
  }
}

Future<List<String>> loadArray(MonthlyBillSummaryModel model) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Updates')
        .doc(model.docID)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey('repeatingDays') &&
          data['repeatingDays'] is List<dynamic>) {
        var repeatingDaysArray = data['repeatingDays'] as List<dynamic>;

        List<String> array = [];

        for (var day in repeatingDaysArray) {
          if (day is String) {
            array.add(day);
          }
        }

        return array;
      }
    }

    return [];
  } catch (e) {
    return [];
  }
}
