// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/selected_rule_providers.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/provider/financeproviders/service_provider.dart';

import '../../../../data/models/app_models/rule_model.dart';
import '../../../../main.dart';
import '../../../widgets/number_file_widget.dart';
import '../../../providers/main_function_providers/account_providers/account_edit.dart';
import '../../../providers/main_function_providers/account_providers/account_providers.dart';
import '../../../../data/models/app_models/air_model.dart';

import '../../../services/main_function_services/air_services.dart';
import '../../../providers/main_function_providers/rule_provider.dart';

Widget setAccountsForPaycheckRule(BuildContext context, WidgetRef ref,
    PreviousPage previousPage, String ruleName, RuleModel ruleModel) {
  final accounts = ref.watch(accountListProvider);
  final ruleID = ref.watch(selectedRuleProvider).ruleID;

  var mainValue = double.parse(ref.read(valueForRuleProvider));

  final List<TextEditingController> amountControllers =
      List.generate(accounts.length, (index) => TextEditingController());

  final List<String> typeProvider =
      List.generate(accounts.length, (index) => '\$');

  showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26)),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: accounts.asMap().entries.map((entry) {
                            final index = entry.key;
                            final account = entry.value;
                            var mainAccountAmount = '0';

                            ref.read(selectedAccountProvider).amount =
                                mainAccountAmount;

                            return Row(
                              textBaseline: TextBaseline.ideographic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            deleteAccountMethod(
                                                context, ref, account);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.trash,
                                            size: 18,
                                          ),
                                        ),
                                        Text(
                                          account.accountTitle,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    NumberFieldWidget(
                                      maxLine: 1,
                                      hintText: '0',
                                      txtController: amountControllers[index],
                                      selectedType: '\$',
                                      previousPage: PreviousPage.ruleCreate,
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
                            (state) =>
                                RuleModel(ruleTitle: '', creationDate: ''));
                      },
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          List<int> percentageIndices = [];
                          List<int> amountIndices = [];
                          double percentage = 0;
                          late String amount;

                          for (int i = 0; i < accounts.length; i++) {
                            var typeController = typeProvider[i];

                            var controller = amountControllers[i];
                            var textValue = controller.text;
                            var finalTextValue =
                                double.tryParse(textValue) ?? 0;

                            if (finalTextValue != 0) {
                              if (typeController == '%') {
                                percentageIndices.add(i);
                              } else {
                                amountIndices.add(i);
                              }
                            }
                          }

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
                                content:
                                    Text('Total percentage cannot exceed 100%'),
                              ),
                            );
                          }
                          final ruleIDMake =
                              ref.read(selectedRuleProvider).ruleID;
                          if (ruleIDMake != '') {
                            for (var i in percentageIndices) {
                              var controller = amountControllers[i];
                              var textValue = controller.text;
                              var finalTextValue =
                                  double.tryParse(textValue) ?? 0;
                              var account = accounts[i];
                              double finalPerc = finalTextValue / 100;
                              const amountType = '%';
                              amount = finalPerc.toString();
                              final air = AIRModel(
                                  ruleID: ruleID,
                                  accountTitle: account.accountTitle,
                                  creationDate: DateTime.now().toString(),
                                  amountType: amountType,
                                  accountPortion: amount,
                                  currentAccountAmount: account.amount,
                                  thisPaycheckCut: '0');

                              AccountsForRules().addNewAccountsRule(
                                ref,
                                ruleIDMake,
                                air,
                              );
                            }

                            for (var i in amountIndices) {
                              var controller = amountControllers[i];
                              var textValue = controller.text;
                              var finalTextValue =
                                  double.tryParse(textValue) ?? 0;
                              var account = accounts[i];
                              const amountType = '\$';
                              final format = DateFormat.yMEd();
                              amount = finalTextValue.toString();

                              final air = AIRModel(
                                  ruleID: ruleID,
                                  accountTitle: account.accountTitle,
                                  creationDate:
                                      format.format(DateTime.now()).toString(),
                                  amountType: amountType,
                                  accountPortion: amount,
                                  currentAccountAmount: account.amount,
                                  thisPaycheckCut: '0');

                              AccountsForRules().addNewAccountsRule(
                                ref,
                                ruleIDMake,
                                air,
                              );
                            }
                            ref.read(ruleListProvider.notifier).updateRules(
                                [...ref.read(ruleListProvider), ruleModel]);
                          }
                        } finally {
                          ref.read(selectedRuleProvider.notifier).update(
                                (state) => RuleModel(
                                  ruleTitle: '',
                                  creationDate: '',
                                ),
                              );

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save Rules'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
  return Container();
}
