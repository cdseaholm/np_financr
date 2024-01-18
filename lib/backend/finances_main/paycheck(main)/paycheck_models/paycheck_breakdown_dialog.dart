import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaycheckDetailsBreakdownDialog extends StatelessWidget {
  const PaycheckDetailsBreakdownDialog({
    super.key,
    required this.accountTitle,
    required this.roundedPaycheckCut,
    required this.combinedamtDefined,
    required this.roundedCurrentAccountAmount,
  });

  final String accountTitle;
  final double roundedPaycheckCut;
  final String combinedamtDefined;
  final double roundedCurrentAccountAmount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$accountTitle Breakdown',
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
            const Text('Account Portion:'),
            const Gap(15),
            Text('\$${roundedPaycheckCut.toString()}')
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
            const Text('Total Amount in Account:'),
            const Gap(15),
            Text('\$${roundedCurrentAccountAmount.toString()}')
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
