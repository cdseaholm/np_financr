import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/card_model.dart';

class CardListNotifier extends StateNotifier<List<CardModel>> {
  CardListNotifier() : super([]);

  Future<void> updateCards(List<CardModel> cards) async {
    state = cards;
  }

  Future<void> removeCards(CardModel card) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != card.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Cards')
        .doc(card.docID)
        .delete();
  }
}

//services

final cardListProvider =
    StateNotifierProvider<CardListNotifier, List<CardModel>>(
        (ref) => CardListNotifier());

final serviceProvider = StateProvider<CardServices>((ref) {
  return CardServices();
});

var cardUpdateStateProvider = StateProvider<CardModel>((ref) {
  return CardModel(
    docID: '',
    cardTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});

class CardServices {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewCard(
      WidgetRef ref, CardModel model) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final addedCardReference =
        await users.doc(userID).collection('Cards').add(model.toJson());

    final cardIDMake = addedCardReference.id;

    CardServices().updateCard(
        ref,
        CardModel(
          docID: cardIDMake,
          cardTitle: model.cardTitle,
          description: model.description,
          creationDate: model.creationDate,
          amount: model.amount,
        ));

    return addedCardReference;
  }

  // UPDATE

  void updateCardsList(WidgetRef ref, CardModel updatedCard) {
    final cardsToUpdate = ref.read(cardListProvider);
    final updatedCards = <CardModel>[];

    for (var card in cardsToUpdate) {
      if (card.docID == updatedCard.docID) {
        updatedCards.add(updatedCard);
      } else {
        updatedCards.add(card);
      }
    }

    ref
        .read(cardListProvider.notifier)
        .updateCards([...ref.read(cardListProvider)]);
  }

  Future<void> updateCard(
    WidgetRef ref,
    CardModel model,
  ) async {
    try {
      final userID = FirebaseAuth.instance.currentUser?.uid;
      final cardReference =
          users.doc(userID).collection('Cards').doc(model.docID);

      await cardReference.update(model.toJson());

      ref.read(cardUpdateRadioProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  // UPDATE

  updateProviders(CardModel card, WidgetRef ref) async {
    ref.read(selectedCardProvider.notifier).state = CardModel(
      cardTitle: card.cardTitle,
      description: card.description,
      creationDate: card.creationDate,
      amount: card.amount,
    );
  }
}

final fetchCards = StreamProvider.autoDispose<List<CardModel>>((ref) {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final cardCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Cards');

  final Stream<QuerySnapshot> cardStream = cardCollection.snapshots();

  return cardStream.asyncMap((cardSnapshot) {
    var cards = <CardModel>[];
    for (final cardDoc in cardSnapshot.docs) {
      final cardData = cardDoc.data() as Map<String, dynamic>;
      cards.add(CardModel(
        docID: cardDoc.id,
        cardTitle: cardData['cardTitle'] as String? ?? '',
        description: cardData['description'] as String? ?? '',
        creationDate: cardData['creationDate'] as String? ?? '',
        amount: cardData['amount'] as String? ?? '',
      ));
    }

    ref.read(cardListProvider.notifier).updateCards(cards);
    return cards;
  });
});

class SelectedAccount {
  final CardModel model;

  SelectedAccount({required this.model});
}

final selectedCardProvider = StateProvider<CardModel>((ref) {
  return CardModel(
    docID: '',
    cardTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});

final cardUpdateRadioProvider = StateProvider<CardModel>((ref) {
  return CardModel(
    docID: '',
    cardTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});
