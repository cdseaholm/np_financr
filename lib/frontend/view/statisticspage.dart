import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_financr/backend/finances_main/statistics_all/charts(all)/barCharts/bar_accounts_chart.dart';
import 'package:np_financr/backend/finances_main/statistics_all/charts(all)/linecharts/line_graph.dart';
import 'package:np_financr/backend/services/main_function_services/stat_filter_widget.dart';
import 'package:np_financr/backend/providers/main_function_providers/stat_services_and_providers/stat_providers.dart';
import 'package:np_financr/backend/widgets/filters/filter_services.dart';

import '../../backend/finances_main/statistics_all/charts(all)/barCharts/bar_paychecks_chart.dart';
import '../../backend/finances_main/statistics_all/charts(all)/barCharts/bar_rules_chart.dart';
import '../../backend/finances_main/statistics_all/charts(all)/projections_chart.dart';
import '../../backend/finances_main/statistics_all/stats_dropdown_widgets.dart';

class Stats extends HookConsumerWidget {
  const Stats({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statText = ref.watch(statFilterProvider);
    var statDropDownValue = ref.watch(statDropDownButtonState);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Financial Stats',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statistic Type'),
                    Gap(1),
                    StatFilterWidgetButton(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Graph Type:'),
                    Gap(1),
                    StatsDropDownOptions(),
                  ],
                ),
              ],
            ),
            const Divider(
              thickness: .6,
              color: Colors.black,
            ),
            const Gap(20),
            if (statDropDownValue == 'Bar' && statText.value == 'Accounts')
              BarAccountsChartWidget(
                selected: ref.read(statFilterButtonState),
              )
            else if (statDropDownValue == 'Bar' && statText.value == 'Cards')
              BarPaychecksChartWidget(
                selected: ref.read(statFilterButtonState),
              )
            else if (statDropDownValue == 'Bar' &&
                statText.value == 'Paychecks')
              BarPaychecksChartWidget(
                selected: ref.read(statFilterButtonState),
              )
            else if (statDropDownValue == 'Bar' && statText.value == 'Rules')
              const BarRulesChartWidget(),
            if (statDropDownValue == 'Graph')
              LineGraphWidget(selected: ref.read(statFilterButtonState)),
            if (statDropDownValue == 'Projections')
              ProjectionsChartWidget(selected: ref.read(statFilterButtonState)),
          ])),
    );
  }
}
