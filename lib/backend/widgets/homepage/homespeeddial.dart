import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:np_financr/backend/widgets/show_toast.dart';

import '../../../main.dart';
import '../../finances_main/accounts(all)/account_cards_widget.dart';
import '../../finances_main/monthly_update/new_update_widget.dart';
import '../../finances_main/paycheck(main)/paycheck_models/new_paycheck_model.dart';

class ManagerMainSpeedDialWidget extends StatelessWidget {
  const ManagerMainSpeedDialWidget({
    super.key,
    required this.isDialOpen,
  });

  final ValueNotifier<bool> isDialOpen;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      buttonSize: const Size(50, 50),
      openCloseDial: isDialOpen,
      spacing: 12,
      spaceBetweenChildren: 10,
      overlayColor: Colors.black,
      overlayOpacity: .4,
      onOpen: () {
        showToast('Opened...');
      },
      onClose: () {
        showToast('Closed...');
      },
      icon: CupertinoIcons.add,
      activeIcon: CupertinoIcons.xmark,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.rule),
          backgroundColor: Colors.amber,
          label: 'Complete a Monthly Check-In',
          onTap: () async {
            try {
              showToast;
            } finally {
              await showModalBottomSheet<void>(
                showDragHandle: true,
                isDismissible: false,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                context: context,
                builder: (context) => const NewMonthlyUpdate(),
              ).whenComplete(() => null);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.payments),
          backgroundColor: Colors.redAccent,
          label: 'Add a Paycheck',
          onTap: () async {
            try {
              showToast;
            } finally {
              await showModalBottomSheet<void>(
                showDragHandle: true,
                isDismissible: false,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                context: context,
                builder: (context) => const AddNewPaycheckModel(),
              ).whenComplete(() => null);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.manage_accounts),
          backgroundColor: const Color.fromARGB(255, 38, 153, 97),
          label: 'Add an Account',
          onTap: () async {
            try {
              showToast;
            } finally {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const SelectAccountMethod(
                        previousPage: PreviousPage.manager);
                  });
            }
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
