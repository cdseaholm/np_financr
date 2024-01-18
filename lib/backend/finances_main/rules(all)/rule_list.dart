import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/rule_model.dart';
import '../../../main.dart';

import 'rule_view.dart';
import '../../providers/main_function_providers/rule_provider.dart';
import '../../providers/main_function_providers/selected_rule_providers.dart';

class RuleList extends ConsumerWidget {
  const RuleList({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(ruleListProvider);
    final userID = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: rules.asMap().entries.map((entry) {
        final rule = entry.value;
        String? ruleID;
        if (rule.ruleID != '') {
          ruleID = rule.ruleID;
        }

        return StreamBuilder<QuerySnapshot?>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .collection('Rules')
                .doc(ruleID)
                .collection('Accounts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              int count = snapshot.data!.docs.length;
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          rule.ruleTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('$count'),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  if (previousPage == PreviousPage.newPaycheck) {
                    ref
                        .read(selectedRuleProvider.notifier)
                        .update((state) => RuleModel(
                              ruleTitle: rule.ruleTitle,
                              ruleID: rule.ruleID,
                              creationDate: rule.creationDate,
                            ));

                    Navigator.of(context).pop(true);
                  } else if (previousPage == PreviousPage.manager) {
                    ref
                        .read(selectedRuleProvider.notifier)
                        .update((state) => RuleModel(
                              ruleTitle: rule.ruleTitle,
                              ruleID: rule.ruleID,
                              creationDate: rule.creationDate,
                            ));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return EditView(context, ref,
                              previousPage: previousPage);
                        });

                    (child: EditView(context, ref, previousPage: previousPage));
                  }
                },
              );
            });
      }).toList(),
    );
  }

  int airSizeMethod(airLength, QuerySnapshot<Object?> airSnapshot) =>
      airLength = airSnapshot.size;
}
