import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'repeat_notifiers.dart';

class RepeatCheckBoxFrequency extends HookConsumerWidget {
  const RepeatCheckBoxFrequency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<String?>(
        valueListenable: frequencyNotifier,
        builder: (context, frequency, child) {
          final isChanged = frequency != frequencyNotifier.value;
          return Icon(
            isChanged || frequencyNotifier.value == 'No'
                ? Icons.check_box_outline_blank
                : Icons.check_box,
            weight: 1,
            color: Colors.blue,
          );
        });
  }
}

class RepeatDropDownFrequency extends HookConsumerWidget {
  final Function onFrequencyChanged;

  const RepeatDropDownFrequency({required this.onFrequencyChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<DropdownMenuItem<String>> frequencies = [
      const DropdownMenuItem(
        value: 'No',
        child: Text(
          'Frequency Example: Daily',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      const DropdownMenuItem(
        value: 'No Frequency',
        child: Text('No Frequency'),
      ),
      const DropdownMenuItem(
        value: 'Daily',
        child: Text('Daily'),
      ),
      const DropdownMenuItem(
        value: 'Weekly',
        child: Text('Weekly'),
      ),
      const DropdownMenuItem(
        value: 'Monthly',
        child: Text('Monthly'),
      ),
      const DropdownMenuItem(
        value: 'Yearly',
        child: Text('Yearly'),
      ),
    ];

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(4)),
        padding: MediaQuery.paddingOf(context),
        child: ValueListenableBuilder<String>(
            valueListenable: frequencyNotifier,
            builder: (context, frequency, child) {
              return SizedBox(
                height: MediaQuery.devicePixelRatioOf(context) / .05,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: frequency,
                  focusColor: Colors.white60,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.045,
                      MediaQuery.of(context).size.width * 0.005,
                      MediaQuery.of(context).size.width * 0.023,
                      0),
                  onChanged: (value) {
                    if (value != frequencyNotifier.value &&
                        value != 'No Frequency' &&
                        value != 'No') {
                      onFrequencyChanged(value!);
                    } else {
                      frequencyNotifier.value = 'No';
                    }
                  },
                  items: frequencies,
                  iconEnabledColor: Colors.blue,
                ),
              );
            }),
      ),
    );
  }
}

class RepeatCheckBoxDays extends HookConsumerWidget {
  const RepeatCheckBoxDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<List<String?>>(
        valueListenable: selectedDaysNotifier,
        builder: (context, originalSelectedDays, child) {
          final isChanged = selectedRepeatingDaysList.isEmpty;
          return Icon(
            isChanged || selectedRepeatingDaysList.isEmpty
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
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: selectedDaysNotifier,
        builder: (context, originalSelectedDays, child) {
          return SizedBox(
              height: MediaQuery.devicePixelRatioOf(context) / .05,
              child: const SizedBox());
        },
      ),
    );
  }
}

class RepeatDateTime extends StatefulHookConsumerWidget {
  const RepeatDateTime({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepeatDateTimeState();
}

class _RepeatDateTimeState extends ConsumerState<RepeatDateTime> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        valueListenable: repeatUntilNotifier,
        builder: (context, repeat, child) {
          return SimpleDialogOption(
            onPressed: () async {
              final getValue = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2025));

              if (getValue != null) {
                final format = DateFormat.yMd();
                setState(() {
                  repeatUntilNotifier.value = format.format(getValue);
                });
              }
            },
            child: Text(repeatUntilNotifier.value),
          );
        });
  }
}
