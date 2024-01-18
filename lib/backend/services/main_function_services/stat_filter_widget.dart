import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/widgets/filters/filter_services.dart';

class StatFilterWidgetButton extends StatefulHookConsumerWidget {
  const StatFilterWidgetButton({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatFilterWidgetButtonState();
}

class _StatFilterWidgetButtonState
    extends ConsumerState<StatFilterWidgetButton> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    var statFilterValue = ref.watch(statFilterProvider).value;
    var filterByText =
        statFilterValue != null ? statFilterValue.toString() : 'Account';
    final accountFilterByList = ['Accounts', 'Cards', 'Paychecks', 'Rules'];

    return PopupMenuButton<String>(
      onSelected: (String filterBy) async {
        if (filterBy != filterByText) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .update({'statFilter': filterBy});
        }
      },
      itemBuilder: (context) {
        return accountFilterByList.map((filterBy) {
          return PopupMenuItem<String>(
            value: filterBy,
            child: Text(filterBy),
          );
        }).toList();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: Expanded(
          child: Column(children: [
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
        ),
      ),
    );
  }
}
