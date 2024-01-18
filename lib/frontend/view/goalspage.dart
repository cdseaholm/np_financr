import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/services/main_function_services/goal_services.dart';
import '../../backend/services/main_function_services/stat_filter_widget.dart';
import '../../backend/finances_main/goals(all)/goal_card_widget.dart';
import '../../data/models/app_models/new_goal_model.dart';

class Goals extends HookConsumerWidget {
  const Goals({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.read(goalListProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            const Gap(10),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Financial Goals',
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
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD5E8FA),
                            foregroundColor: Colors.blue.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await showModalBottomSheet<void>(
                              showDragHandle: true,
                              isDismissible: false,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              context: context,
                              builder: (context) => const AddNewGoalModel(),
                            ).whenComplete(() => null);
                          },
                          child: const Text(
                            '+ Goal',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(15),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filter By:'),
                    Gap(1),
                    StatFilterWidgetButton()
                  ],
                ),
              ],
            ),
            const Divider(
              thickness: .6,
              color: Colors.black,
            ),
            if (goals.isEmpty)
              const DisplayDefaultGoal()
            else
              ListView.builder(
                itemCount: goals.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GoalListWidget(getIndex: index);
                },
              ),
          ])),
    );
  }
}

class DisplayDefaultGoal extends HookConsumerWidget {
  const DisplayDefaultGoal({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 5,
      width: MediaQuery.of(context).size.height / 1,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('No Goals Yet! Create one')],
      ),
    );
  }
}
