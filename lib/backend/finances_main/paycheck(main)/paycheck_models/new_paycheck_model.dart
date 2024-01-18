import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';
import 'package:np_financr/backend/finances_main/rules(all)/rule_widget.dart';
import 'package:np_financr/backend/providers/main_function_providers/selected_rule_providers.dart';

import 'package:np_financr/data/models/app_models/paycheck_model.dart';
import 'package:np_financr/main.dart';

import '../../../widgets/constants/constants.dart';
import '../../accounts(all)/account_cards_widget.dart';
import '../../rules(all)/rule_dummy.dart';
import '../provider/financeproviders/clean_providers.dart';
import '../provider/financeproviders/paycheck_providers.dart';

import '../provider/financeproviders/service_provider.dart';

import '../repeat/repeat_notifiers.dart';

import '../../../widgets/date_time_widgets.dart';
import '../../../widgets/textfield_widget.dart';

class AddNewPaycheckModel extends ConsumerStatefulWidget {
  const AddNewPaycheckModel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewPaycheckModelState();
}

class _AddNewPaycheckModelState extends ConsumerState<AddNewPaycheckModel> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final moneyController = TextEditingController();
  List<String> newpaycheckSelectedDays = [];

  final PaycheckModel nopaycheck = PaycheckModel(
    paycheckTitle: '',
    description: '',
    datepaycheck: '',
    ruleID: '',
    ruleName: '',
    amount: '',
    selectedAccount: '',
    creationDate: '',
  );

  @override
  void initState() {
    super.initState();
    titleController.text = '';
    descriptionController.text = '';
    moneyController.text = '';
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
    final dateProv = ref.watch(dateProvider);
    final uID = FirebaseAuth.instance.currentUser?.uid;
    final format = DateFormat.yMEd();
    final creationDate = format.format(DateTime.now()).toString();
    final ruleSelected = ref.watch(selectedRuleProvider);
    final accountSelected = ref.watch(selectedAccountProvider);

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
          const SizedBox(
            width: double.infinity,
            child: Text(
              'New Paycheck',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade600,
          ),
          const Gap(12),
          const Text(
            'Paycheck Title',
            style: AppStyle.headingOne,
          ),
          const Gap(6),
          TextFieldWidget(
            maxLine: 1,
            hintText: 'Add paycheck Name',
            txtController: titleController,
          ),
          const Gap(12),
          const Text('Description', style: AppStyle.headingOne),
          const Gap(6),
          TextFieldWidget(
            maxLine: 1,
            hintText: 'Add Descriptions',
            txtController: descriptionController,
          ),
          const Gap(12),

          const Divider(
            thickness: 1,
            color: Colors.black,
          ),

          const Gap(12),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: AppStyle.headingTwo,
                    ),
                    const Gap(6),
                    StaticAmountWidget(
                      maxLine: 1,
                      hintText: '0',
                      txtController: moneyController,
                      previousPage: PreviousPage.newPaycheck,
                      headTitle: 'Amount',
                    ),
                  ]),
            ),
            const Gap(22),
            AccountWidget(
              selectedAccountName: accountSelected.accountTitle,
              previousPage: PreviousPage.newPaycheck,
            )
          ]),
          const Gap(12),
          // Date and Time Section
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            ),
            const Gap(22),
            if (ref.read(selectedAccountProvider).accountTitle != '' &&
                moneyController.text != '')
              RuleWidget(
                selectedRuleName: ruleSelected.ruleTitle,
                previousPage: PreviousPage.newPaycheck,
              ),
            if (ref.read(selectedAccountProvider).accountTitle == '' &&
                moneyController.text != '')
              RuleDummy(
                selectedRuleName: ruleSelected.ruleTitle,
                previousPage: PreviousPage.newPaycheck,
              ),
            if (ref.read(selectedAccountProvider).accountTitle != '' &&
                moneyController.text == '')
              RuleDummy(
                selectedRuleName: ruleSelected.ruleTitle,
                previousPage: PreviousPage.newPaycheck,
              ),
            if (ref.read(selectedAccountProvider).accountTitle == '' &&
                moneyController.text == '')
              RuleDummy(
                selectedRuleName: ruleSelected.ruleTitle,
                previousPage: PreviousPage.newPaycheck,
              ),
          ]),
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
                  descriptionController.clear();
                  moneyController.clear();

                  ProvidersClear().newPaycheckProviderClearCreate(
                      titleController, descriptionController, ref);
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
                    final paycheckModel = PaycheckModel(
                      paycheckTitle: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      datepaycheck: ref.read(dateProvider),
                      ruleID: ruleSelected.ruleID,
                      ruleName: ruleSelected.ruleTitle,
                      amount: moneyController.text,
                      selectedAccount: accountSelected.accountTitle,
                      creationDate: creationDate,
                    );

                    final uID = FirebaseAuth.instance.currentUser?.uid;

                    if (uID != null) {
                      final newpaycheckReference =
                          await ref.read(serviceProvider).addNewpaycheck(
                                ref,
                                paycheckModel,
                                uID,
                              );
                      paycheckModel.docID = newpaycheckReference.id;

                      ref.read(paycheckListProvider.notifier).updatepaychecks(
                        [...ref.read(paycheckListProvider), paycheckModel],
                      );
                    }

                    ref.read(fetchPaychecks).isRefreshing;

                    ProvidersClear().newPaycheckProviderClearCreate(
                        titleController, descriptionController, ref);
                    moneyController.clear();
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
