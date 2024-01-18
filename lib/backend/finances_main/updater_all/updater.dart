// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/finances_main/bill_create/bill_create.dart';
import 'package:np_financr/backend/finances_main/bill_create/bill_selection.dart';
import 'package:np_financr/data/models/app_models/model_bills.dart';
import 'package:np_financr/backend/services/main_function_services/services_bills.dart';
import 'package:np_financr/data/models/app_models/month_bills_summary_model.dart';
import 'package:np_financr/backend/services/main_function_services/monthly_bill_summary_service.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_monthly_model.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';
import 'package:np_financr/backend/finances_main/updater_all/previous_month_updates.dart';
import 'package:np_financr/backend/services/main_function_services/previous_months_services.dart';

import 'package:np_financr/backend/widgets/number_file_widget.dart';

import 'package:np_financr/main.dart';

import '../../widgets/constants/constants.dart';
import '../../../data/models/app_models/model_monthly_update.dart';
import '../../widgets/show_toast.dart';

class UpdaterAllWidget extends StatefulHookConsumerWidget {
  const UpdaterAllWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdaterAllWidgetState();
}

class _UpdaterAllWidgetState extends ConsumerState<UpdaterAllWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Build Your Update',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return const UpdaterMethod(
                          previousPage: PreviousPage.updaterAllWidget,
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.add),
                      Gap(6),
                      Text('Begin Update'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final billListProvider = StateProvider<List<BillDetailsModel>>((ref) => []);
final monthTotalAmountProvider = StateProvider<String>((ref) => '');
final shellMonthReportIDProvider = StateProvider<String>((ref) => '');

class UpdaterMethod extends ConsumerStatefulWidget {
  const UpdaterMethod({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdaterMethodState();
}

class _UpdaterMethodState extends ConsumerState<UpdaterMethod> {
  var amountControllerMap = <String, TextEditingController>{};
  var currentAmountController = TextEditingController();
  var currentBillAmount = '0';

  @override
  void initState() {
    super.initState();

    final billDetailsList = ref.read(billDetailsListStateProvider);

    for (var bill in billDetailsList) {
      amountControllerMap[bill.billTitle] = TextEditingController();
      amountControllerMap[bill.billTitle]!.text = bill.amount;
    }
  }

  @override
  void dispose() {
    for (var controller in amountControllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billList = ref.watch(billListProvider);
    final previousMonthUpdateToUseTitle = ref.read(previousUpdateStateProvider);
    var runningMonthlyTotal = '0';

    return AlertDialog(
      title: Column(children: [
        const Text('What to Update?'),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                DialogRoute<void>(
                  builder: (BuildContext context) =>
                      const PreviousMonthUpdates(),
                  context: context,
                ),
              );
            },
            child: const Text(
              'Use a Previous Month?',
              style: TextStyle(fontSize: 15),
            ))
      ]),
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Item:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Amount:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      if (previousMonthUpdateToUseTitle.updaterTitle == '')
                        for (var bill in billList)
                          if (amountControllerMap[bill.billTitle] != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              try {
                                                billList.remove(bill);
                                              } finally {
                                                ref
                                                    .read(billListProvider
                                                        .notifier)
                                                    .update((state) {
                                                  billList;
                                                  return billList;
                                                });
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.close_outlined,
                                              size: 14,
                                            ),
                                          ),
                                          Text(bill.billTitle),
                                        ],
                                      ),
                                    ],
                                  ),
                                  NumberFieldWidget(
                                    maxLine: 1,
                                    hintText:
                                        amountControllerMap[bill.billTitle]
                                                ?.text ??
                                            '0',
                                    txtController:
                                        amountControllerMap[bill.billTitle]!,
                                    selectedType: '\$',
                                    previousPage:
                                        PreviousPage.editMonthlyUpdate,
                                  ),
                                ],
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                  builder: (BuildContext context) =>
                                      const BillCreateWidget(
                                        previousPage: PreviousPage.updater,
                                      ),
                                  context: context);
                            },
                            child: const Text(
                              'New Monthly Bill +',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                  builder: (BuildContext context) =>
                                      const BillSelectionWidget(
                                        previousPage: PreviousPage.updater,
                                      ),
                                  context: context);
                            },
                            child: const Text('Add Previous Bill +',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(5),
            if (billList.length > 4)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scroll for more',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ref
                    .read(billDetailsListStateProvider.notifier)
                    .update((state) => []);
              },
              child: const Column(
                children: [
                  Text('Clear'),
                  Text('And Cancel'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  showToast('Saving...');
                  final format = DateFormat.yMEd();
                  final uID = FirebaseAuth.instance.currentUser?.uid;
                  var finalMonthlyReportID = '0';
                  if (uID != null) {
                    final monthlyReportID = MonthlyUpdateModel(
                      monthlyModelTitle: '',
                      notes: '',
                      datemonthlyModel: '',
                      amount: '',
                      creationDate: '',
                    );
                    final shellMonthlyReport = await ref
                        .read(monthlyUpdateProvider)
                        .addNewmonthlyUpdate(ref, monthlyReportID, uID);
                    monthlyReportID.docID = shellMonthlyReport.id;
                    finalMonthlyReportID = monthlyReportID.docID;
                    ref.read(shellMonthReportIDProvider.notifier).update(
                          (state) => finalMonthlyReportID,
                        );
                  }
                  for (var monthlyBillPiece in billList) {
                    var finalBillAmount = monthlyBillPiece.amount;
                    if (amountControllerMap[monthlyBillPiece.billTitle]!
                            .text
                            .trim() ==
                        '') {
                      finalBillAmount = monthlyBillPiece.amount;
                    } else {
                      finalBillAmount =
                          amountControllerMap[monthlyBillPiece.billTitle]!
                              .text
                              .trim();
                    }
                    runningMonthlyTotal = runningMonthlyTotal + finalBillAmount;
                    final thisMonthBillsUpdate = MonthlyBillSummaryModel(
                        billSummaryPieceTitle: monthlyBillPiece.billTitle,
                        billSummaryPieceAmount: finalBillAmount,
                        creationDate: format.format(DateTime.now()));

                    final uID = FirebaseAuth.instance.currentUser?.uid;
                    if (uID != null) {
                      final newBillSummary = await ref
                          .read(monthlyBillSummaryProvider)
                          .addNewmonthlyBillSummary(ref, thisMonthBillsUpdate,
                              uID, finalMonthlyReportID);

                      thisMonthBillsUpdate.docID = newBillSummary.id;

                      ref
                          .read(monthlyBillSummaryListProvider.notifier)
                          .updatemonthlyBillSummary(
                        [
                          ...ref.read(monthlyBillSummaryListProvider),
                          thisMonthBillsUpdate
                        ],
                      );
                    }

                    ref.read(fetchMonthlyUpdates).isRefreshing;
                  }
                  ref
                      .read(monthTotalAmountProvider.notifier)
                      .update((state) => runningMonthlyTotal);
                } finally {
                  ref
                      .read(billDetailsListStateProvider.notifier)
                      .update((state) => []);
                  runningMonthlyTotal = '0';

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Column(
                children: [
                  Text('Save'),
                  Text('Updates'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
