import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';
import 'package:np_financr/backend/finances_main/cards(all)/card_list.dart';
import '../../../data/models/app_models/account_model.dart';
import '../../../data/models/app_models/card_model.dart';
import '../../../main.dart';
import '../../widgets/constants/constants.dart';

import '../cards(all)/add_card_widget.dart';

import '../../providers/main_function_providers/card_provider.dart';
import 'account_list.dart';
import '../../providers/main_function_providers/account_providers/account_edit.dart';
import '../../providers/main_function_providers/account_providers/account_service_provider.dart';
import '../../providers/main_function_providers/account_providers/selected_account_providers.dart';

class AccountWidget extends ConsumerStatefulWidget {
  const AccountWidget({
    Key? key,
    required this.selectedAccountName,
    required this.previousPage,
  }) : super(key: key);

  final String selectedAccountName;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends ConsumerState<AccountWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedAccountName = ref.watch(selectedAccountProvider).accountTitle;
    var shownAccount = 'Select Account';
    if (selectedAccountName == '') {
      setState(() {
        shownAccount = 'Select Account';
      });
    }
    if (selectedAccountName != '') {
      setState(() {
        shownAccount = selectedAccountName;
      });
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectAccountMethod(
                          previousPage: widget.previousPage,
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.add),
                      const Gap(6),
                      Text(shownAccount),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectAccountMethod extends ConsumerStatefulWidget {
  const SelectAccountMethod({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectAccountMethodState();
}

class _SelectAccountMethodState extends ConsumerState<SelectAccountMethod> {
  bool accountCardBool = false;

  void _handleAccountButtonPressed() {
    setState(() {
      accountCardBool = false;
    });
  }

  void _handleCardButtonPressed() {
    ref.read(selectedCardProvider.notifier).update((state) => CardModel(
          cardTitle: '',
          description: '',
          creationDate: '',
          amount: '',
        ));
    setState(() {
      accountCardBool = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountListProvider);
    final cards = ref.watch(cardListProvider);
    return AlertDialog(
      scrollable: false,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _handleAccountButtonPressed,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accountCardBool ? Colors.transparent : Colors.blue,
                      width: 2.0, // Border width
                    ),
                  ),
                  child: const Text('Accounts', style: TextStyle(fontSize: 20)),
                ),
              ),
              TextButton(
                onPressed: _handleCardButtonPressed,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accountCardBool ? Colors.blue : Colors.transparent,
                      width: 2.0, // Border width
                    ),
                  ),
                  child: const Text('Cards', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          const Divider(
              thickness: 1, color: Colors.black, indent: 10, endIndent: 10),
        ],
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (accountCardBool == false && accounts.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black38,
              )),
              height: MediaQuery.of(context).size.height / 4,
              child: SingleChildScrollView(
                  child: AccountList(previousPage: widget.previousPage)),
            )
          else if (accountCardBool == false && accounts.isEmpty)
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black38,
                )),
                height: MediaQuery.of(context).size.height / 4,
                child: const Center(
                    child: Text('No Accounts have been added yet'))),
          if (accountCardBool == true && cards.isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: SingleChildScrollView(
                child: CardList(previousPage: widget.previousPage),
              ),
            )
          else if (accountCardBool == true && cards.isEmpty)
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black38,
                )),
                height: MediaQuery.of(context).size.height / 4,
                child:
                    const Center(child: Text('No Cards have been added yet'))),
          const Gap(5),
          if (accountCardBool == false && accounts.length.toInt() > 3)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scroll for more',
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          else if (accountCardBool == true && cards.length.toInt() > 3)
            const Divider(
                thickness: 1, color: Colors.black, indent: 10, endIndent: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                        style: const ButtonStyle(
                            side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.black, width: 1))),
                        onPressed: () => {
                              if (ref
                                      .read(selectedAccountProvider)
                                      .accountTitle !=
                                  '')
                                {
                                  ref
                                      .read(selectedAccountProvider.notifier)
                                      .update((state) => AccountModel(
                                            docID: '',
                                            accountTitle: '',
                                            description: '',
                                            creationDate: '',
                                            amount: '',
                                          )),
                                  Navigator.of(context).pop()
                                },
                              Navigator.of(context).pop()
                            },
                        child: const Text(
                          'Clear Selected',
                          style: TextStyle(fontSize: 12),
                        )),
                  ],
                ),
              ),
              const Gap(15),
              if (accountCardBool == false)
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        style: const ButtonStyle(alignment: Alignment.center),
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        ),
                        label: const Text(
                          'Account',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          showAddAccountDialog(
                              context, ref, widget.previousPage);
                        },
                      ),
                    ],
                  ),
                )
              else if (accountCardBool == true)
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        style: const ButtonStyle(alignment: Alignment.center),
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        ),
                        label: const Text(
                          'Card',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(
                              context,
                              DialogRoute<void>(
                                builder: (BuildContext context) {
                                  return ShowAddCardDialog().showAddCardDialog(
                                      context, ref, widget.previousPage);
                                },
                                context: context,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Divider(
              thickness: 1, color: Colors.black, indent: 10, endIndent: 10),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (accounts.isNotEmpty && accountCardBool == false)
              TextButton(
                onPressed: () async {
                  EditAccount().editAccountDialog(context, ref);
                },
                child: const Text('Edit Accounts'),
              )
            else if (accounts.isNotEmpty && accountCardBool == true)
              TextButton(
                onPressed: () async {
                  EditAccount().editAccountDialog(context, ref);
                },
                child: const Text('Edit Cards'),
              ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}

class AccountWidgetDummy extends ConsumerWidget {
  const AccountWidgetDummy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Gap(6),
                      Text('Track Manually'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
