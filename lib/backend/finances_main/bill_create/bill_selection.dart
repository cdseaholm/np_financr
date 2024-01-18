import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';
import '../../widgets/show_toast.dart';
import '../updater_all/updater.dart';
import '../../../data/models/app_models/model_bills.dart';

import '../../services/main_function_services/services_bills.dart';

class BillSelectionWidget extends StatefulHookConsumerWidget {
  const BillSelectionWidget({
    required this.previousPage,
    super.key,
  });

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillSelectionWidgetState();
}

class _BillSelectionWidgetState extends ConsumerState<BillSelectionWidget> {
  var paidButton = false;
  var reimbursedButton = false;
  var amountController = TextEditingController();
  final amountList = [];
  List<bool> toUseList = [];

  @override
  Widget build(BuildContext context) {
    final bills = ref.read(billDetailsListProvider);
    if (toUseList.isEmpty) {
      toUseList = List.generate(bills.length, (index) => false);
    }

    return AlertDialog(
      scrollable: true,
      title: const Column(children: [
        Text('Previously Used Bills'),
      ]),
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Item:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Amount:',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      for (var index = 0; index < bills.length; index++)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        onChanged: (value) {
                                          setState(() {
                                            // Mark the selected checkbox
                                            toUseList[index] = value ?? false;
                                            final thisBillDetails =
                                                BillDetailsModel(
                                                    billTitle:
                                                        bills[index].billTitle,
                                                    billPaid:
                                                        bills[index].billPaid,
                                                    billWaived:
                                                        bills[index].billWaived,
                                                    creationDate: bills[index]
                                                        .creationDate,
                                                    amount:
                                                        bills[index].amount);
                                            ref
                                                .read(
                                                    billDetailsListStateProvider
                                                        .notifier)
                                                .update((state) => [
                                                      ...ref.read(
                                                          billDetailsListStateProvider),
                                                      thisBillDetails
                                                    ]);
                                          });
                                        },
                                        value: toUseList[index],
                                      ),
                                      Text(bills[index].billTitle),
                                    ],
                                  ),
                                ],
                              ),
                              Text(bills[index].amount)
                            ]),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(5),
            if (bills.length > 4)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scroll for more',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  showToast('Saving...');

                  if (widget.previousPage == PreviousPage.updater) {
                    ref
                        .read(billListProvider)
                        .addAll(ref.read(billDetailsListStateProvider));
                  }
                } finally {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
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
