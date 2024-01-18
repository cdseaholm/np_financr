import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/services/main_function_services/card_service.dart';
import 'package:np_financr/main.dart';

import '../../../data/models/app_models/card_model.dart';
import '../../widgets/constants/constants.dart';
import '../../login_all/auth_provider.dart';
import '../accounts(all)/account_cards_widget.dart';
import '../paycheck(main)/provider/financeproviders/clean_providers.dart';
import '../paycheck(main)/provider/financeproviders/service_provider.dart';
import '../paycheck(main)/repeat/repeat_notifiers.dart';
import '../../widgets/date_time_widgets.dart';
import '../../widgets/textfield_widget.dart';
import '../../providers/main_function_providers/card_provider.dart';
import '../rules(all)/rule_widget.dart';

class EditCardModel extends ConsumerStatefulWidget {
  final CardModel cardToUpdate;
  final Function(CardModel) oncardUpdated;
  const EditCardModel(
      {Key? key, required this.cardToUpdate, required this.oncardUpdated})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCardModelState();
}

@override
class _EditCardModelState extends ConsumerState<EditCardModel> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController moneyController;

  @override
  void initState() {
    super.initState();
    var cardToUpdate = widget.cardToUpdate;

    titleController = TextEditingController(
      text: cardToUpdate.cardTitle,
    );
    descriptionController = TextEditingController(
      text: cardToUpdate.description,
    );
    moneyController =
        TextEditingController(text: cardToUpdate.amount.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cardToUpdate = widget.cardToUpdate;

    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Edit card',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Divider(
          thickness: 1.2,
          color: Colors.grey.shade600,
        ),
        const Gap(12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Current card Title',
              style: AppStyle.headingOne,
            ),
            Container(
              constraints: BoxConstraints.tight(const Size(90, 25)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                onPressed: () async {
                  final userID = ref.read(authStateProvider).maybeWhen(
                        data: (user) => user?.uid,
                        orElse: () => null,
                      );
                  if (userID != null) {
                    try {
                      ref
                          .read(cardListProvider.notifier)
                          .removeCards(cardToUpdate);
                    } catch (error) {
                      if (kDebugMode) {
                        print('Error deleting card: $error');
                      }
                    }
                  }

                  ProvidersClear().clearEditpaycheck(ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Delete card',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
        TextFieldWidget(
          maxLine: 1,
          hintText: 'Edit card Name',
          txtController: titleController,
        ),
        const Gap(12),
        const Text('Current Description', style: AppStyle.headingOne),
        const Gap(6),
        TextFieldWidget(
          maxLine: 3,
          hintText: 'Edit Descriptions',
          txtController: descriptionController,
        ),
        const Gap(12),

        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
        const Gap(12),

        TextFieldWidget(
            maxLine: 1, hintText: 'Amount', txtController: moneyController),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Amount',
                style: AppStyle.headingTwo,
              ),
              const Gap(6),
              TextFieldWidget(
                  maxLine: 1,
                  hintText: 'Amount',
                  txtController: moneyController),
            ]),
          ),
          const Gap(22),
          const AccountWidget(
            selectedAccountName: '',
            previousPage: PreviousPage.editPaycheck,
          )
        ]),
        const Gap(12),
        // Date and Time Section
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          DateTimeWidget(
            titleText: 'Date',
            valueText: cardToUpdate.creationDate,
            iconSection: CupertinoIcons.calendar,
            onTap: () async {
              final getValue = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 2),
                  lastDate: DateTime(DateTime.now().year + 4));

              if (getValue != null) {
                final format = DateFormat.yMEd();
                ref
                    .read(dateProvider.notifier)
                    .update((state) => format.format(getValue));
              }
            },
          ),
          const Gap(22),
          const RuleWidget(
            selectedRuleName: '',
            previousPage: PreviousPage.editPaycheck,
          )
        ]),
        const Gap(12),

        //Button Section

        const Gap(12),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  ProvidersClear().clearEditpaycheck(ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const Gap(20),
            Expanded(
              child: Builder(builder: (context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final userID = FirebaseAuth.instance.currentUser?.uid;
                    final newTitle = titleController.text;
                    final newDescription = descriptionController.text;

                    final updatedcard =
                        await ref.read(updateCardProvider).updateCardFields(
                              userID: userID!,
                              cardID: cardToUpdate.docID,
                              newTitle: newTitle,
                              newDescription: newDescription,
                              newDate: cardToUpdate.creationDate,
                              newAmount: cardToUpdate.amount,
                            );

                    if (updatedcard != null) {
                      CardServices().updateCard(ref, updatedcard);
                    }

                    ref
                        .read(cardListProvider.notifier)
                        .updateCards([...ref.read(cardListProvider)]);

                    ref.read(fetchCards).isRefreshing;

                    ProvidersClear().clearEditpaycheck(ref);
                    setState(() {
                      selectedRepeatingDaysList = [];
                      frequencyNotifier.value = 'No';
                      repeatUntilNotifier.value = 'Until?';
                      selectedDaysNotifier.value = [];
                      showDaysHint = true;
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update'),
                );
              }),
            ),
          ],
        )
      ]),
    );
  }
}
