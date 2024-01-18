import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/rule_model.dart';
import '../../providers/main_function_providers/rule_provider.dart';
import '../../services/main_function_services/rule_service.dart';
import '../../providers/main_function_providers/selected_rule_providers.dart';

class EditRule extends ConsumerStatefulWidget {
  const EditRule({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRuleState();
}

class _EditRuleState extends ConsumerState<EditRule> {
  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(ruleListProvider);

    return Column(
      children: rules.asMap().entries.map((entry) {
        final rule = entry.value;
        return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    rule.ruleTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ]),
                Row(children: [
                  TextButton(
                      onPressed: () {
                        ref.read(ruleUpdateRadioProvider.notifier).state =
                            RuleModel(
                                ruleTitle: rule.ruleTitle,
                                creationDate: rule.creationDate);
                        editThisRule(context, ref);
                      },
                      child: const Text('Edit')),
                  IconButton(
                      onPressed: () async {
                        ref.read(ruleUpdateRadioProvider.notifier).state =
                            RuleModel(
                                ruleTitle: rule.ruleTitle,
                                creationDate: rule.creationDate);
                        await deleteRuleMethod(context, ref, rule);
                        ref.read(ruleListProvider.notifier).updateRules;
                      },
                      icon: const Icon(CupertinoIcons.trash))
                ]),
              ],
            ),
            onTap: () async {
              bool? yes = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const EditRule(),
              );
              if (context.mounted) {
                if (yes == true) {
                  Navigator.pushNamed(context, 'editRule1');
                } else {
                  Navigator.pop(context);
                }
              }
            });
      }).toList(),
    );
  }
}

class EditRuleedit {
  Future<void> editRuleDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit Rules'),
            backgroundColor: Colors.white,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EditRule(),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(ruleListProvider.notifier).updateRules;

                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Future<void> editThisRule(BuildContext context, WidgetRef ref) async {
  final ruleNameController = TextEditingController();
  final selectedRule = ref.watch(ruleUpdateRadioProvider);

  ruleNameController.text = selectedRule.ruleTitle;

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Rule'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ruleNameController,
                    decoration: const InputDecoration(
                      labelText: 'Rule Name',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final scaffoldState = ScaffoldMessenger.of(dialogContext);
              scaffoldState.showSnackBar(
                const SnackBar(content: Text('Updating rule...')),
              );
              final updatedRuleModel = RuleModel(
                  ruleTitle: selectedRule.ruleTitle,
                  creationDate: selectedRule.creationDate);

              ref.read(ruleUpdateRadioProvider.notifier).state =
                  updatedRuleModel;

              await RuleService().updateRule(ref, updatedRuleModel);

              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteRuleMethod(
    BuildContext context, WidgetRef ref, RuleModel rule) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final ruleID = rule.ruleID;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Deleting Rule, will delete all Tasks in this Rule, do you want to Continue?',
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await RuleService()
                  .deleteRule(userID!, ruleID)
                  .then((value) => null);

              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );
}
