import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/models/app_models/account_model.dart';
import 'selected_account_providers.dart';

//notifier providers

class AccountListNotifier extends StateNotifier<List<AccountModel>> {
  AccountListNotifier() : super([]);

  Future<void> updateAccounts(List<AccountModel> accounts) async {
    state = accounts;
  }

  Future<void> removeAccounts(AccountModel account) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != account.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Accounts')
        .doc(account.docID)
        .delete();
  }
}

//services

final accountListProvider =
    StateNotifierProvider<AccountListNotifier, List<AccountModel>>(
        (ref) => AccountListNotifier());

final serviceProvider = StateProvider<AccountServices>((ref) {
  return AccountServices();
});

var accountUpdateStateProvider = StateProvider<AccountModel>((ref) {
  return AccountModel(
    docID: '',
    accountTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});

class AccountServices {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewAccount(
      WidgetRef ref, AccountModel model) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final addedAccountReference =
        await users.doc(userID).collection('Accounts').add(model.toJson());

    final accountIDMake = addedAccountReference.id;

    AccountServices().updateAccount(
        ref,
        AccountModel(
          docID: accountIDMake,
          accountTitle: model.accountTitle,
          description: model.description,
          creationDate: model.creationDate,
          amount: model.amount,
        ));

    return addedAccountReference;
  }

  // UPDATE

  void updateAccountsList(WidgetRef ref, AccountModel updatedAccount) {
    final accountsToUpdate = ref.read(accountListProvider);
    final updatedAccounts = <AccountModel>[];

    for (var account in accountsToUpdate) {
      if (account.docID == updatedAccount.docID) {
        updatedAccounts.add(updatedAccount);
      } else {
        updatedAccounts.add(account);
      }
    }

    ref
        .read(accountListProvider.notifier)
        .updateAccounts([...ref.read(accountListProvider)]);
  }

  Future<void> updateAccount(
    WidgetRef ref,
    AccountModel model,
  ) async {
    try {
      final userID = FirebaseAuth.instance.currentUser?.uid;
      final accountReference =
          users.doc(userID).collection('Accounts').doc(model.docID);

      await accountReference.update(model.toJson());

      ref.read(accountUpdateRadioProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  // UPDATE

  updateProviders(AccountModel account, WidgetRef ref) async {
    ref.read(selectedAccountProvider.notifier).state = AccountModel(
      accountTitle: account.accountTitle,
      description: account.description,
      creationDate: account.creationDate,
      amount: account.amount,
    );
  }
}

final fetchAccounts = StreamProvider.autoDispose<List<AccountModel>>((ref) {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final accountCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Accounts');

  final Stream<QuerySnapshot> accountStream = accountCollection.snapshots();

  return accountStream.asyncMap((accountSnapshot) {
    var accounts = <AccountModel>[];
    for (final accountDoc in accountSnapshot.docs) {
      final accountData = accountDoc.data() as Map<String, dynamic>;
      accounts.add(AccountModel(
        docID: accountDoc.id,
        accountTitle: accountData['accountTitle'] as String? ?? '',
        description: accountData['description'] as String? ?? '',
        creationDate: accountData['creationDate'] as String? ?? '',
        amount: accountData['amount'] as String? ?? '',
      ));
    }

    ref.read(accountListProvider.notifier).updateAccounts(accounts);
    return accounts;
  });
});
