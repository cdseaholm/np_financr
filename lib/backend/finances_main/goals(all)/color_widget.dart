import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/goal_providers.dart';

import '../../widgets/constants/constants.dart';

class ColorWidget extends StatefulHookConsumerWidget {
  const ColorWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ColorWidgetState();
}

class _ColorWidgetState extends ConsumerState<ColorWidget> {
  @override
  Widget build(BuildContext context) {
    final shownColor = ref.watch(colorProvider);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color',
            style: AppStyle.headingTwo,
          ),
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
                        return const SelectColorMethod();
                      });
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
                      if (shownColor != '')
                        CircleAvatar(
                          backgroundColor: colorFromHex(shownColor),
                          radius: 8,
                        ),
                      if (shownColor == '') const Text('No Color Selected')
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

class SelectColorMethod extends StatefulHookConsumerWidget {
  const SelectColorMethod({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectColorMethodState();
}

class _SelectColorMethodState extends ConsumerState<SelectColorMethod> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
