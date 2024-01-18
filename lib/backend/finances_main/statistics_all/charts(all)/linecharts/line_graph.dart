import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';

import '../../../../../data/models/app_models/account_model.dart';

class LineGraphWidget extends StatefulHookConsumerWidget {
  const LineGraphWidget({required this.selected, super.key});

  final String selected;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LineGraphWidgetState();
}

class _LineGraphWidgetState extends ConsumerState<LineGraphWidget> {
  late List<AccountModel> accounts;

  double minYValue = double.maxFinite;

  @override
  void initState() {
    super.initState();
    accounts = ref.read(accountListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final xValues = accounts
        .map((account) => AccountModel(
            accountTitle: account.accountTitle,
            description: account.description,
            creationDate: account.creationDate,
            amount: account.amount))
        .toList();

    final List<BarChartGroupData> barGroups = [];
    double maxValue = double.negativeInfinity;
    double minValue = double.infinity;
    for (var account in accounts) {
      double amount = double.parse(account.amount);
      if (amount > maxValue) {
        maxValue = amount;
      }
      if (amount < minValue) {
        minValue = amount;
      }
    }
    double minY = -maxValue;
    double maxY = maxValue;
    final Map<int, double> amountsMap = {};
    for (var i = 0; i < accounts.length; i++) {
      amountsMap[i] = double.parse(accounts[i].amount);
      final groupData = BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: double.parse(accounts[i].amount),
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
                  final title = xValues[value.toInt()].accountTitle;
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
