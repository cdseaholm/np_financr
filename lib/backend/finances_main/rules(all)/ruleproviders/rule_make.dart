// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/air_model.dart';
import 'package:np_financr/backend/providers/main_function_providers/selected_rule_providers.dart';
import 'package:np_financr/backend/login_all/alert_messages.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/provider/financeproviders/service_provider.dart';
import 'package:np_financr/backend/widgets/textfield_widget.dart';
import '../../../../data/models/app_models/rule_model.dart';
import '../../../../main.dart';
import '../../../services/main_function_services/air_services.dart';
import '../../../providers/main_function_providers/account_providers/account_edit.dart';
import '../../../providers/main_function_providers/account_providers/account_providers.dart';

import '../../../providers/main_function_providers/rule_provider.dart';

Widget setAccountsForRule(
    BuildContext context,
    WidgetRef ref,
    PreviousPage previousPage,
    String ruleName,
    RuleModel ruleModel,
    int? selectedCheckboxIndex) {
  final accounts = ref.watch(accountListProvider);
  final ruleID = ref.watch(selectedRuleProvider).ruleID;

  var mainValue = double.parse(ref.read(valueForRuleProvider));

  final List<TextEditingController> amountControllers =
      List.generate(accounts.length, (index) => TextEditingController());

  final List<String> typeProvider =
      List.generate(accounts.length, (index) => '\$');

  final List<bool> boolProvider =
      List.generate(accounts.length, ((index) => false));

  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: AlertDialog(
                  title: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Set Percentages/Amounts',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Gap(1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '(Any left blank will be 0)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Row(
                              children: [
                                Text(
                                  'Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ]),
                          Column(children: [
                            Row(
                              children: [
                                Text(
                                  'Use Remainder of',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Check Here?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ]),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Amount or',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Percentage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26)),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: accounts.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final account = entry.value;
                                  var text = amountControllers[index];
                                  var remainder = boolProvider[index];
                                  if (remainder == true) {
                                    text.text = '0';
                                  }

                                  return Row(
                                    textBaseline: TextBaseline.ideographic,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      deleteAccountMethod(
                                                          context,
                                                          ref,
                                                          account);
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons.trash,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      account.accountTitle,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                child: Checkbox(
                                                  value: boolProvider[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      for (var i = 0;
                                                          i <
                                                              boolProvider
                                                                  .length;
                                                          i++) {
                                                        if (i == index) {
                                                          boolProvider[i] =
                                                              value!;
                                                          amountControllers[
                                                                  index]
                                                              .text = '0';
                                                        } else {
                                                          boolProvider[i] =
                                                              false;
                                                        }
                                                      }
                                                    });
                                                  },
                                                )),
                                          ],
                                        ),
                                      ),
                                      const Gap(5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RuleMakeNumberDropWidget(
                                            index: index,
                                            maxLine: 1,
                                            hintText: '0',
                                            txtController: text,
                                            selectedType: typeProvider[index],
                                            previousPage:
                                                PreviousPage.ruleCreate,
                                            onChanged: (account, amountType) {
                                              typeProvider[index] = amountType;
                                            },
                                          ),
                                          const Gap(10),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (accounts.length.isGreaterThan(5))
                        const Text(
                          'Scroll Down for More Accounts',
                          style: TextStyle(fontSize: 12),
                        ),
                      const Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ref.read(selectedRuleProvider.notifier).update(
                                  (state) => RuleModel(
                                      ruleTitle: '', creationDate: ''));
                            },
                            child: const Text('Back'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              List<int> percentageIndices = [];
                              List<int> amountIndices = [];
                              List<int> remainderList = [];
                              String remainderController = '-{r}-';
                              double percentage = 0;
                              late String amount;

                              ref.read(ruleListProvider.notifier).updateRules(
                                  [...ref.read(ruleListProvider), ruleModel]);

                              try {
                                for (int i = 0; i < accounts.length; i++) {
                                  var typeController = typeProvider[i];

                                  var controller = amountControllers[i];
                                  var textValue = controller.text;
                                  var finalTextValue =
                                      double.tryParse(textValue) ?? 0;

                                  if (boolProvider[i] == true) {
                                    textValue == remainderController;
                                    remainderList.add(i);
                                  }

                                  if (finalTextValue != 0) {
                                    if (typeController == '%') {
                                      percentageIndices.add(i);
                                    } else if (typeController == '\$') {
                                      amountIndices.add(i);
                                    }
                                  }
                                }
                              } finally {
                                for (var i in percentageIndices) {
                                  var controller = amountControllers[i];
                                  var textValue = controller.text;
                                  var finalTextValue =
                                      double.tryParse(textValue) ?? 0;

                                  var finalPerc = finalTextValue / 100;
                                  percentage += mainValue * finalPerc;
                                }

                                // Check if the total percentage exceeds 100%
                                if (percentage > 100) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Total percentage cannot exceed 100%'),
                                    ),
                                  );
                                }
                                try {
                                  final ruleIDMake =
                                      ref.read(selectedRuleProvider).ruleID;
                                  if (ruleIDMake != '') {
                                    for (var i in percentageIndices) {
                                      var controller = amountControllers[i];
                                      var textValue = controller.text;
                                      var finalTextValue =
                                          double.tryParse(textValue) ?? 0;
                                      var account = accounts[i];
                                      var finalPerc = finalTextValue / 100;
                                      percentage += mainValue * finalPerc;

                                      var amountType = typeProvider[i];

                                      final air = AIRModel(
                                          ruleID: ruleID,
                                          accountTitle: account.accountTitle,
                                          creationDate:
                                              DateTime.now().toString(),
                                          amountType: amountType,
                                          accountPortion: finalPerc.toString(),
                                          currentAccountAmount: account.amount,
                                          thisPaycheckCut: '0');

                                      await AccountsForRules()
                                          .addNewAccountsRule(
                                              ref, ruleIDMake, air);
                                    }

                                    for (var i in amountIndices) {
                                      var controller = amountControllers[i];
                                      var textValue = controller.text;
                                      var finalTextValue =
                                          double.tryParse(textValue) ?? 0;
                                      var account = accounts[i];
                                      var amountType = typeProvider[i];

                                      amount = finalTextValue.toString();

                                      final air = AIRModel(
                                          ruleID: ruleID,
                                          accountTitle: account.accountTitle,
                                          creationDate:
                                              DateTime.now().toString(),
                                          amountType: amountType,
                                          accountPortion: amount,
                                          currentAccountAmount: account.amount,
                                          thisPaycheckCut: '0');

                                      await AccountsForRules()
                                          .addNewAccountsRule(
                                        ref,
                                        ruleIDMake,
                                        air,
                                      );
                                    }
                                    for (var i in remainderList) {
                                      var account = accounts[i];
                                      final air = AIRModel(
                                          ruleID: ruleID,
                                          accountTitle: account.accountTitle,
                                          creationDate:
                                              DateTime.now().toString(),
                                          amountType: '-{r}-',
                                          accountPortion: '0',
                                          currentAccountAmount: account.amount,
                                          thisPaycheckCut: '0');

                                      await AccountsForRules()
                                          .addNewAccountsRule(
                                        ref,
                                        ruleIDMake,
                                        air,
                                      );
                                    }
                                  }
                                } finally {
                                  ref
                                      .read(selectedRuleProvider.notifier)
                                      .update(
                                        (state) => RuleModel(
                                          ruleTitle: '',
                                          creationDate: '',
                                        ),
                                      );
                                  RuleSaved().ruleSavedMessage(
                                      context, ruleName, previousPage);
                                }
                              }
                            },
                            child: const Text('Save Rules'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          },
        );
      });
  return Container();
}
