// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:np_financr/backend/finances_main/rules(all)/ruleproviders/rule_make.dart';
import 'package:np_financr/backend/finances_main/rules(all)/ruleproviders/rule_make_from_paycheck.dart';
import 'package:np_financr/main.dart';

import '../../../data/models/app_models/rule_model.dart';
import '../../widgets/constants/constants.dart';

import 'logic(unfinished)/deposit_logic.dart';
import 'logic(unfinished)/transfer_logic.dart';

import '../../services/main_function_services/rule_service.dart';
import '../../providers/main_function_providers/selected_rule_providers.dart';
import 'select_rule.dart';

class RuleWidget extends ConsumerStatefulWidget {
  const RuleWidget({
    Key? key,
    required this.selectedRuleName,
    required this.previousPage,
  }) : super(key: key);

  final String selectedRuleName;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RuleWidgetState();
}

class _RuleWidgetState extends ConsumerState<RuleWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedRuleName = ref.watch(selectedRuleProvider).ruleTitle;
    var shownRule = 'Select Rule';
    if (selectedRuleName == '') {
      setState(() {
        shownRule = 'Select Rule';
      });
    }
    if (selectedRuleName != '') {
      setState(() {
        shownRule = selectedRuleName;
      });
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rule',
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
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectRuleMethod(
                            previousPage: widget.previousPage);
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
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.add),
                      const Gap(6),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.8,
                        child: Text(
                          shownRule,
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
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

class AddRuleWidget extends ConsumerStatefulWidget {
  const AddRuleWidget({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddRuleWidgetState();
}

class _AddRuleWidgetState extends ConsumerState<AddRuleWidget> {
  int? selectedCheckboxIndex;

  @override
  void initState() {
    super.initState();
    selectedCheckboxIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    final ruleNameController = TextEditingController();
    final selectedRule = ref.watch(selectedRuleProvider);

    String? selectedRuleType;
    List<DropdownMenuItem<String>> addRuleList = [
      const DropdownMenuItem(value: 'Deposit', child: Text('Deposit')),
      const DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
    ];

    return AlertDialog(
      title: const Text('Add Rule Name'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: TextField(
                    controller: ruleNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Rule Name',
                    ),
                  ),
                ),
                const Gap(5),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      items: addRuleList,
                      hint: const Text('Rule Type?'),
                      value: selectedRuleType,
                      onChanged: (value) {
                        if (value == 'Transfer') {
                          setState(
                            () {
                              selectedRuleType = value;
                            },
                          );
                          const TransferLogic();
                        } else if (value == 'Deposit') {
                          setState(
                            () {
                              selectedRuleType = value;
                            },
                          );
                          const DepositLogic();
                        }
                      }),
                )
              ],
            ),
          );
        },
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final format = DateFormat.yMEd();
                if (ruleNameController.text.isNotEmpty) {
                  final scaffoldState = ScaffoldMessenger.of(context);
                  scaffoldState.showSnackBar(
                    const SnackBar(content: Text('Adding rule...')),
                  );

                  addRule(context, ref, ruleNameController.text,
                      format.format(DateTime.now()).toString());

                  if (widget.previousPage == PreviousPage.newPaycheck) {
                    setAccountsForPaycheckRule(
                        context,
                        ref,
                        widget.previousPage,
                        ruleNameController.text,
                        selectedRule);
                  } else {
                    setAccountsForRule(
                        context,
                        ref,
                        widget.previousPage,
                        ruleNameController.text,
                        selectedRule,
                        selectedCheckboxIndex);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}

RuleModel addRule(
  BuildContext context,
  WidgetRef ref,
  String ruleTitle,
  String creationDate,
) {
  final userCreatedRuleModel = RuleModel(
    ruleTitle: ruleTitle,
    creationDate: creationDate,
  );

  RuleService().addNewRule(ref, userCreatedRuleModel);

  return userCreatedRuleModel;
}
