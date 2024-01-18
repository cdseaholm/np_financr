import 'package:flutter/material.dart';
import 'package:np_financr/data/models/app_models/model_monthly_update.dart';

import '../../../data/models/app_models/account_model.dart';
import '../../../data/models/app_models/card_model.dart';
import '../../../data/models/app_models/goal_model.dart';
import '../../../data/models/app_models/rule_model.dart';
import '../../finances_main/cards(all)/card_details.dart';

import '../../../data/models/app_models/paycheck_model.dart';

class ListViewAllHomeCardsBuilder extends StatelessWidget {
  const ListViewAllHomeCardsBuilder({
    super.key,
    required this.accounts,
    required this.currentCard,
    required this.cards,
    required this.goals,
    required this.paychecks,
    required this.reports,
    required this.rules,
  });

  final List<AccountModel> accounts;
  final String currentCard;
  final List<CardModel> cards;
  final List<GoalModel> goals;
  final List<PaycheckModel> paychecks;
  final List<MonthlyUpdateModel> reports;
  final List<RuleModel> rules;

  @override
  Widget build(BuildContext context) {
    if (currentCard == 'accounts') {
      for (var account in accounts) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        account.accountTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              account.amount,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      }
    } else if (currentCard == 'cards') {
      for (var card in cards) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        card.cardTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              card.amount,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      }
    } else if (currentCard == 'paychecks') {
      for (var paycheck in paychecks) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        paycheck.paycheckTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              paycheck.amount,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      }
    } else if (currentCard == 'goals') {
      for (var goal in goals) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        goal.goalTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              goal.amount,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      }
    } else if (currentCard == 'rules') {
      for (var rule in rules) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        rule.ruleTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Text(
              '',
              style: TextStyle(fontSize: 18),
            ),
          ],
        );
      }
    } else if (currentCard == 'reports') {
      for (var report in reports) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            context: context,
                            builder: (context) {
                              return Container();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                        )),
                    TextButton(
                      onPressed: () async {
                        // Handle text button press
                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => CardDetails(
                            selectedCard: CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        report.monthlyModelTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  report.datemonthlyModel,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(report.creationDate,
                    style: const TextStyle(fontSize: 14, color: Colors.black38))
              ],
            ),
          ],
        );
      }

      return Container();
    }
    return Container();
  }
}
