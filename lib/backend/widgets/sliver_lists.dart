import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/card_provider.dart';
import 'package:np_financr/backend/providers/main_function_providers/rule_provider.dart';

import 'package:np_financr/backend/services/main_function_services/goal_services.dart';
import 'package:np_financr/data/models/app_models/paycheck_model.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';

import '../../data/models/app_models/account_model.dart';
import '../../data/models/app_models/card_model.dart';
import '../../data/models/app_models/goal_model.dart';
import '../../data/models/app_models/rule_model.dart';

class AccountSliverList extends HookConsumerWidget {
  const AccountSliverList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          AccountModel item = accounts[index];
          return SizedBox(
            height: MediaQuery.of(context).size.height / 9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    item.accountTitle,
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    const Gap(20),
                    Transform.scale(
                      scale: 1.5,
                      child: Transform.translate(
                        offset: const Offset(0, -5),
                        child: const Text(
                          '\u2937',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Amount: \$${item.amount}',
                      textAlign: TextAlign.end,
                    ),
                  ],
                )
              ],
            ),
          );
        },
        childCount: accounts.length,
      ),
    );
  }
}

class CardSliverList extends HookConsumerWidget {
  const CardSliverList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardListProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          CardModel item = cards[index];
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(item.cardTitle),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: const Text(
                        '\u2937',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Amount: \$${item.amount}',
                    textAlign: TextAlign.end,
                  ),
                ],
              )
            ],
          );
        },
        childCount: cards.length,
      ),
    );
  }
}

class GoalSliverList extends HookConsumerWidget {
  const GoalSliverList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalListProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          GoalModel item = goals[index];
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(item.goalTitle),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: const Text(
                        '\u2937',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Amount: \$${item.amount}',
                    textAlign: TextAlign.end,
                  ),
                ],
              )
            ],
          );
        },
        childCount: goals.length,
      ),
    );
  }
}

class PaycheckSliverList extends HookConsumerWidget {
  const PaycheckSliverList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paychecks = ref.watch(paycheckListProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          PaycheckModel item = paychecks[index];
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(item.paycheckTitle),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: const Text(
                        '\u2937',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Amount: \$${item.amount}',
                    textAlign: TextAlign.end,
                  ),
                ],
              )
            ],
          );
        },
        childCount: paychecks.length,
      ),
    );
  }
}

class RuleSliverList extends HookConsumerWidget {
  const RuleSliverList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(ruleListProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          RuleModel item = rules[index];
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(item.ruleTitle),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: const Text(
                        '\u2937',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
        childCount: rules.length,
      ),
    );
  }
}
