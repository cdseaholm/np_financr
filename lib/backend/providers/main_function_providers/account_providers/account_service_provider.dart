import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';

import '../../../../data/models/app_models/account_model.dart';
import '../../../../main.dart';
import '../../../widgets/textfield_widget.dart';
import 'account_providers.dart';

//update account

final updateaccountProvider = Provider((ref) => UpdateaccountService());

class UpdateaccountService {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AccountModel?> updateaccountFields({
    required String userID,
    required String ruleID,
    required String ruleName,
    required String accountID,
    String? newStatus,
    String? newTitle,
    String? newDescription,
    String? newTime,
    String? newDate,
    List<String?>? newRepeatDays,
    String? newRepeatFrequency,
    String? newRepeatShown,
    String? newRepeatUntil,
    // Add other fields here as needed
  }) async {
    final accountRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(ruleID)
        .collection('accounts')
        .doc(accountID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['accountTitle'] = newTitle;
    }

    if (newDescription != null) {
      updatedFields['description'] = newDescription;
    }

    if (newTime != null) {
      updatedFields['timeaccount'] = newTime;
    }

    if (newDate != null) {
      updatedFields['dateaccount'] = newDate;
    }

    if (newRepeatDays != null) {
      updatedFields['repeatingDays'] = newRepeatDays;
    }

    if (newRepeatFrequency != null) {
      updatedFields['repeatingFrequency'] = newRepeatFrequency;
    }

    if (newRepeatShown != null) {
      updatedFields['repeatShown'] = newRepeatShown;
    }

    if (newRepeatUntil != null) {
      updatedFields['stopDate'] = newRepeatUntil;
    }

    await accountRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await accountRef.get();
    final updatedaccountData = updatedDoc.data() as Map<String, dynamic>;
    final updatedaccount = AccountModel.fromJson(updatedaccountData);

    return updatedaccount;
  }

  Future<void> deleteAccount(String userID, String docID) async {
    try {
      // Delete the account in the subcollection of Rules
      QuerySnapshot accountsInRulesCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('Accounts')
          .where('docID', isEqualTo: docID)
          .get();

      for (var accountDoc in accountsInRulesCollection.docs) {
        await accountDoc.reference.delete();
      }
    } finally {
      // Delete the account in its own category
      CollectionReference categoriesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('Accounts');

      await categoriesCollection.doc(docID).delete();
    }
  }
}

Future<void> showAddAccountDialog(
    BuildContext context, WidgetRef ref, PreviousPage previousPage) async {
  final accountNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  late String docID = ref.watch(selectedAccountProvider).docID;
  final accounts = ref.watch(accountListProvider);

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Account Name'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: accountNameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Name',
                    ),
                  ),
                  const Gap(5),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description?',
                    ),
                  ),
                  StaticAmountWidget(
                    maxLine: 1,
                    hintText: 'Current Amount',
                    txtController: amountController,
                    previousPage: PreviousPage.accountWidget,
                    headTitle: 'Amount',
                  )
                ],
              ),
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop;
                    ref
                        .read(selectedAccountProvider.notifier)
                        .update((state) => AccountModel(
                              docID: '',
                              accountTitle: '',
                              description: '',
                              creationDate: '',
                              amount: '',
                            ));
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final format = DateFormat.yMEd();
                  final timeR = format.format(DateTime.now());
                  final scaffoldState = ScaffoldMessenger.of(dialogContext);
                  scaffoldState.showSnackBar(
                    const SnackBar(content: Text('Adding account...')),
                  );
                  final accountModel = await addAccount(
                      context,
                      ref,
                      descriptionController.text,
                      accountNameController.text,
                      timeR,
                      amountController.text,
                      '',
                      '');
                  try {
                    if (accountModel != null) {
                      if (previousPage == PreviousPage.newPaycheck) {
                        ref
                            .read(selectedAccountProvider.notifier)
                            .update((state) => AccountModel(
                                  accountTitle: accountModel.accountTitle,
                                  description: accountModel.description,
                                  docID: docID,
                                  amount: amountController.text,
                                  creationDate: accountModel.creationDate,
                                ));
                      } else {
                        ref
                            .read(selectedAccountProvider.notifier)
                            .update((state) => AccountModel(
                                  docID: '',
                                  accountTitle: '',
                                  description: '',
                                  creationDate: '',
                                  amount: '',
                                ));
                      }
                      ref
                          .read(accountListProvider.notifier)
                          .updateAccounts([...accounts, accountModel]);
                    }
                  } finally {
                    if (context.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<AccountModel?> addAccount(
    BuildContext context,
    WidgetRef ref,
    String description,
    String accountTitle,
    String creationDate,
    String amount,
    String amountType,
    String accountPortion) async {
  final userCreatedAccountModel = AccountModel(
    accountTitle: accountTitle,
    description: description,
    creationDate: creationDate,
    amount: amount,
  );

  try {
    if (accountTitle.isNotEmpty) {
      final addedAccountReference =
          await AccountServices().addNewAccount(ref, userCreatedAccountModel);

      final accountIDMake = addedAccountReference.id;

      ref.read(selectedAccountProvider.notifier).state = AccountModel(
        docID: accountIDMake,
        accountTitle: userCreatedAccountModel.accountTitle,
        description: userCreatedAccountModel.description,
        creationDate: userCreatedAccountModel.creationDate,
        amount: userCreatedAccountModel.amount,
      );

      return userCreatedAccountModel;
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    return userCreatedAccountModel;
  } catch (e) {
    return null;
  }
}
