import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/model_bills.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_monthly_model.dart';

import 'package:np_financr/data/models/app_models/paycheck_model.dart';

import '../../../data/models/app_models/account_model.dart';

import '../../../data/models/app_models/card_model.dart';
import '../../../data/models/app_models/goal_model.dart';
import '../../../data/models/app_models/rule_model.dart';
import '../../../data/models/app_models/updater_model.dart';
import '../../providers/main_function_providers/account_providers/account_edit.dart';
import '../../providers/main_function_providers/account_providers/account_providers.dart';
import '../../providers/main_function_providers/card_provider.dart';
import '../../providers/main_function_providers/rule_provider.dart';
import '../../services/main_function_services/goal_services.dart';
import '../paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import '../../services/main_function_services/services_bills.dart';

class SpecificUpdaterWidget extends StatefulHookConsumerWidget {
  const SpecificUpdaterWidget({required this.toUpdate, super.key});

  final String toUpdate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecificUpdaterWidgetState();
}

class _SpecificUpdaterWidgetState extends ConsumerState<SpecificUpdaterWidget> {
  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountListProvider);
    final cards = ref.watch(cardListProvider);
    final rules = ref.watch(ruleListProvider);
    final goals = ref.watch(goalListProvider);
    final paychecks = ref.watch(paycheckListProvider);
    //final preUsed = [];
    final bills = ref.watch(billDetailsListProvider);
    var updateTitle = 'Accounts';

    List<UpdaterModel> merged(
        List<AccountModel> accounts,
        List<CardModel> cards,
        List<GoalModel> goals,
        List<PaycheckModel> paychecks,
        List<RuleModel> rules,
        List<BillDetailsModel> bills) {
      List<UpdaterModel> result = [];

      try {
        if (widget.toUpdate == 'Accounts') {
          result.addAll(accounts.map((e) => UpdaterModel(
              updaterTitle: e.accountTitle,
              updaterAmount: e.amount,
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Accounts';
          });
        } else if (widget.toUpdate == 'Cards') {
          result.addAll(cards.map((e) => UpdaterModel(
              updaterTitle: e.cardTitle,
              updaterAmount: e.amount,
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Cards';
          });
        } else if (widget.toUpdate == 'Goals') {
          result.addAll(goals.map((e) => UpdaterModel(
              updaterTitle: e.goalTitle,
              updaterAmount: e.amount,
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Goals';
          });
        } else if (widget.toUpdate == 'Paychecks') {
          result.addAll(paychecks.map((e) => UpdaterModel(
              updaterTitle: e.paycheckTitle,
              updaterAmount: e.amount,
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Paychecks';
          });
        } else if (widget.toUpdate == 'Rules') {
          result.addAll(rules.map((e) => UpdaterModel(
              updaterTitle: e.ruleTitle,
              updaterAmount: '',
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Rules';
          });
        } else if (widget.toUpdate == 'Bills') {
          result.addAll(bills.map((e) => UpdaterModel(
              updaterTitle: e.billTitle,
              updaterAmount: '',
              updatedDate: e.creationDate)));
          setState(() {
            updateTitle = 'Bills';
          });
        }
      } finally {}

      return result;
    }

    List<UpdaterModel> common =
        merged(accounts, cards, goals, paychecks, rules, bills).toList();

    return AlertDialog(
      scrollable: true,
      title: Column(children: [Text(updateTitle)]),
      backgroundColor: Colors.white,
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
            )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in common)
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 10,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              border: Border.symmetric(
                                  vertical: BorderSide(),
                                  horizontal: BorderSide())),
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.transparent,
                                          ),
                                          alignment: Alignment.centerLeft),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Container();
                                          },
                                        );
                                      },
                                      child: Text(
                                        item.updaterTitle,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 0),
                                        child: Text(item.updaterAmount)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                      ],
                    ),
                  const Divider(
                      thickness: 1,
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10),
                ],
              ),
            ),
          ),
          const Gap(5),
          if (accounts.length.toInt() > 3)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scroll for more',
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          else if (cards.length.toInt() > 3)
            const Divider(
                thickness: 1, color: Colors.black, indent: 10, endIndent: 10),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                ref.read(toUpdateProvider.notifier).update((state) => []);
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  EditAccount().editAccountDialog(context, ref);
                } finally {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
