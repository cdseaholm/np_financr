import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/app_models/air_model.dart';

final accountsInRuleProvider = StateProvider<AccountsForRules>((ref) {
  return AccountsForRules();
});

class AccountsForRules {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<AIRModel> addNewAccountsRule(
    WidgetRef ref,
    String ruleID,
    AIRModel account,
  ) async {
    final air = AIRModel(
        ruleID: ruleID,
        accountTitle: account.accountTitle,
        creationDate: account.creationDate,
        amountType: account.amountType,
        accountPortion: account.accountPortion,
        currentAccountAmount: account.currentAccountAmount,
        thisPaycheckCut: account.thisPaycheckCut);

    await AccountsForRules().addAccountRule(
      ref,
      ruleID,
      air,
    );

    return air;
  }

  Future<DocumentReference<Object?>> addAccountRule(
    WidgetRef ref,
    String ruleID,
    AIRModel account,
  ) async {
    final addedAccountRuleReference = await users
        .doc(userID)
        .collection('Rules')
        .doc(ruleID)
        .collection('Accounts')
        .add(account.toJson());

    final airIDMake = addedAccountRuleReference.id;

    ref.read(accountsInRuleProvider).updateAccountsForRules(
        ref,
        AIRModel(
            docID: airIDMake,
            ruleID: ruleID,
            accountTitle: account.accountTitle,
            creationDate: account.creationDate,
            amountType: account.amountType,
            accountPortion: account.accountPortion,
            currentAccountAmount: account.currentAccountAmount,
            thisPaycheckCut: account.thisPaycheckCut));

    return addedAccountRuleReference;
  }

  Future<void> updateAccountsForRules(
    WidgetRef ref,
    AIRModel model,
  ) async {
    try {
      final accountReference = users
          .doc(userID)
          .collection('Rules')
          .doc(model.ruleID)
          .collection('Accounts')
          .doc(model.docID);

      await accountReference.update(model.toJson());

      ref.read(airUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  Future<void> deleteRule(String userID, String ruleID) async {
    QuerySnapshot accountsInRulesCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Rules')
        .doc(ruleID)
        .collection('Accounts')
        .get();

    for (var accountDoc in accountsInRulesCollection.docs) {
      await accountDoc.reference.delete();
    }
  }
}

var airUpdateStateProvider = StateProvider<AIRModel>((ref) {
  return AIRModel(
      docID: '',
      accountTitle: '',
      creationDate: '',
      ruleID: '',
      amountType: '',
      accountPortion: '',
      currentAccountAmount: '',
      thisPaycheckCut: '');
});
