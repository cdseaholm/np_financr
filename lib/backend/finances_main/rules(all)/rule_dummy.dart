import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../main.dart';
import '../../widgets/constants/constants.dart';
import '../../login_all/alert_messages.dart';
import '../../providers/main_function_providers/selected_rule_providers.dart';

class RuleDummy extends ConsumerStatefulWidget {
  const RuleDummy({
    Key? key,
    required this.selectedRuleName,
    required this.previousPage,
  }) : super(key: key);

  final String selectedRuleName;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RuleDummyState();
}

class _RuleDummyState extends ConsumerState<RuleDummy> {
  @override
  Widget build(BuildContext context) {
    final selectedRuleName = ref.watch(selectedRuleProvider).ruleTitle;
    var shownRule = 'Select Rule';
    if (selectedRuleName == '') {
      setState(() {
        shownRule = 'Select Rule';
      });
    }
    if (selectedRuleName != '') {
      setState(() {
        shownRule = selectedRuleName;
      });
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rule',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  AccountBeforeRuleAlert();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.add),
                      const Gap(6),
                      Text(
                        shownRule,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
