// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/finances_main/rules(all)/rule_edit.dart';
import 'package:np_financr/backend/providers/main_function_providers/rule_provider.dart';
import '../../../backend/finances_main/rules(all)/rule_details.dart';
import '../../../data/models/app_models/rule_model.dart';

class RuleToolListWidget extends ConsumerStatefulWidget {
  const RuleToolListWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RuleToolListWidgetState();
}

class _RuleToolListWidgetState extends ConsumerState<RuleToolListWidget> {
  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(ruleListProvider);
    var currentRule = rules[widget.getIndex];

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: .5)),
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: BorderSide.strokeAlignCenter),
                            maximumSize: const Size(80, 45),
                            backgroundColor: const Color(0xFFD5E8FA),
                            foregroundColor: Colors.blue.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1, color: Colors.black12))),
                        onPressed: () async {
                          await showModalBottomSheet(
                              showDragHandle: true,
                              isDismissible: false,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              context: context,
                              builder: (context) => const EditRule());
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text(
                        currentRule.ruleTitle,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      trailing: ElevatedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              showDragHandle: true,
                              isDismissible: false,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              context: context,
                              builder: (context) =>
                                  RuleDetails(selectedRule: currentRule),
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(
                              Size(MediaQuery.of(context).size.width / 5.8,
                                  MediaQuery.of(context).size.height / 22),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color(0xFFD5E8FA)),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue.shade800),
                            elevation: const MaterialStatePropertyAll(0),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1, color: Colors.black12))),
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(fontSize: 12),
                          ))),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1.5,
                          color: Colors.black38,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(children: [
                              Text(
                                  'Accounts Affected: ${rules.length.toString()}')
                            ]),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ))
        ]));
  }
}

Future<List<String>> loadArray(RuleModel rule) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Rules')
        .doc(rule.ruleID)
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
