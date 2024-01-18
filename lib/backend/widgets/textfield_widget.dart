import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/provider/financeproviders/service_provider.dart';

import '../../main.dart';
import 'constants/constants.dart';
import 'number_file_widget.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.2,
          color: Colors.grey.shade400,
        ),
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: txtController,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText),
        maxLines: maxLine,
      ),
    );
  }
}

class UpdateTextFieldWidget extends StatelessWidget {
  const UpdateTextFieldWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: .5)),
      child: TextField(
        controller: txtController,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText),
        maxLines: maxLine,
      ),
    );
  }
}

final selectedAmountTypeProvider = StateProvider<String>((ref) {
  return '\$';
});

class RuleMakeNumberDropWidget extends StatefulHookConsumerWidget {
  const RuleMakeNumberDropWidget({
    Key? key,
    required this.index,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    required this.selectedType,
    required this.previousPage,
    required this.onChanged,
  }) : super(key: key);

  final int index;
  final String hintText;
  final int maxLine;
  final TextEditingController txtController;
  final String selectedType;
  final PreviousPage previousPage;
  final Function(int, String) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RuleMakeNumberDropWidgetState();
}

class _RuleMakeNumberDropWidgetState
    extends ConsumerState<RuleMakeNumberDropWidget> {
  late String type;
  late int index;

  @override
  void initState() {
    super.initState();
    type = widget.selectedType;
    index = widget.index;
  }

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
                value: type,
                items: amounts.map((amount) {
                  return amount;
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    type = newValue!;
                    widget.onChanged(index, type);
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

class StaticAmountWidget extends StatefulHookConsumerWidget {
  const StaticAmountWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    required this.previousPage,
    required this.headTitle,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;
  final String headTitle;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaticAmountWidgetState();
}

class _StaticAmountWidgetState extends ConsumerState<StaticAmountWidget> {
  String? selectedAmount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.headTitle, style: AppStyle.headingTwo),
        const Gap(6),
        Material(
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: .5),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return NumberFieldWidget(
                      maxLine: 1,
                      hintText: 'Amount',
                      txtController: widget.txtController,
                      selectedType: '',
                      previousPage: widget.previousPage,
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: MediaQuery.of(context).size.height / 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.right,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        controller: widget.txtController,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: widget.hintText,
                        ),
                        onSubmitted: (value) => ref
                            .read(valueForRuleProvider.notifier)
                            .update((state) => value),
                        maxLines: widget.maxLine,
                      ),
                    ),
                    const Gap(5),
                    const Center(child: Text('\$')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class MainDummyWidget extends StatefulHookConsumerWidget {
  const MainDummyWidget({
    Key? key,
    required this.maxLine,
    required this.hintText,
    required this.selectedType,
    required this.previousPage,
  }) : super(key: key);

  final String hintText;
  final int maxLine;
  final String selectedType;
  final PreviousPage previousPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainDummyWidgetState();
}

class _MainDummyWidgetState extends ConsumerState<MainDummyWidget> {
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
              color: Colors.grey.shade600,
            ),
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
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
                onChanged: (newValue) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GoalAmountDummy extends HookConsumerWidget {
  const GoalAmountDummy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: .5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(158, 158, 158, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            height: MediaQuery.of(context).size.height / 15,
            child: const Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.right,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: '0',
                    ),
                    maxLines: 1,
                  ),
                ),
                Gap(5),
                Center(child: Text('\$')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
