import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/main.dart';
import '../../../data/models/app_models/account_model.dart';
import '../../providers/main_function_providers/account_providers/account_providers.dart';
import '../../providers/main_function_providers/account_providers/account_service_provider.dart';
import '../../providers/main_function_providers/account_providers/selected_account_providers.dart';

class AccountList extends ConsumerWidget {
  const AccountList({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);
    final userID = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: accounts.asMap().entries.map((entry) {
        final account = entry.value;
        return ListTile(
          leading: IconButton(
              icon: const Icon(CupertinoIcons.trash),
              onPressed: () {
                ref
                    .read(updateaccountProvider)
                    .deleteAccount(userID!, account.docID);
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                account.accountTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          onTap: () async {
            if (previousPage == PreviousPage.newPaycheck) {
              ref
                  .read(selectedAccountProvider.notifier)
                  .update((state) => AccountModel(
                        accountTitle: account.accountTitle,
                        description: account.description,
                        docID: account.docID,
                        amount: account.amount,
                        creationDate: account.creationDate,
                      ));
            }
            Navigator.of(context).pop(true);
          },
        );
      }).toList(),
    );
  }
}
