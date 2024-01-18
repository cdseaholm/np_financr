import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.dart';
import 'textfield_widget.dart';

class NumberFieldWidget extends StatefulHookConsumerWidget {
  const NumberFieldWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    required this.selectedType,
    required this.previousPage,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;
  final String selectedType;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NumberFieldWidgetState();
}

class _NumberFieldWidgetState extends ConsumerState<NumberFieldWidget> {
  String? selectedAmount;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> amounts = [
      const DropdownMenuItem<String>(value: '\$', child: Text('\$')),
      const DropdownMenuItem<String>(value: '%', child: Text('%'))
    ];

    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 20,
          padding: const EdgeInsets.fromLTRB(5, 0, 2, 0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.2,
              color: Colors.grey.shade400,
            ),
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: widget.txtController,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: widget.hintText,
                  ),
                  maxLines: widget.maxLine,
                ),
              ),
              DropdownButton<String>(
                elevation: 0,
                iconSize: 15,
                value: selectedAmount,
                items: amounts.map((amount) {
                  return amount;
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedAmount = newValue!;
                    if (widget.previousPage != PreviousPage.ruleCreate) {
                      ref
                          .read(selectedAmountTypeProvider.notifier)
                          .update((state) => newValue);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StaticNumberFieldWidget extends StatefulHookConsumerWidget {
  const StaticNumberFieldWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    required this.previousPage,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaticNumberFieldWidgetState();
}

class _StaticNumberFieldWidgetState
    extends ConsumerState<StaticNumberFieldWidget> {
  String? selectedAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 14.5,
          width: MediaQuery.of(context).size.width / 1.47,
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 1),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.2,
              color: Colors.grey.shade400,
            ),
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: widget.txtController,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: widget.hintText,
                  ),
                  maxLines: widget.maxLine,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
