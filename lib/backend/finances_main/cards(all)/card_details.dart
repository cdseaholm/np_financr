import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/card_model.dart';
import 'card_breakdown_details.dart';

class CardDetails extends ConsumerStatefulWidget {
  const CardDetails({required this.selectedCard, super.key});

  final CardModel selectedCard;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardDetailsState();
}

class _CardDetailsState extends ConsumerState<CardDetails> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final airReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Cards')
        .doc(widget.selectedCard.docID)
        .collection(widget.selectedCard.cardTitle);

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
              'Card Breakdown',
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
                      return const Text('No Cards were affected by this Card.');
                    } else {
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          var data = document.data() as Map<String, dynamic>;
                          String cardTitle = data['cardTitle'] ?? 'No Title';
                          String thisCardCut =
                              data['thisCardCut'] ?? 'No Amount';
                          String cardPortion =
                              data['cardPortion'] ?? 'No Portion';
                          String amountType = data['amountType'] ?? 'No Type';
                          String currentCardAmount =
                              data['currentCardAmount'] ?? '0';
                          double roundedPortion = 0;

                          double toRoundPortion = double.parse(cardPortion);
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
                          double roundedCurrentCardAmount = 0;
                          double roundedCardCut = 0;

                          //cardTotalAmount

                          double toRoundCurrentCardAmount =
                              double.parse(currentCardAmount);
                          roundedCurrentCardAmount = double.parse(
                              (toRoundCurrentCardAmount).toStringAsFixed(2));

                          //cardPortion(defines amount to go into card)

                          if (amountType.contains('\$')) {
                            combinedamtDefined = ('$amountType$cardPortion');

                            Text('Amt defined: $amountType$cardPortion');
                          } else if (amountType.contains('%')) {
                            double multipliedPerc = 0;
                            multipliedPerc = toRoundPortion * 100;
                            roundedPortion = double.parse(
                                (multipliedPerc).toStringAsFixed(2));

                            combinedamtDefined = ('$roundedPortion$amountType');
                          } else {
                            combinedamtDefined = 'Remaining on Check';
                          }

                          //thisCardCut(how much came from thecard)

                          double toRoundCardCut = double.parse(thisCardCut);
                          roundedCardCut =
                              double.parse((toRoundCardCut).toStringAsFixed(2));

                          return Column(
                            children: [
                              Row(children: [
                                Text(
                                  cardTitle,
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
                                                CardDetailsBreakdownDialog(
                                                    cardTitle: cardTitle,
                                                    roundedCardCut:
                                                        roundedCardCut,
                                                    combinedamtDefined:
                                                        combinedamtDefined,
                                                    roundedCurrentCardAmount:
                                                        roundedCurrentCardAmount)));
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
            children: [Text('Card Total')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('...'),
              const Gap(10),
              Text('\$${widget.selectedCard.amount}')
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
                child: const Text('Edit This Card'),
              );
            }))
          ])
        ]));
  }
}
