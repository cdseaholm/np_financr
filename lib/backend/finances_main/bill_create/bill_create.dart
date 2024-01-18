import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/data/models/app_models/model_bills.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_bills.dart';
import 'package:np_financr/backend/services/main_function_services/services_bills.dart';
import 'package:np_financr/backend/finances_main/updater_all/updater.dart';
import 'package:np_financr/backend/widgets/number_file_widget.dart';
import 'package:np_financr/backend/widgets/show_toast.dart';
import 'package:np_financr/backend/widgets/textfield_widget.dart';

import '../../../main.dart';

class BillCreateWidget extends StatefulHookConsumerWidget {
  const BillCreateWidget({
    required this.previousPage,
    super.key,
  });

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillCreateWidgetState();
}

class _BillCreateWidgetState extends ConsumerState<BillCreateWidget> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  var paidButton = false;
  var reimbursedButton = false;

  @override
  void initState() {
    super.initState();

    titleController.text = '';
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Column(children: [
        Text('What is this new Monthly Item?'),
      ]),
      backgroundColor: Colors.white,
      content: Column(children: [
        TextFieldWidget(
            maxLine: 1, hintText: 'Title', txtController: titleController),
        const Gap(5),
        StaticNumberFieldWidget(
            maxLine: 1,
            hintText: 'Amount',
            txtController: amountController,
            previousPage: PreviousPage.billCreate),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Has this been paid already?'),
            Switch(
              value: paidButton,
              onChanged: (value) {
                setState(() {
                  paidButton = value;
                });
              },
            ),
          ],
        ),
        const Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Is this item reimbursable?'),
            Switch(
              value: reimbursedButton,
              onChanged: (value) {
                setState(() {
                  reimbursedButton = value;
                });
              },
            ),
          ],
        )
      ]),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final format = DateFormat.yMEd();
                try {
                  showToast('Saving...');

                  final billItem = BillDetailsModel(
                      billTitle: titleController.text.trim(),
                      billPaid: paidButton,
                      billWaived: reimbursedButton,
                      creationDate: format.format(DateTime.now()),
                      amount: amountController.text.trim()); // fix);

                  final uID = FirebaseAuth.instance.currentUser?.uid;

                  if (uID != null) {
                    final newBillReference =
                        await ref.read(billDetailsProvider).addNewbillDetails(
                              ref,
                              billItem,
                              uID,
                            );
                    billItem.billID = newBillReference.id;

                    ref
                        .read(billDetailsListProvider.notifier)
                        .updatebillDetails(
                      [...ref.read(billDetailsListProvider), billItem],
                    );
                  }

                  ref.read(fetchBillDetails).isRefreshing;

                  titleController.clear();
                  setState(() {
                    paidButton = false;
                    reimbursedButton = false;
                  });
                  if (widget.previousPage == PreviousPage.updater) {
                    ref.read(billListProvider).add(billItem);
                  }
                } finally {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      // ignore: use_build_context_synchronously
                      DialogRoute<void>(
                          builder: (BuildContext context) =>
                              const UpdaterMethod(
                                previousPage: PreviousPage.updater,
                              ),
                          context: context));
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
