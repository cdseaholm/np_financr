import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../data/models/app_models/paycheck_model.dart';

import 'paycheck_providers.dart';

//state providers

final dateProvider = StateProvider<String>((ref) {
  return 'mm/dd/yy';
});

final timeProvider = StateProvider<String>((ref) {
  return 'hh:mm';
});

final ruleOptions = StateProvider<List<String>>((ref) {
  return [];
});

final accountOptions = StateProvider<List<String>>((ref) {
  return [];
});

final stopDateProvider = StateProvider<String>((ref) {
  return 'Until?';
});

final repeatShownProvider = StateProvider<String>((ref) {
  return 'No';
});

//Category/paychecks fetching

final fetchPaychecks =
    StreamProvider.autoDispose<List<PaycheckModel>>((ref) async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final paycheckCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Paychecks');

  final paychecksSnapshot = await paycheckCollection.get();
  var paychecks = <PaycheckModel>[];
  paychecks.addAll(paychecksSnapshot.docs.map((paycheckDoc) {
    final paycheckData = paycheckDoc.data();
    return PaycheckModel(
      docID: paycheckDoc.id,
      paycheckTitle: paycheckData['paycheckTitle'] ?? '',
      description: paycheckData['description'] ?? '',
      datepaycheck: paycheckData['datepaycheck'] ?? '',
      ruleID: paycheckData['ruleID'] ?? '',
      ruleName: paycheckData['ruleName'] ?? '',
      amount: paycheckData['amount'] ?? '',
      selectedAccount: paycheckData['selectedAccount'] ?? '',
      creationDate: paycheckData['creationDate'] ?? '',
    );
  }));
  ref.read(paycheckListProvider.notifier).updatepaychecks(paychecks);
});

//update paycheck

final updatepaycheckProvider = Provider((ref) => UpdatepaycheckService());

class UpdatepaycheckService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PaycheckModel?> updatepaycheckFields({
    required String userID,
    required String paycheckID,
    String? newTitle,
    String? newDescription,
    String? newAmount,
    String? newDate,

    // Add other fields here as needed
  }) async {
    final paycheckRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Paychecks')
        .doc(paycheckID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['paycheckTitle'] = newTitle;
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

    await paycheckRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await paycheckRef.get();
    final updatedpaycheckData = updatedDoc.data() as Map<String, dynamic>;
    final updatedpaycheck = PaycheckModel.fromJson(updatedpaycheckData);

    return updatedpaycheck;
  }
}

final valueForRuleProvider = StateProvider<String>((ref) {
  return '0';
});
