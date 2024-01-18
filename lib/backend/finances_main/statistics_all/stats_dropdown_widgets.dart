import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatsDropDownOptions extends StatefulHookConsumerWidget {
  const StatsDropDownOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatsDropDownOptionsState();
}

class _StatsDropDownOptionsState extends ConsumerState<StatsDropDownOptions> {
  @override
  Widget build(BuildContext context) {
    String currentOption = 'Bar';
    final graphTypeList = ['Bar', 'Line', 'Pie'];

    return PopupMenuButton<String>(
      onSelected: (String filterBy) async {
        if (filterBy != currentOption) {
          setState(() {
            currentOption = filterBy;
          });
        }
      },
      itemBuilder: (context) {
        return graphTypeList.map((filterBy) {
          return PopupMenuItem<String>(
            value: filterBy,
            child: Text(filterBy),
          );
        }).toList();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4.5,
        child: Expanded(
          child: Column(children: [
            Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.only(left: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentOption),
                      ],
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
