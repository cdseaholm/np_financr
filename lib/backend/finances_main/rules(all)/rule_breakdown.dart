import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RuleDetailsBreakdownDialog extends StatelessWidget {
  const RuleDetailsBreakdownDialog({
    super.key,
    required this.ruleTitle,
    required this.roundedRuleCut,
    required this.combinedamtDefined,
    required this.roundedCurrentRuleAmount,
  });

  final String ruleTitle;
  final double roundedRuleCut;
  final String combinedamtDefined;
  final double roundedCurrentRuleAmount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$ruleTitle Breakdown',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: Colors.black,
          indent: 25,
          endIndent: 25,
        ),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rule Portion:'),
            const Gap(15),
            Text('\$${roundedRuleCut.toString()}')
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Amt Defined By Rule:'),
            const Gap(15),
            Flexible(
                child: Text(
              combinedamtDefined.toString(),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.end,
            )),
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Amount in Rule:'),
            const Gap(15),
            Text('\$${roundedCurrentRuleAmount.toString()}')
          ],
        )
      ]),
      actions: [
        ElevatedButton(
            onPressed: Navigator.of(context).pop, child: const Text('Close'))
      ],
    );
  }
}
