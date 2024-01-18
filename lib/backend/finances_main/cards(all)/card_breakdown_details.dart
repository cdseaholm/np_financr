import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardDetailsBreakdownDialog extends StatelessWidget {
  const CardDetailsBreakdownDialog({
    super.key,
    required this.cardTitle,
    required this.roundedCardCut,
    required this.combinedamtDefined,
    required this.roundedCurrentCardAmount,
  });

  final String cardTitle;
  final double roundedCardCut;
  final String combinedamtDefined;
  final double roundedCurrentCardAmount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$cardTitle Breakdown',
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
            Text('\$${roundedCardCut.toString()}')
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
            Text('\$${roundedCurrentCardAmount.toString()}')
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
