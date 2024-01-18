import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/finances_main/rules(all)/rule_widget.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_monthly_model.dart';
import 'package:np_financr/main.dart';

import '../../widgets/constants/constants.dart';
import '../accounts(all)/account_cards_widget.dart';
import '../../login_all/auth_provider.dart';
import '../paycheck(main)/provider/financeproviders/clean_providers.dart';
import '../paycheck(main)/provider/financeproviders/service_provider.dart';
import '../paycheck(main)/repeat/repeat_notifiers.dart';
import '../../widgets/date_time_widgets.dart';
import '../../widgets/textfield_widget.dart';
import '../../../data/models/app_models/model_monthly_update.dart';
import '../../services/main_function_services/services_monthly_update.dart';

class EditMonthlyUpdateModel extends ConsumerStatefulWidget {
  final MonthlyUpdateModel monthlyUpdateToUpdate;
  final Function(MonthlyUpdateModel) onmonthlyUpdateUpdated;
  const EditMonthlyUpdateModel(
      {Key? key,
      required this.monthlyUpdateToUpdate,
      required this.onmonthlyUpdateUpdated})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditMonthlyUpdateModelState();
}

@override
class _EditMonthlyUpdateModelState
    extends ConsumerState<EditMonthlyUpdateModel> {
  late TextEditingController titleController;
  late TextEditingController notesController;
  late TextEditingController moneyController;

  @override
  void initState() {
    super.initState();
    var monthlyUpdateToUpdate = widget.monthlyUpdateToUpdate;

    titleController = TextEditingController(
      text: monthlyUpdateToUpdate.monthlyModelTitle,
    );
    notesController = TextEditingController(
      text: monthlyUpdateToUpdate.notes,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var monthlyUpdateToUpdate = widget.monthlyUpdateToUpdate;

    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Edit monthlyUpdate',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Divider(
          thickness: 1.2,
          color: Colors.grey.shade600,
        ),
        const Gap(12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Current monthlyUpdate Title',
              style: AppStyle.headingOne,
            ),
            Container(
              constraints: BoxConstraints.tight(const Size(90, 25)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                onPressed: () async {
                  final userID = ref.read(authStateProvider).maybeWhen(
                        data: (user) => user?.uid,
                        orElse: () => null,
                      );
                  if (userID != null) {
                    try {
                      ref
                          .read(monthlyUpdateListProvider.notifier)
                          .removemonthlyUpdate(monthlyUpdateToUpdate);
                    } catch (error) {
                      if (kDebugMode) {
                        print('Error deleting monthlyUpdate: $error');
                      }
                    }
                  }

                  ProvidersClear().clearEditpaycheck(ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Delete monthlyUpdate',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
        TextFieldWidget(
          maxLine: 1,
          hintText: 'Edit monthlyUpdate Name',
          txtController: titleController,
        ),
        const Gap(12),
        const Text('Current Description', style: AppStyle.headingOne),
        const Gap(6),
        TextFieldWidget(
          maxLine: 3,
          hintText: 'Edit Descriptions',
          txtController: notesController,
        ),
        const Gap(12),

        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
        const Gap(12),

        TextFieldWidget(
            maxLine: 1, hintText: 'Amount', txtController: moneyController),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Amount',
                style: AppStyle.headingTwo,
              ),
              const Gap(6),
              TextFieldWidget(
                  maxLine: 1,
                  hintText: 'Amount',
                  txtController: moneyController),
            ]),
          ),
          const Gap(22),
          const AccountWidget(
            selectedAccountName: '',
            previousPage: PreviousPage.editMonthlyUpdate,
          )
        ]),
        const Gap(12),
        // Date and Time Section
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          DateTimeWidget(
            titleText: 'Date',
            valueText: monthlyUpdateToUpdate.datemonthlyModel,
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
          ),
          const Gap(22),
          const RuleWidget(
            selectedRuleName: '',
            previousPage: PreviousPage.editMonthlyUpdate,
          )
        ]),
        const Gap(12),

        //Button Section

        const Gap(12),

        Row(
          children: [
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
                  ProvidersClear().clearEditpaycheck(ref);
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
            Expanded(
              child: Builder(builder: (context) {
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
                    final userID = FirebaseAuth.instance.currentUser?.uid;
                    final newTitle = titleController.text;
                    final newDescription = notesController.text;

                    final updatedmonthlyUpdate = await ref
                        .read(updatemonthlyUpdateProvider)
                        .updatemonthlyUpdateFields(
                          userID: userID!,
                          monthlyUpdateID: monthlyUpdateToUpdate.docID,
                          newTitle: newTitle,
                          newNotes: newDescription,
                          newDate: monthlyUpdateToUpdate.datemonthlyModel,
                        );

                    if (updatedmonthlyUpdate != null) {
                      MonthlyUpdateService()
                          .updatemonthlyUpdatesList(ref, updatedmonthlyUpdate);
                    }

                    ref
                        .read(monthlyUpdateListProvider.notifier)
                        .updatemonthlyUpdates(
                            [...ref.read(monthlyUpdateListProvider)]);

                    ref.read(fetchMonthlyUpdates).isRefreshing;

                    ProvidersClear().clearEditpaycheck(ref);
                    setState(() {
                      selectedRepeatingDaysList = [];
                      frequencyNotifier.value = 'No';
                      repeatUntilNotifier.value = 'Until?';
                      selectedDaysNotifier.value = [];
                      showDaysHint = true;
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update'),
                );
              }),
            ),
          ],
        )
      ]),
    );
  }
}
