import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/main.dart';
import '../../../data/models/app_models/card_model.dart';
import '../../providers/main_function_providers/account_providers/account_service_provider.dart';
import '../../providers/main_function_providers/card_provider.dart';

class CardList extends ConsumerWidget {
  const CardList({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardListProvider);
    final userID = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: cards.asMap().entries.map((entry) {
        final card = entry.value;
        return ListTile(
          leading: IconButton(
              icon: const Icon(CupertinoIcons.trash),
              onPressed: () {
                ref
                    .read(updateaccountProvider)
                    .deleteAccount(userID!, card.docID);
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                card.cardTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          onTap: () async {
            if (previousPage == PreviousPage.newPaycheck) {
              ref
                  .read(selectedCardProvider.notifier)
                  .update((state) => CardModel(
                        cardTitle: card.cardTitle,
                        description: card.description,
                        docID: card.docID,
                        amount: card.amount,
                        creationDate: card.creationDate,
                      ));
            }
            Navigator.of(context).pop(true);
          },
        );
      }).toList(),
    );
  }
}
