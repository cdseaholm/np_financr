import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarRulesChartWidget extends ConsumerWidget {
  const BarRulesChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}




/*
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/finances(main)/rules(all)/rule_model.dart';
import 'package:np_financr/backend/finances(main)/rules(all)/ruleproviders/rule_provider.dart';
import 'package:np_financr/backend/paycheck(main)/paycheck_models/paycheck_model.dart';
import 'package:np_financr/backend/paycheck(main)/provider/financeproviders/paycheck_providers.dart';

class BarRulesChartWidget extends StatefulHookConsumerWidget {
  const BarRulesChartWidget({required this.selected, super.key});

  final String selected;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends ConsumerState<BarRulesChartWidget> {
  late List<RuleModel> rules;

  double minYValue = double.maxFinite;

  @override
  void initState() {
    super.initState();
    rules = ref.read(ruleListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final xValues = rules
        .map((rule) => RuleModel(ruleTitle: rule.ruleTitle, creationDate: rule.creationDate))
        .toList();

    final List<BarChartGroupData> barGroups = [];
    double maxValue = double.negativeInfinity;
    double minValue = double.infinity;
    
    double minY = -maxValue;
    double maxY = maxValue;
    final Map<int, double> amountsMap = {};
    
    for (var i = 0; i < rules.length; i++) {
      amountsMap[i] = double.parse(rules[i].amount);
      final groupData = BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: double.parse(rules[i].amount),
            width: 12,
            color: Colors.blue,
          ),
        ],
      );

      barGroups.add(groupData);
    }
    bool showToolTip = false;
    
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 2.3,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
              touchCallback: (p0, p1) {
                if (showToolTip == false) {
                  setState(() {
                    showToolTip == true;
                  });
                } else if (showToolTip == true) {
                  setState(() {
                    showToolTip == false;
                  });
                }
              },
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: BarTouchTooltipData(
                  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                  tooltipBgColor: Colors.black,
                  tooltipBorder:
                      const BorderSide(color: Colors.black, width: 1))),
          borderData: FlBorderData(
              border: const Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1),
                  bottom: BorderSide(width: 1))),
          minY: minY,
          maxY: maxY,
          groupsSpace: 10,
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(
              reservedSize: 44,
              showTitles: true,
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              reservedSize: 30,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < xValues.length) {
                  final title = xValues[value.toInt()].ruleTitle;
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Transform.rotate(
                      alignment: AlignmentDirectional.centerStart,
                      origin: const Offset(8, 12),
                      angle: .9,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            )),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(y: 0, strokeWidth: 1, color: Colors.black)
            ],
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
*/