import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_financr/data/models/app_models/paycheck_model.dart';

import 'paycheck_breakdown_dialog.dart';

class PaycheckDetails extends ConsumerStatefulWidget {
  const PaycheckDetails({required this.selectedPaycheck, super.key});

  final PaycheckModel selectedPaycheck;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaycheckDetailsState();
}

class _PaycheckDetailsState extends ConsumerState<PaycheckDetails> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final airReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Paychecks')
        .doc(widget.selectedPaycheck.docID)
        .collection(widget.selectedPaycheck.ruleName);

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
              'Paycheck Breakdown',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
            indent: 10,
            endIndent: 10,
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
                          'No Accounts were affected by this Paycheck.');
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
                          double roundedPaycheckCut = 0;

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

                          //thisPaycheckCut(how much came from thepaycheck)

                          double toRoundPaycheckCut =
                              double.parse(thisPaycheckCut);
                          roundedPaycheckCut = double.parse(
                              (toRoundPaycheckCut).toStringAsFixed(2));

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
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
                                                  PaycheckDetailsBreakdownDialog(
                                                      accountTitle:
                                                          accountTitle,
                                                      roundedPaycheckCut:
                                                          roundedPaycheckCut,
                                                      combinedamtDefined:
                                                          combinedamtDefined,
                                                      roundedCurrentAccountAmount:
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
                            ),
                          );
                        }).toList(),
                      );
                    }
                  })),
          const Divider(
            thickness: 1,
            color: Colors.black,
            indent: 10,
            endIndent: 10,
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('Paycheck Total')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('...'),
              const Gap(10),
              Text(
                '\$${widget.selectedPaycheck.amount}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
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
                child: const Text('Edit This Paycheck'),
              );
            }))
          ])
        ]));
  }
}
