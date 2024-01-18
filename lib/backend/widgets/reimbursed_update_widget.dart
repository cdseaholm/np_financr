import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:multiselect/multiselect.dart';

final reimbursedItems = StateProvider<List<String>>((ref) {
  return [];
});

ValueNotifier<List<String>> reimbursedItemsNotifier =
    ValueNotifier<List<String>>([]);

List<String> reimbursedItemsList = [];

bool showreimbursedItemsListHint = false;

class RepeatCheckBoxDays extends HookConsumerWidget {
  const RepeatCheckBoxDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<List<String?>>(
        valueListenable: reimbursedItemsNotifier,
        builder: (context, originalSelectedDays, child) {
          final isChanged = reimbursedItemsList.isEmpty;
          return Icon(
            isChanged || reimbursedItemsList.isEmpty
                ? Icons.check_box_outline_blank
                : Icons.check_box,
            weight: 1,
            color: Colors.blue,
          );
        });
  }
}

class RepeatMultiSelect extends HookConsumerWidget {
  final Function(List<String>) onMultiSelectionChanged;
  final Function(List<String>) onNoMultiSelection;

  const RepeatMultiSelect(
      {required this.onMultiSelectionChanged,
      required this.onNoMultiSelection,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> days = [
      'Cat Fees',
      'Parking',
      'Storage',
      'Xfinity',
    ];
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: reimbursedItemsNotifier,
        builder: (context, originalSelectedDays, child) {
          return SizedBox(
              height: MediaQuery.devicePixelRatioOf(context) / .05,
              child: DropDownMultiSelect(
                hint: const Text(
                  'Nothing Reimbursed this Month Yet',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                options: days,
                selectedValues: reimbursedItemsList,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    onMultiSelectionChanged(value);
                  } else {
                    onNoMultiSelection(value);
                  }
                  if (kDebugMode) {
                    print('Multi: $value');
                  }
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
              ));
        },
      ),
    );
  }
}
