import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_service_provider.dart';

import '../../../../data/models/app_models/account_model.dart';
import 'selected_account_providers.dart';

class Edit extends ConsumerStatefulWidget {
  const Edit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditState();
}

class _EditState extends ConsumerState<Edit> {
  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountListProvider);

    return Column(
      children: accounts.asMap().entries.map((entry) {
        final account = entry.value;
        return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    account.accountTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ]),
                Row(children: [
                  TextButton(
                      onPressed: () {
                        ref.read(accountUpdateRadioProvider.notifier).state =
                            AccountModel(
                          accountTitle: account.accountTitle,
                          description: account.description,
                          creationDate: account.creationDate,
                          amount: account.amount,
                        );
                        editThisAccount(context, ref);
                      },
                      child: const Text('Edit')),
                  IconButton(
                      onPressed: () {
                        ref.read(accountUpdateRadioProvider.notifier).state =
                            AccountModel(
                          accountTitle: account.accountTitle,
                          description: account.description,
                          creationDate: account.creationDate,
                          amount: account.amount,
                        );
                        deleteAccountMethod(context, ref, account);
                      },
                      icon: const Icon(CupertinoIcons.trash))
                ]),
              ],
            ),
            onTap: () async {
              bool? yes = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const Edit(),
              );
              if (context.mounted) {
                if (yes == true) {
                  Navigator.pushNamed(context, 'editAccount1');
                } else {
                  Navigator.pop(context);
                }
              }
            });
      }).toList(),
    );
  }
}

class EditAccount {
  Future<void> editAccountDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit Accounts'),
            backgroundColor: Colors.white,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Edit(),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(accountListProvider.notifier).updateAccounts;

                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Future<void> editThisAccount(BuildContext context, WidgetRef ref) async {
  final accountNameController = TextEditingController();
  final selectedAccount = ref.watch(accountUpdateRadioProvider);

  accountNameController.text = selectedAccount.accountTitle;

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Account Color and Name'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  TextField(
                    controller: accountNameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Name',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final scaffoldState = ScaffoldMessenger.of(dialogContext);
              scaffoldState.showSnackBar(
                const SnackBar(content: Text('Updating account...')),
              );
              final updatedAccountModel = AccountModel(
                accountTitle: selectedAccount.accountTitle,
                description: selectedAccount.description,
                creationDate: selectedAccount.creationDate,
                amount: selectedAccount.amount,
              );

              ref.read(accountUpdateRadioProvider.notifier).state =
                  updatedAccountModel;

              await AccountServices().updateAccount(ref, updatedAccountModel);

              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteAccountMethod(
    BuildContext context, WidgetRef ref, AccountModel account) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final docID = account.docID;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Deleting Account, will delete all Information in this account, do you want to Continue?',
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await UpdateaccountService()
                  .deleteAccount(userID!, docID)
                  .then((value) => null);
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
              ref.read(accountListProvider.notifier).updateAccounts;
            },
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );
}
