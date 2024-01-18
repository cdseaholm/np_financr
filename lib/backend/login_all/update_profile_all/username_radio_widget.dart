import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UsernameRadioWidget extends ConsumerWidget {
  const UsernameRadioWidget({
    Key? key,
    required this.titleRadio,
    required this.valueInput,
    required this.index,
    required this.onChangeValue,
  }) : super(key: key);

  final String titleRadio;
  final bool valueInput;
  final int index;
  final ValueChanged<bool> onChangeValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    titleRadio,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  value: valueInput,
                  onChanged: (value) => onChangeValue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
