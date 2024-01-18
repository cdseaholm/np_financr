// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';
import '../../../backend/finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import '../../../backend/providers/main_function_providers/account_providers/account_providers.dart';
import '../../../backend/providers/main_function_providers/card_provider.dart';
import '../../../backend/providers/main_function_providers/rule_provider.dart';
import '../../../backend/services/main_function_services/goal_services.dart';
import '../../../backend/widgets/homepage/list_view_all_home_builder.dart';
import '../../../data/models/app_models/card_model.dart';

class AllHomeView extends StatefulHookConsumerWidget {
  const AllHomeView({required this.getIndex, Key? key}) : super(key: key);

  final int getIndex;

  @override
  _AllHomeViewState createState() => _AllHomeViewState();
}

class _AllHomeViewState extends ConsumerState<AllHomeView> {
  bool isExpanded = false;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerList = [
      'accounts',
      'cards',
      'goals',
      'reports',
      'paychecks',
      'rules'
    ];
    final cards = ref.watch(cardListProvider);
    var currentCard = providerList[widget.getIndex];
    final paychecks = ref.watch(paycheckListProvider);
    final accounts = ref.watch(accountListProvider);
    final rules = ref.watch(ruleListProvider);
    final goals = ref.watch(goalListProvider);
    Icon iconToUse = const Icon(Icons.account_circle);
    final reports = ref.watch(monthlyUpdateListProvider);
    //var colorToUse = const Color.fromARGB(255, 76, 119, 85);
    var titleToUse = 'Accounts';

    if (currentCard == 'accounts') {
      iconToUse = const Icon(Icons.account_circle);
      //colorToUse = const Color.fromARGB(255, 185, 89, 60);
      titleToUse = 'Accounts';
    } else if (currentCard == 'cards') {
      iconToUse = const Icon(Icons.credit_card);
      //colorToUse = const Color.fromARGB(255, 76, 108, 196);
      titleToUse = 'Cards';
    } else if (currentCard == 'goals') {
      iconToUse = const Icon(Icons.check_box_outlined);

      //colorToUse = const Color.fromARGB(255, 173, 216, 103);
      titleToUse = 'Goals';
    } else if (currentCard == 'reports') {
      iconToUse = const Icon(Icons.report);

      //colorToUse = const Color.fromARGB(209, 253, 60, 34);
      titleToUse = 'Monthly Reports';
    } else if (currentCard == 'paychecks') {
      iconToUse = const Icon(Icons.payments);

      //colorToUse = const Color.fromARGB(255, 141, 87, 148);
      titleToUse = 'Paychecks';
    } else if (currentCard == 'rules') {
      iconToUse = const Icon(Icons.rule);

      //colorToUse = const Color.fromARGB(192, 3, 155, 104);
      titleToUse = 'Rules';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
            isClicked = !isClicked;
          });
        },
        child: ExpansionTile(
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  iconToUse,
                  const Gap(5),
                  Text(
                    titleToUse,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          children: [
            SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      border: Border.all(color: Colors.black, width: .5)),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ListViewAllHomeCardsBuilder(
                                  accounts: accounts,
                                  currentCard: currentCard,
                                  cards: cards,
                                  goals: goals,
                                  paychecks: paychecks,
                                  reports: reports,
                                  rules: rules),
                            )
                          ]),
                    )
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> moneyCount(String currentCard) async {
  String totalAmount = '0';

  if (currentCard == 'accounts') {
    totalAmount = await fetchData('accounts');
  } else if (currentCard == 'cards') {
    totalAmount = await fetchData('cards');
  } else if (currentCard == 'goals') {
    totalAmount = await fetchData('goals');
  } else if (currentCard == 'paychecks') {
    totalAmount = await fetchData('paychecks');
  } else if (currentCard == 'rules') {
    totalAmount = await fetchData('rules');
  }

  return totalAmount;
}

Future<List<String>> loadArray(CardModel paycheck) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Cards')
        .doc(paycheck.docID)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey('repeatingDays') &&
          data['repeatingDays'] is List<dynamic>) {
        var repeatingDaysArray = data['repeatingDays'] as List<dynamic>;

        List<String> array = [];

        for (var day in repeatingDaysArray) {
          if (day is String) {
            array.add(day);
          }
        }

        return array;
      }
    }

    return [];
  } catch (e) {
    return [];
  }
}

Future<String> fetchData(String category) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  var snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection(category)
      .get();

  var totalAmount = 0.0;

  for (var doc in snapshot.docs) {
    totalAmount += double.parse(doc['amount'] ?? '0');
  }

  return totalAmount.toString();
}
