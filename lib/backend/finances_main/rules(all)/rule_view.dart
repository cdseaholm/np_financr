import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/air_model.dart';
import 'package:np_financr/main.dart';

import '../../../data/models/app_models/account_model.dart';
import '../../../data/models/app_models/rule_model.dart';
import '../../widgets/number_file_widget.dart';

import '../../providers/main_function_providers/account_providers/account_edit.dart';
import '../../providers/main_function_providers/account_providers/account_providers.dart';

import '../../services/main_function_services/air_services.dart';

import '../../providers/main_function_providers/selected_rule_providers.dart';

class EditView extends ConsumerStatefulWidget {
  const EditView(BuildContext context, WidgetRef ref,
      {required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final accounts = ref.watch(accountListProvider);
    final ruleID = ref.watch(selectedRuleProvider).ruleID;
    final List<TextEditingController> accountControllers = List.generate(
      accounts.length,
      (index) => TextEditingController(),
    );

    final List<String> dropdownValuesProvider =
        List.generate(accounts.length, (index) => '\$');

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID!)
            .collection('Accounts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final firebasePercentages = <String, String>{};

          for (final doc in snapshot.data!.docs) {
            final accountTitle = doc['accountTitle'] as String;
            final percentage = doc['accountPercentage'] as String;

            firebasePercentages[accountTitle] = percentage;
          }
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
                              final controller = accountControllers[index];

                              if (firebasePercentages
                                  .containsKey(account.accountTitle)) {
                                final initialValue =
                                    firebasePercentages[account.accountTitle] ??
                                        '0';
                                controller.text = initialValue;
                              } else {
                                controller.text = '0';
                              }

                              return Row(
                                textBaseline: TextBaseline.ideographic,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        txtController:
                                            accountControllers[index],
                                        selectedType:
                                            dropdownValuesProvider[index],
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
                        onPressed: () {
                          double finalValue = 0;
                          List<int> nonBlankIndices = [];
                          List<String> formattedValues = [];
                          for (int i = 0; i < accounts.length; i++) {
                            var controller = accountControllers[i];
                            var textValue = controller.text;
                            var percentage = double.tryParse(textValue) ?? 0;
                            late String amountType;

                            if (finalValue > 100) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Total percentage cannot exceed 100%'),
                                ),
                              );
                            } else {
                              final accountList = <AccountModel>[];
                              for (var index in nonBlankIndices) {
                                accountList.add(accounts[index]);
                              }

                              // Continue with the saving logic
                              final accountsForRules = AccountsForRules();
                              for (var i = 0; i < accountList.length; i++) {
                                if (percentage != 0) {
                                  nonBlankIndices.add(i);
                                  if (dropdownValuesProvider[i] == '\$') {
                                    amountType = '\$';
                                  } else if (dropdownValuesProvider[i] == '%') {
                                    finalValue += percentage;
                                    amountType = '%';
                                  } else {
                                    formattedValues.add(
                                        ''); // Set an empty string if neither '$' nor '%'.
                                  }
                                }
                              }
                              var account = accountList[i];
                              var air = AIRModel(
                                  ruleID: ruleID,
                                  accountTitle: account.accountTitle,
                                  creationDate: account.creationDate,
                                  amountType: amountType,
                                  accountPortion: accountControllers[i].text,
                                  currentAccountAmount: account.amount,
                                  thisPaycheckCut: '0');

                              account = account.copyWith();
                              accountsForRules.addNewAccountsRule(
                                ref,
                                ruleID,
                                air,
                              );
                            }

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
  }
}
