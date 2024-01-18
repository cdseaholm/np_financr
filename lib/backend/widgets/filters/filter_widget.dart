import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import '../../finances_main/paycheck(main)/provider/financeproviders/selected_category_providers.dart';

import 'filter_logic.dart';
import 'filter_services.dart';

class CustomFilterButton extends StatefulHookConsumerWidget {
  const CustomFilterButton({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomFilterButtonState();
}

class _CustomFilterButtonState extends ConsumerState<CustomFilterButton> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    var paychecks = ref.watch(paycheckListProvider);
    var paycheckFilterValue = ref.watch(paycheckFilterProvider).value;
    var filterByText = paycheckFilterValue != null
        ? paycheckFilterValue.toString()
        : 'Paycheck';
    var selectedPaycheck =
        ref.watch(selectedPaycheckProvider.notifier).state.paycheckTitle;
    var paycheckFilter = ref.watch(paycheckFilterProvider);
    final paycheckFilterByList = [
      'All',
      'Date',
      'New -> Old',
      'Old -> New',
      'Overdue',
      'Upcoming',
    ];

    return PopupMenuButton<String>(
      onSelected: (String filterBy) async {
        if (filterBy != filterByText) {
          await FilterService().updateFilter(ref, filterBy);
          if (filterBy != filterByText) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .update({'paycheckFilter': selectedPaycheck});
          }
        }

        if (filterBy == 'Paycheck') {
          FilterStates()
              .sortByPaycheck(paychecks, paycheckFilter.asData.toString());
        } else if (filterBy == 'Completed') {
          FilterStates().sortByCompleted(paychecks);
        } else if (filterBy == 'Date') {
          FilterStates().sortByDate(paychecks);
        } else if (filterBy == 'New \u{2191}') {
          FilterStates().sortNewestToOldest(paychecks);
        } else if (filterBy == 'New \u{2193}') {
          FilterStates().sortOldestToNewest(paychecks);
        } else if (filterBy == 'Overdue') {
          FilterStates().sortByOverdue(paychecks);
        } else if (filterBy == 'Upcoming') {
          FilterStates().sortByUpcoming(paychecks);
        }

        ref.read(paycheckListProvider.notifier).updatepaychecks(paychecks);
      },
      itemBuilder: (context) {
        return paycheckFilterByList.map((filterBy) {
          return PopupMenuItem<String>(
            value: filterBy,
            child: Text(filterBy),
          );
        }).toList();
      },
      child: Flex(
          clipBehavior: Clip.hardEdge,
          direction: Axis.horizontal,
          children: [
            Column(children: [
              Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filterByText),
                        ],
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ]),
              ),
            ]),
          ]),
    );
  }
}
