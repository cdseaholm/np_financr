import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DisplayDefaultPaycheck extends ConsumerStatefulWidget {
  const DisplayDefaultPaycheck({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DisplayDefaultPaycheckState();
}

class _DisplayDefaultPaycheckState
    extends ConsumerState<DisplayDefaultPaycheck> {
  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    final dateFormat = DateFormat('MM/dd/yy');
    final timeFormat = DateFormat('hh:mm');
    final date = dateFormat.format(time);
    final timeToShow = timeFormat.format(time);
    bool doneButton = false;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: .5)),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
                color: colorFromHex('#4C7755'),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            width: 30,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: BorderSide.strokeAlignCenter),
                                maximumSize: const Size(80, 45),
                                backgroundColor: const Color(0xFFD5E8FA),
                                foregroundColor: Colors.blue.shade800,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {},
                            child: const Text(
                              'Edit paycheck',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          title: const Text('Example paycheck!',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          subtitle: const Text(
                            "Click the Circle on the right when completed!",
                            maxLines: 2,
                          ),
                          trailing: Transform.scale(
                              scale: 1.2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.blue.shade800,
                                      shape: const CircleBorder(),
                                      value: doneButton,
                                      onChanged: (value) {
                                        setState(() {
                                          doneButton = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              )),
                        ),
                        const Gap(5),
                        Transform.translate(
                            offset: const Offset(0, -12),
                            child: Column(children: [
                              const Divider(
                                thickness: 1.5,
                                color: Colors.black38,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$date, $timeToShow'),
                                    const Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: Text('Status',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ])
                            ]))
                      ])))
        ]));
  }
}
