import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../finances_main/paycheck(main)/paycheck_models/new_paycheck_model.dart';

class CalendarPaycheckButton extends HookConsumerWidget {
  const CalendarPaycheckButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          showDragHandle: true,
          isDismissible: false,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          context: context,
          builder: (context) => const AddNewPaycheckModel(),
        ).whenComplete(() => null);
      },
      child: const Text(
        '+ New Paycheck',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
