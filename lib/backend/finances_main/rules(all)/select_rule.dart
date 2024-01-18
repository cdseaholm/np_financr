import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/finances_main/rules(all)/rule_edit.dart';

import '../../../main.dart';

import 'rule_list.dart';
import 'rule_widget.dart';
import '../../providers/main_function_providers/rule_provider.dart';

class SelectRuleMethod extends ConsumerStatefulWidget {
  const SelectRuleMethod({required this.previousPage, super.key});

  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectRuleMethodState();
}

class _SelectRuleMethodState extends ConsumerState<SelectRuleMethod> {
  // Inside _SelectRuleMethodState

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(ruleListProvider);

    return AlertDialog(
      scrollable: true,
      title: const Text('Select Rule'),
      backgroundColor: Colors.white,
      content: Column(
        children: [
          if (rules.isNotEmpty)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rule Title:',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                Gap(10),
                Text(
                  'Affected Accounts:',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RuleList(previousPage: widget.previousPage),
              if (rules.length.isGreaterThan(5))
                const Text(
                  'Scroll Down for More Accounts',
                  style: TextStyle(fontSize: 12),
                ),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Rule'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    DialogRoute<void>(
                      builder: (BuildContext context) =>
                          AddRuleWidget(previousPage: widget.previousPage),
                      context: context,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (rules.isNotEmpty)
              TextButton(
                onPressed: () async {
                  const EditRule();
                },
                child: const Text('Edit Rules'),
              ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}
