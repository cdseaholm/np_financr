import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/data/models/app_models/model_monthly_update.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_monthly_model.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';
import '../../widgets/constants/constants.dart';

import '../paycheck(main)/provider/financeproviders/clean_providers.dart';
import '../paycheck(main)/provider/financeproviders/service_provider.dart';
import '../paycheck(main)/repeat/repeat_notifiers.dart';
import '../../widgets/date_time_widgets.dart';

import '../../widgets/textfield_widget.dart';
import '../updater_all/updater.dart';

class NewMonthlyUpdate extends StatefulHookConsumerWidget {
  const NewMonthlyUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewMonthlyUpdateState();
}

class _NewMonthlyUpdateState extends ConsumerState<NewMonthlyUpdate> {
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  List<String> newMonthlyModelSelectedDays = [];

  final MonthlyUpdateModel noMonthlyModel = MonthlyUpdateModel(
    monthlyModelTitle: '',
    notes: '',
    datemonthlyModel: '',
    amount: '',
    creationDate: '',
  );

  @override
  void initState() {
    super.initState();
    titleController.text = '';
    notesController.text = '';
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uID = FirebaseAuth.instance.currentUser?.uid;
    var dateProv = ref.watch(dateProvider);
    final format = DateFormat.yMEd();
    final creationDate = format.format(DateTime.now()).toString();
    final monthFormat = DateFormat.MMMM();
    final month = monthFormat.format(DateTime.now());
    final monthColor =
        PaycheckMonthModel.getColorForMonth(DateTime.now().month);
    setState(() {
      dateProv = creationDate;
    });

    if (uID == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  'Sign in to add new paychecks',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]);
        },
      );
    }

    return Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.77,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  'New Monthly Update',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Gap(15),
                Text(
                  month,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: monthColor),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade600,
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Title',
                        style: AppStyle.headingTwo,
                      ),
                      const Gap(6),
                      UpdateTextFieldWidget(
                        maxLine: 1,
                        hintText: 'Add Update Name',
                        txtController: titleController,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(22),
              DateTimeWidget(
                titleText: 'Date',
                valueText: dateProv,
                iconSection: CupertinoIcons.calendar,
                onTap: () async {
                  final getValue = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 2),
                      lastDate: DateTime(DateTime.now().year + 4));

                  if (getValue != null) {
                    final format = DateFormat.yMEd();
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => format.format(getValue));
                  }
                },
              )
            ],
          ),

          const Gap(12),

          const Divider(
            thickness: 1,
            color: Colors.black,
          ),

          const Gap(12),

          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [UpdaterAllWidget()]),
          const Gap(12),

          // Date and Time Section

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Notes', style: AppStyle.headingTwo),
                      const Gap(6),
                      TextFieldWidget(
                        maxLine: 4,
                        hintText: 'Add Notes',
                        txtController: notesController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),

          //Button Section

          const Gap(12),

          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  titleController.clear();
                  notesController.clear();

                  ProvidersClear().newPaycheckProviderClearCreate(
                      titleController, notesController, ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const Gap(20),
            Expanded(child: Builder(builder: (context) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  try {
                    final monthlyUpdateModel = MonthlyUpdateModel(
                      docID: ref.read(shellMonthReportIDProvider),
                      monthlyModelTitle: titleController.text.trim(),
                      notes: notesController.text.trim(),
                      datemonthlyModel: monthFormat.format(DateTime.now()),
                      amount: ref.read(monthTotalAmountProvider),
                      creationDate: creationDate,
                    );

                    final uID = FirebaseAuth.instance.currentUser?.uid;

                    if (uID != null) {
                      await UpdatemonthlyUpdateService()
                          .updatemonthlyUpdateFields(
                              userID: uID,
                              monthlyUpdateID: monthlyUpdateModel.docID,
                              newTitle: monthlyUpdateModel.monthlyModelTitle,
                              newAmount: monthlyUpdateModel.amount,
                              newDate: monthlyUpdateModel.creationDate,
                              newMonth: monthlyUpdateModel.datemonthlyModel,
                              newNotes: monthlyUpdateModel.notes);

                      ref
                          .read(monthlyUpdateListProvider.notifier)
                          .updatemonthlyUpdates(
                        [
                          ...ref.read(monthlyUpdateListProvider),
                          monthlyUpdateModel
                        ],
                      );
                    }

                    ref.read(fetchMonthlyUpdates).isRefreshing;

                    ProvidersClear().newPaycheckProviderClearCreate(
                        titleController, notesController, ref);
                    ref
                        .read(monthTotalAmountProvider.notifier)
                        .update((state) => '');

                    setState(() {
                      frequencyNotifier.value = 'No';
                      repeatUntilNotifier.value = 'Until?';
                      selectedDaysNotifier.value = [];
                      selectedRepeatingDaysList.clear();
                      showDaysHint = true;
                    });
                  } finally {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Create'),
              );
            }))
          ])
        ]));
  }
}

class RulesetDropDownWidget extends StatelessWidget {
  const RulesetDropDownWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  final List<DropdownMenuItem<String>> items;
  final String? selectedItem;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ruleset',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: .5)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Flex(
                      clipBehavior: Clip.hardEdge,
                      direction: axisDirectionToAxis(AxisDirection.right),
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Add a Ruleset',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            iconSize: 20,
                            items: items,
                            value: selectedItem,
                            onChanged: onChanged,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
