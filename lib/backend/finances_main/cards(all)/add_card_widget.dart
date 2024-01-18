import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/providers/main_function_providers/card_provider.dart';
import 'package:np_financr/backend/services/main_function_services/card_service.dart';
import 'package:np_financr/main.dart';
import '../../../data/models/app_models/card_model.dart';
import '../../widgets/textfield_widget.dart';
import '../accounts(all)/account_cards_widget.dart';

class ShowAddCardDialog {
  Widget showAddCardDialog(
      BuildContext context, WidgetRef ref, PreviousPage previousPage) {
    final accountNameController = TextEditingController();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final cards = ref.watch(cardListProvider);

    return AlertDialog(
      title: const Text('Add Card Name'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  const Gap(5),
                  TextField(
                    controller: accountNameController,
                    decoration: const InputDecoration(
                      labelText: 'Card Name',
                    ),
                  ),
                  const Gap(5),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description?',
                    ),
                  ),
                  const Gap(10),
                  StaticAmountWidget(
                    maxLine: 1,
                    hintText: 'Current Amount',
                    txtController: amountController,
                    previousPage: PreviousPage.accountWidget,
                    headTitle: 'Amount',
                  )
                ],
              ),
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
                  Navigator.pushReplacement(
                      context,
                      DialogRoute<void>(
                        builder: (BuildContext context) =>
                            const SelectAccountMethod(
                          previousPage: PreviousPage.addCardWidget,
                        ),
                        context: context,
                      ));
                },
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final format = DateFormat.yMEd();
                final timeR = format.format(DateTime.now());
                final scaffoldState = ScaffoldMessenger.of(context);
                scaffoldState.showSnackBar(
                  const SnackBar(content: Text('Adding account...')),
                );
                final cardModel = await addCard(
                    context,
                    ref,
                    descriptionController.text,
                    accountNameController.text,
                    timeR,
                    amountController.text,
                    '',
                    '');
                try {
                  if (cardModel != null) {
                    if (previousPage == PreviousPage.newPaycheck) {
                      ref.read(selectedCardProvider.notifier).update((state) =>
                          CardModel(
                              cardTitle: cardModel.cardTitle,
                              description: cardModel.description,
                              creationDate: cardModel.creationDate,
                              amount: cardModel.amount));
                    } else {
                      ref.read(selectedCardProvider.notifier).update((state) =>
                          CardModel(
                              cardTitle: '',
                              description: '',
                              creationDate: '',
                              amount: ''));
                    }
                    ref
                        .read(cardListProvider.notifier)
                        .updateCards([...cards, cardModel]);
                  }
                } finally {
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
  }
}

boolUpdate(bool buttonPushed) {
  if (buttonPushed == true) {}
}
