import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/finances_main/monthly_update/card_monthly_model.dart';
import 'package:np_financr/backend/finances_main/monthly_update/new_update_widget.dart';
import 'package:np_financr/backend/services/main_function_services/services_monthly_update.dart';

import '../../backend/widgets/show_toast.dart';

class UpdatePageWidget extends StatefulHookConsumerWidget {
  const UpdatePageWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdatePageWidgetState();
}

class _UpdatePageWidgetState extends ConsumerState<UpdatePageWidget> {
  final isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final ups = ref.watch(monthlyUpdateListProvider);
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;

          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        floatingActionButton: SpeedDial(
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
              child: const Icon(Icons.update),
              backgroundColor: const Color.fromARGB(255, 38, 153, 97),
              label: 'Monthly Update',
              onTap: () async {
                showToast;
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
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Monthly Update',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        DateFormat('EEEE, MMMM d').format(DateTime.now()),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(10),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              const Gap(10),
              Expanded(
                  child: ListView.builder(
                itemCount: ups.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MonthlyModelCardWidget(getIndex: index);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
