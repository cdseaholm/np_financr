import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';
import 'package:np_financr/backend/services/main_function_services/previous_months_services.dart';
import 'package:np_financr/backend/finances_main/updater_all/updater.dart';
import 'package:np_financr/data/models/app_models/updater_model.dart';
import 'package:np_financr/main.dart';

class PreviousMonthUpdates extends StatefulHookConsumerWidget {
  const PreviousMonthUpdates({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviousMonthUpdatesState();
}

class _PreviousMonthUpdatesState extends ConsumerState<PreviousMonthUpdates> {
  bool isExpanded = false;
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    final updates = ref.read(monthlyUpdateListProvider);
    List<bool> toUseList = [];

    if (toUseList.isEmpty) {
      toUseList = List.generate(updates.length, (index) => false);
    }

    return AlertDialog(
      title: const Column(children: [
        Text('Previous Month Updates'),
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
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(10),
                      if (updates.isEmpty)
                        const Text('No Previous Updates')
                      else
                        for (var index = 0; index < updates.length; index++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                  isClicked = !isClicked;
                                });
                              },
                              child: ExpansionTile(
                                leading: Checkbox(
                                  onChanged: (value) {
                                    ref
                                        .read(previousUpdateStateProvider
                                            .notifier)
                                        .update(
                                          (state) => UpdaterModel(
                                              updaterTitle: updates[index]
                                                  .monthlyModelTitle,
                                              updaterAmount:
                                                  updates[index].creationDate,
                                              updatedDate:
                                                  updates[index].creationDate),
                                        );
                                    setState(() {
                                      for (var i = 0;
                                          i < toUseList.length;
                                          i++) {
                                        toUseList[i] = false;
                                      }
                                      toUseList[index] = value ?? false;
                                    });
                                  },
                                  value: toUseList[index],
                                ),
                                title: Row(
                                  children: [
                                    Text(updates[index].monthlyModelTitle),
                                  ],
                                ),
                              ),
                            ),
                          )
                    ],
                  ),
                ),
              ),
            ),
            const Gap(5),
            if (updates.length > 4)
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
                ref.read(previousUpdateStateProvider.notifier).update((state) =>
                    UpdaterModel(
                        updaterTitle: '', updaterAmount: '', updatedDate: ''));
                Navigator.pushReplacement(
                  context,
                  DialogRoute<void>(
                    builder: (BuildContext context) => const UpdaterMethod(
                        previousPage: PreviousPage.previousMonthUpdates),
                    context: context,
                  ),
                );
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  DialogRoute<void>(
                    builder: (BuildContext context) => const UpdaterMethod(
                        previousPage: PreviousPage.previousMonthUpdates),
                    context: context,
                  ),
                );
              },
              child: const Text('Use Selected'),
            ),
          ],
        ),
      ],
    );
  }
}
