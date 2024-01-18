import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';

import 'package:np_financr/backend/providers/main_function_providers/goal_providers.dart';
import 'package:np_financr/backend/services/main_function_services/goal_services.dart';

import 'package:np_financr/data/models/app_models/paycheck_model.dart';
import 'package:np_financr/main.dart';

import '../../../backend/widgets/constants/constants.dart';
import '../../../backend/finances_main/accounts(all)/account_cards_widget.dart';
import '../../../backend/finances_main/goals(all)/color_widget.dart';
import '../../../backend/finances_main/paycheck(main)/provider/financeproviders/service_provider.dart';
import '../../../backend/widgets/date_time_widgets.dart';
import '../../../backend/widgets/textfield_widget.dart';
import 'account_model.dart';
import 'goal_model.dart';

class AddNewGoalModel extends ConsumerStatefulWidget {
  const AddNewGoalModel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewGoalModelState();
}

class _AddNewGoalModelState extends ConsumerState<AddNewGoalModel> {
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
    final accountSelected = ref.watch(selectedAccountProvider);
    var goalType = ref.watch(goalTypeProvider);

    if (uID == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  'Sign in to add new Goals',
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
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'New Goal',
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
            'Goal Name',
            style: AppStyle.headingOne,
          ),
          const Gap(6),
          TextFieldWidget(
            maxLine: 1,
            hintText: 'Add Goal Name',
            txtController: titleController,
          ),
          const Gap(12),

          const Divider(
            thickness: 1,
            color: Colors.black,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (goalType == true)
              AccountWidget(
                selectedAccountName: accountSelected.accountTitle,
                previousPage: PreviousPage.newPaycheck,
              ),
            if (goalType != true) const AccountWidgetDummy(),
            const Gap(22),
            StaticAmountWidget(
              maxLine: 1,
              hintText: '0',
              txtController: moneyController,
              previousPage: PreviousPage.newPaycheck,
              headTitle: 'Goal Amount',
            ),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            if (goalType == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      ref
                          .read(goalTypeProvider.notifier)
                          .update((state) => false);
                    });
                  },
                  icon: const Icon(
                    Icons.description,
                  ),
                  label: SizedBox(
                      width: MediaQuery.of(context).size.width / 5.5,
                      child: const Text('Track Manually')),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              ),
            if (goalType != true)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        ref
                            .read(goalTypeProvider.notifier)
                            .update((state) => true);
                      });
                    },
                    icon: const Icon(
                      Icons.account_balance_wallet,
                    ),
                    label: SizedBox(
                        width: MediaQuery.of(context).size.width / 5.5,
                        child: const Text('Track By Account')),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.greenAccent),
                    )),
              )
          ]),
          const Gap(20),
          // Date and Time Section
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            DateTimeWidget(
              titleText: 'Date to Complete?',
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
            const ColorWidget(),

            //Button Section
          ]),
          const Gap(22),

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

                  ref.read(selectedAccountProvider.notifier).update((state) =>
                      AccountModel(
                          accountTitle: '',
                          description: '',
                          creationDate: '',
                          amount: ''));
                  ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
                  ref.read(goalTypeProvider.notifier).update((state) => true);

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
                  final format = DateFormat.yMd();
                  String type = 'Account';
                  if (goalType == true) {
                    type = 'Account';
                  } else if (goalType != true) {
                    type = 'Manual';
                  }
                  try {
                    final goalModel = GoalModel(
                        goalTitle: titleController.text,
                        creationDate: format.format(DateTime.now()),
                        amount: moneyController.text,
                        type: type,
                        account: accountSelected.accountTitle,
                        color: '',
                        completionDate: dateProv);

                    final uID = FirebaseAuth.instance.currentUser?.uid;

                    if (uID != null) {
                      final newGoalReference =
                          await ref.read(goalProvider).addNewGoal(
                                ref,
                                goalModel,
                                uID,
                              );
                      goalModel.docID = newGoalReference.id;

                      ref.read(goalListProvider.notifier).updateGoals(
                        [...ref.read(goalListProvider), goalModel],
                      );
                    }

                    ref.read(fetchGoals).isRefreshing;

                    ref.read(selectedAccountProvider.notifier).update((state) =>
                        AccountModel(
                            accountTitle: '',
                            description: '',
                            creationDate: '',
                            amount: ''));
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => 'mm/dd/yy');
                    ref.read(goalTypeProvider.notifier).update((state) => true);
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
