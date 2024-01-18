import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/models/app_models/goal_model.dart';
import '../../services/main_function_services/goal_services.dart';

class GoalListWidget extends StatefulHookConsumerWidget {
  const GoalListWidget({required this.getIndex, super.key});

  final int getIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalListWidgetState();
}

class _GoalListWidgetState extends ConsumerState<GoalListWidget> {
  var accountAmount = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final goals = ref.read(goalListProvider);
      final currentGoal = goals[widget.getIndex];
      final currentUser = FirebaseAuth.instance.currentUser?.uid;
      final calledAccountRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .collection('Accounts');
      final accountQuery = await calledAccountRef
          .where('accountTitle', isEqualTo: currentGoal.account)
          .get();
      if (accountQuery.docs.isNotEmpty) {
        setState(() {
          accountAmount = double.tryParse(accountQuery.docs.first['amount'])!;
        });
      } else {
        if (kDebugMode) {
          print('Account not found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching account amount: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalListProvider);
    var currentGoal = goals[widget.getIndex];
    final amount = double.parse(currentGoal.amount);

    var width = accountAmount / amount;
    if (width > 100) {
      width = 100;
    } else if (width < 0) {
      width = 0;
    }
    var colorToConvert = currentGoal.color;
    Color? finalColor = colorToConvert.isEmpty
        ? const Color.fromARGB(255, 76, 119, 85)
        : colorFromHex(colorToConvert);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: .5)),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: colorFromHex(currentGoal.color),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: 0,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      currentGoal.goalTitle,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    title: Column(
                      children: [
                        LinearProgressIndicator(
                          minHeight: 10,
                          value: width,
                          color: Colors.white54,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(finalColor!),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -12),
                            child: Column(
                              children: [
                                const Divider(
                                  thickness: 1.5,
                                  color: Colors.black38,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (currentGoal.completionDate ==
                                              'mm/dd/yy')
                                            const Text('No Target Date')
                                          else if (currentGoal.completionDate !=
                                              'mm/dd/yy')
                                            const Row(
                                              children: [
                                                Text(
                                                  'Goal Date:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            children: [
                                              Text(currentGoal.completionDate),
                                            ],
                                          )
                                        ]),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: BorderSide.strokeAlignCenter),
                                maximumSize: const Size(80, 45),
                                backgroundColor: const Color(0xFFD5E8FA),
                                foregroundColor: Colors.blue.shade800,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1, color: Colors.black12))),
                            onPressed: () async {
                              await showModalBottomSheet(
                                showDragHandle: true,
                                isDismissible: false,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                context: context,
                                builder: (context) {
                                  return Container();
                                  /*
                              return EditgoalModel(
                              goalToUpdate: currentgoal,
                              ongoalUpdated: (goal) {
                                setState(() {
                                  currentgoal = goal;
                                });
                              },
                            );
                            */
                                },
                              );
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  showDragHandle: true,
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Container();
                                    /*GoalDetails(selectedGoal: currentgoal);
                                */
                                  },
                                );
                              },
                              style: ButtonStyle(
                                fixedSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.of(context).size.width / 5.8,
                                      MediaQuery.of(context).size.height / 22),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFFD5E8FA)),
                                foregroundColor: MaterialStatePropertyAll(
                                    Colors.blue.shade800),
                                elevation: const MaterialStatePropertyAll(0),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            width: 1, color: Colors.black12))),
                              ),
                              child: const Text(
                                'Details',
                                style: TextStyle(fontSize: 12),
                              ))
                        ],
                      )
                    ],
                  )
                ]),
          ))
        ]));
  }
}

Future<List<String>> loadArray(GoalModel goal) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('goals')
        .doc(goal.docID)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey('repeatingDays') &&
          data['repeatingDays'] is List<dynamic>) {
        var repeatingDaysArray = data['repeatingDays'] as List<dynamic>;

        List<String> array = [];

        for (var day in repeatingDaysArray) {
          if (day is String) {
            array.add(day);
          }
        }

        return array;
      }
    }

    return [];
  } catch (e) {
    return [];
  }
}
