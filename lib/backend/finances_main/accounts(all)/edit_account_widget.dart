import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/main.dart';

import '../../../data/models/app_models/account_model.dart';
import '../../widgets/constants/constants.dart';
import '../../login_all/auth_provider.dart';
import '../paycheck(main)/provider/financeproviders/clean_providers.dart';
import '../paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import '../paycheck(main)/provider/financeproviders/service_provider.dart';
import '../paycheck(main)/repeat/repeat_notifiers.dart';
import '../../widgets/date_time_widgets.dart';
import '../../widgets/textfield_widget.dart';
import '../rules(all)/rule_widget.dart';
import 'account_cards_widget.dart';
import '../../providers/main_function_providers/account_providers/account_providers.dart';

class EditAccountModel extends ConsumerStatefulWidget {
  final AccountModel accountToUpdate;
  final Function(AccountModel) onaccountUpdated;
  const EditAccountModel(
      {Key? key, required this.accountToUpdate, required this.onaccountUpdated})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAccountModelState();
}

@override
class _EditAccountModelState extends ConsumerState<EditAccountModel> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController moneyController;

  @override
  void initState() {
    super.initState();
    var accountToUpdate = widget.accountToUpdate;

    titleController = TextEditingController(
      text: accountToUpdate.accountTitle,
    );
    descriptionController = TextEditingController(
      text: accountToUpdate.description,
    );
    moneyController =
        TextEditingController(text: accountToUpdate.amount.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var accountToUpdate = widget.accountToUpdate;

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
            'Edit account',
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
              'Current account Title',
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
                          .read(accountListProvider.notifier)
                          .removeAccounts(accountToUpdate);
                    } catch (error) {
                      if (kDebugMode) {
                        print('Error deleting account: $error');
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
                  'Delete account',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
        TextFieldWidget(
          maxLine: 1,
          hintText: 'Edit account Name',
          txtController: titleController,
        ),
        const Gap(12),
        const Text('Current Description', style: AppStyle.headingOne),
        const Gap(6),
        TextFieldWidget(
          maxLine: 3,
          hintText: 'Edit Descriptions',
          txtController: descriptionController,
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
            previousPage: PreviousPage.editPaycheck,
          )
        ]),
        const Gap(12),
        // Date and Time Section
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          DateTimeWidget(
            titleText: 'Date',
            valueText: accountToUpdate.creationDate,
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
            previousPage: PreviousPage.editPaycheck,
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
                    final newDescription = descriptionController.text;

                    final updatedaccount = await ref
                        .read(updatepaycheckProvider)
                        .updatepaycheckFields(
                          userID: userID!,
                          paycheckID: accountToUpdate.docID,
                          newTitle: newTitle,
                          newDescription: newDescription,
                          newDate: accountToUpdate.creationDate,
                          newAmount: accountToUpdate.amount,
                        );

                    if (updatedaccount != null) {
                      ToDoService().updatepaychecksList(ref, updatedaccount);
                    }

                    ref
                        .read(accountListProvider.notifier)
                        .updateAccounts([...ref.read(accountListProvider)]);

                    ref.read(fetchAccounts).isRefreshing;

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
