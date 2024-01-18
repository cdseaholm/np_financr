import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/models/app_models/card_model.dart';
import '../../providers/main_function_providers/card_provider.dart';

Future<CardModel?> addCard(
    BuildContext context,
    WidgetRef ref,
    String description,
    String cardTitle,
    String creationDate,
    String amount,
    String amountType,
    String cardPortion) async {
  final userCreatedCardModel = CardModel(
    cardTitle: cardTitle,
    description: description,
    creationDate: creationDate,
    amount: amount,
  );

  try {
    if (cardTitle.isNotEmpty) {
      final addedCardReference =
          await CardServices().addNewCard(ref, userCreatedCardModel);

      final cardIDMake = addedCardReference.id;

      ref.read(selectedCardProvider.notifier).state = CardModel(
        docID: cardIDMake,
        cardTitle: userCreatedCardModel.cardTitle,
        description: userCreatedCardModel.description,
        creationDate: userCreatedCardModel.creationDate,
        amount: userCreatedCardModel.amount,
      );

      return userCreatedCardModel;
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    return userCreatedCardModel;
  } catch (e) {
    return null;
  }
}

final updateCardProvider = Provider((ref) => UpdateCardService());

class UpdateCardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CardModel?> updateCardFields({
    required String userID,
    required String cardID,
    String? newTitle,
    String? newDescription,
    String? newAmount,
    String? newDate,

    // Add other fields here as needed
  }) async {
    final cardRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Cards')
        .doc(cardID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['cardTitle'] = newTitle;
    }

    if (newDescription != null) {
      updatedFields['description'] = newDescription;
    }

    if (newAmount != null) {
      updatedFields['amount'] = newAmount;
    }

    if (newDate != null) {
      updatedFields['datepaycheck'] = newDate;
    }

    await cardRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await cardRef.get();
    final updatedCardData = updatedDoc.data() as Map<String, dynamic>;
    final updatedCard = CardModel.fromJson(updatedCardData);

    return updatedCard;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
