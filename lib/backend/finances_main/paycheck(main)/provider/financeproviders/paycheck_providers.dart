import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/data/models/app_models/air_model.dart';
import 'package:np_financr/backend/services/main_function_services/air_services.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';
import '../../../../../data/models/app_models/account_model.dart';
import '../../../../../data/models/app_models/paycheck_model.dart';

//notifier providers

class FinanceListNotifier extends StateNotifier<List<PaycheckModel>> {
  FinanceListNotifier() : super([]);

  void updatepaychecks(List<PaycheckModel> paychecks) async {
    state = paychecks;
  }

  void removepaycheck(PaycheckModel paycheck) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != paycheck.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Paychecks')
        .doc(paycheck.docID)
        .delete();
  }
}

//services

final paycheckListProvider =
    StateNotifierProvider<FinanceListNotifier, List<PaycheckModel>>(
        (ref) => FinanceListNotifier());

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});

var paycheckUpdateStateProvider = StateProvider<PaycheckModel>((ref) {
  return PaycheckModel(
    paycheckTitle: '',
    description: '',
    datepaycheck: '',
    ruleID: '',
    ruleName: '',
    amount: '',
    selectedAccount: '',
    creationDate: '',
  );
});

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewpaycheck(
      WidgetRef ref, PaycheckModel model, String userID) async {
    double totalPayCheckAmount = double.tryParse(model.amount) ?? 0;
    double runningAmountTracker = 0;
    List<AIRModel> finalAccountsInRule = [];
    List<AIRModel> percentageAccounts = [];
    List<AIRModel> fixedAmountAccounts = [];
    AIRModel? remainderAccount;
    late String selectedAccountForPaycheck;
    final selectedAccount = ref.read(selectedAccountProvider);
    final mainAccountReference = users.doc(userID).collection('Accounts');
    final airReference = users
        .doc(userID)
        .collection('Rules')
        .doc(model.ruleID)
        .collection('Accounts');
    final airSnapshot = await airReference.get();
    try {
      for (final airDoc in airSnapshot.docs) {
        final airData = airDoc.data();
        final air = AIRModel(
          docID: airDoc.id,
          ruleID: airData['ruleID'] as String? ?? '',
          accountTitle: airData['accountTitle'] as String? ?? '',
          creationDate: airData['creationDate'] as String? ?? '',
          amountType: airData['amountType'] as String? ?? '',
          accountPortion: airData['accountPortion'],
          currentAccountAmount:
              airData['currentAccountAmount'] as String? ?? '',
          thisPaycheckCut: airData['thisPaycheckCut'] as String? ?? '',
        );

        if (air.amountType.contains('%')) {
          percentageAccounts.add(air);
        } else if (air.amountType.contains('-{r}-')) {
          remainderAccount = air;
        } else {
          fixedAmountAccounts.add(air);
        }
      }

      for (var percentageAccount in percentageAccounts) {
        late double mainAmountInt;
        double percentage =
            double.tryParse(percentageAccount.accountPortion) ?? 0;
        double mainAmount =
            double.tryParse(percentageAccount.currentAccountAmount) ?? 0;

        double allocatedAmount = (totalPayCheckAmount * percentage);

        runningAmountTracker = runningAmountTracker + allocatedAmount;
        mainAmountInt = (mainAmount + allocatedAmount);
        final percAIR = AIRModel(
            docID: percentageAccount.docID,
            ruleID: percentageAccount.ruleID,
            accountTitle: percentageAccount.accountTitle,
            creationDate: percentageAccount.creationDate,
            amountType: '%',
            accountPortion: percentageAccount.accountPortion,
            currentAccountAmount: mainAmountInt.toString(),
            thisPaycheckCut: allocatedAmount.toString());

        await AccountsForRules().updateAccountsForRules(ref, percAIR);
        finalAccountsInRule.add(percAIR);

        final QuerySnapshot querySnapshot = await mainAccountReference
            .where('accountTitle', isEqualTo: percentageAccount.accountTitle)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot matchingDoc = querySnapshot.docs.first;
          final String matchingDocID = matchingDoc.id;

          await mainAccountReference.doc(matchingDocID).update({
            'amount': mainAmountInt.toString(),
          });
        }
      }

      for (var fixedAmountAccount in fixedAmountAccounts) {
        late double mainAmountInt;
        double fixedAmount =
            double.tryParse(fixedAmountAccount.accountPortion) ?? 0;
        double mainAmount =
            double.tryParse(fixedAmountAccount.currentAccountAmount) ?? 0;
        mainAmountInt = (mainAmount + fixedAmount);
        runningAmountTracker = runningAmountTracker + fixedAmount;

        final fixedAIR = AIRModel(
            docID: fixedAmountAccount.docID,
            ruleID: fixedAmountAccount.ruleID,
            accountTitle: fixedAmountAccount.accountTitle,
            creationDate: fixedAmountAccount.creationDate,
            amountType: '\$',
            accountPortion: fixedAmountAccount.accountPortion,
            currentAccountAmount: mainAmountInt.toString(),
            thisPaycheckCut: fixedAmount.toString());
        await AccountsForRules().updateAccountsForRules(ref, fixedAIR);
        finalAccountsInRule.add(fixedAIR);

        final QuerySnapshot querySnapshot = await mainAccountReference
            .where('accountTitle', isEqualTo: fixedAmountAccount.accountTitle)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot matchingDoc = querySnapshot.docs.first;
          final String matchingDocID = matchingDoc.id;

          await mainAccountReference.doc(matchingDocID).update({
            'amount': mainAmountInt.toString(),
          });
        }
      }
    } finally {
      if (remainderAccount == null &&
          selectedAccount !=
              AccountModel(
                  accountTitle: '',
                  description: '',
                  creationDate: '',
                  amount: '')) {
        final amt = double.tryParse(selectedAccount.amount);
        late double selectedAmount;
        if (amt != null) {
          selectedAmount = runningAmountTracker + amt;
        }
        selectedAccountForPaycheck =
            'Remainder went to: ${model.selectedAccount}';
        final remainderA = AccountModel(
            docID: selectedAccount.docID,
            accountTitle: selectedAccount.accountTitle,
            description: selectedAccount.description,
            creationDate: selectedAccount.creationDate,
            amount: selectedAmount.toString());

        final QuerySnapshot querySnapshot = await mainAccountReference
            .where('accountTitle', isEqualTo: remainderA.accountTitle)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot matchingDoc = querySnapshot.docs.first;
          final String matchingDocID = matchingDoc.id;

          await mainAccountReference.doc(matchingDocID).update({
            'amount': remainderA.amount.toString(),
          });
        }
      }
      if (remainderAccount != null) {
        late double mainAmountInt;
        double mainAmount =
            double.tryParse(remainderAccount.currentAccountAmount) ?? 0;
        double amount = double.tryParse(model.amount) ?? 0;
        double remainingAmount = (amount - runningAmountTracker);
        mainAmountInt = (mainAmount + remainingAmount);
        selectedAccountForPaycheck = model.selectedAccount;

        final remainderAIR = AIRModel(
            docID: remainderAccount.docID,
            ruleID: remainderAccount.ruleID,
            accountTitle: remainderAccount.accountTitle,
            creationDate: remainderAccount.creationDate,
            amountType: '-{r}-',
            accountPortion: remainderAccount.accountPortion,
            currentAccountAmount: mainAmountInt.toString(),
            thisPaycheckCut: remainingAmount.toString());
        await AccountsForRules().updateAccountsForRules(ref, remainderAIR);
        finalAccountsInRule.add(remainderAIR);
        final QuerySnapshot querySnapshot = await mainAccountReference
            .where('accountTitle', isEqualTo: remainderAccount.accountTitle)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot matchingDoc = querySnapshot.docs.first;
          final String matchingDocID = matchingDoc.id;

          await mainAccountReference.doc(matchingDocID).update({
            'amount': mainAmountInt.toString(),
          });
        }
      }
    }

    final addedpaycheckReference =
        await users.doc(userID).collection('Paychecks').add(model.toJson());

    final paycheckIDMake = addedpaycheckReference.id;
    final modelOfPaycheck = PaycheckModel(
        docID: paycheckIDMake,
        paycheckTitle: model.paycheckTitle,
        description: model.description,
        datepaycheck: model.datepaycheck,
        ruleID: model.ruleID,
        ruleName: model.ruleName,
        amount: model.amount,
        selectedAccount: selectedAccountForPaycheck,
        creationDate: model.creationDate);

    ref.read(serviceProvider).updatepaycheck(ref, modelOfPaycheck);

    for (var doc in finalAccountsInRule) {
      final paycheckRuleReference = await ref
          .read(serviceProvider)
          .addNewRuleOfPaycheck(ref, modelOfPaycheck,
              FirebaseAuth.instance.currentUser!.uid, doc);

      doc.docID = paycheckRuleReference!.id;
    }
    return addedpaycheckReference;
  }

  // UPDATE

  void updatepaychecksList(WidgetRef ref, PaycheckModel updatedpaycheck) {
    final paychecksToUpdate = ref.read(paycheckListProvider);
    final updatedpaychecks = <PaycheckModel>[];

    for (var paycheck in paychecksToUpdate) {
      if (paycheck.docID == updatedpaycheck.docID) {
        updatedpaychecks.add(updatedpaycheck);
      } else {
        updatedpaychecks.add(paycheck);
      }
    }

    ref
        .read(paycheckListProvider.notifier)
        .updatepaychecks([...ref.read(paycheckListProvider)]);
  }

  Future<void> updatepaycheck(
    WidgetRef ref,
    PaycheckModel model,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final paycheckReference =
          users.doc(userID).collection('Paychecks').doc(model.docID);

      await paycheckReference.update(model.toJson());

      ref.read(paycheckUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  void updateDonepaycheck(String userID, String paycheckID, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('Paychecks')
        .doc(paycheckID)
        .update({'isDone': valueUpdate});
  }

  Future<DocumentReference<Object?>?> addNewRuleOfPaycheck(
      WidgetRef ref, PaycheckModel model, String userID, AIRModel air) async {
    DocumentReference addedAIRForPaycheck = await users
        .doc(userID)
        .collection('Paychecks')
        .doc(model.docID)
        .collection(model.ruleName)
        .add(air.toJson());

    air.docID = addedAIRForPaycheck.id;
    return addedAIRForPaycheck;
  }
}
