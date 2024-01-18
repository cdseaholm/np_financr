import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/main.dart';

import '../../../data/models/app_models/account_model.dart';
import '../../widgets/textfield_widget.dart';
import '../../providers/main_function_providers/account_providers/account_providers.dart';
import '../../providers/main_function_providers/account_providers/account_service_provider.dart';
import '../../providers/main_function_providers/account_providers/selected_account_providers.dart';

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
