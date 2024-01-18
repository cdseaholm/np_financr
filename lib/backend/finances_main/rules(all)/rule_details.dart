import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/models/app_models/rule_model.dart';
import 'rule_breakdown.dart';

class RuleDetails extends ConsumerStatefulWidget {
  const RuleDetails({required this.selectedRule, super.key});

  final RuleModel selectedRule;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RuleDetailsState();
}

class _RuleDetailsState extends ConsumerState<RuleDetails> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final airReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Rules')
        .doc(widget.selectedRule.ruleID)
        .collection('Accounts');

    return Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.77,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Rule Breakdown',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade600,
          ),
          const Gap(12),

          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: airReference.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty ||
                        snapshot.data == null) {
                      return const Text(
                          'No Accounts were affected by this Rule.');
                    } else {
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          var data = document.data() as Map<String, dynamic>;
                          String accountTitle =
                              data['accountTitle'] ?? 'No Title';
                          String thisPaycheckCut =
                              data['thisPaycheckCut'] ?? 'No Amount';
                          String accountPortion =
                              data['accountPortion'] ?? 'No Portion';
                          String amountType = data['amountType'] ?? 'No Type';
                          String currentAccountAmount =
                              data['currentAccountAmount'] ?? '0';
                          double roundedPortion = 0;

                          double toRoundPortion = double.parse(accountPortion);
                          if (amountType.contains('%')) {
                            double multipliedPerc = 0;
                            multipliedPerc = toRoundPortion * 100;
                            roundedPortion = double.parse(
                                (multipliedPerc).toStringAsFixed(2));
                          } else {
                            roundedPortion = double.parse(
                                (toRoundPortion).toStringAsFixed(2));
                          }

                          //definitions

                          String combinedamtDefined = 'Remainder of this Check';
                          double roundedCurrentAccountAmount = 0;
                          double roundedRuleCut = 0;

                          //accountTotalAmount

                          double toRoundCurrentAccountAmount =
                              double.parse(currentAccountAmount);
                          roundedCurrentAccountAmount = double.parse(
                              (toRoundCurrentAccountAmount).toStringAsFixed(2));

                          //accountPortion(defines amount to go into account)

                          if (amountType.contains('\$')) {
                            combinedamtDefined = ('$amountType$accountPortion');

                            Text('Amt defined: $amountType$accountPortion');
                          } else if (amountType.contains('%')) {
                            double multipliedPerc = 0;
                            multipliedPerc = toRoundPortion * 100;
                            roundedPortion = double.parse(
                                (multipliedPerc).toStringAsFixed(2));

                            combinedamtDefined = ('$roundedPortion$amountType');
                          } else {
                            combinedamtDefined = 'Remaining on Check';
                          }

                          //thisRuleCut(how much came from therule)

                          double toRoundRuleCut = double.parse(thisPaycheckCut);
                          roundedRuleCut =
                              double.parse((toRoundRuleCut).toStringAsFixed(2));

                          return Column(
                            children: [
                              Row(children: [
                                Text(
                                  accountTitle,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const Expanded(
                                  child: DottedLine(
                                    lineLength: double.infinity,
                                    alignment: WrapAlignment.end,
                                    dashColor: Colors.black38,
                                  ),
                                ),
                                Text(
                                  combinedamtDefined.toString(),
                                  textAlign: TextAlign.end,
                                ),
                              ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: ((context) =>
                                                RuleDetailsBreakdownDialog(
                                                    ruleTitle: accountTitle,
                                                    roundedRuleCut:
                                                        roundedRuleCut,
                                                    combinedamtDefined:
                                                        combinedamtDefined,
                                                    roundedCurrentRuleAmount:
                                                        roundedCurrentAccountAmount)));
                                      },
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 12),
                                      )),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  })),
          const Divider(
            thickness: 1,
            color: Colors.black,
            indent: 25,
            endIndent: 25,
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('Rule Total')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('...'),
              const Gap(10),
              Text('\$${widget.selectedRule.ruleTitle}')
            ],
          ),

          const Gap(12),

          //Button Section

          const Gap(12),

          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const Gap(20),
            Expanded(child: Builder(builder: (context) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Edit This Rule'),
              );
            }))
          ])
        ]));
  }
}
