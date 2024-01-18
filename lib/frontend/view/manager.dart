import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/card_provider.dart';
import 'package:np_financr/backend/providers/main_function_providers/rule_provider.dart';
import 'package:np_financr/backend/widgets/filters/filter_services.dart';
import 'via_manager/account_main_card_widget.dart';
import 'via_manager/main_card_card_widget.dart';
import 'via_manager/rule_card_widget.dart';
import 'via_manager/default_paycheck.dart';
import 'via_manager/paycheck_card_widget.dart';
import '../../backend/finances_main/paycheck(main)/provider/financeproviders/paycheck_providers.dart';
import 'via_manager/all_home_view.dart';

class Manager extends ConsumerWidget {
  const Manager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerList = [
      'accounts',
      'cards',
      'goals',
      'reports',
      'paychecks',
      'rules'
    ];
    final paychecks = ref.watch(paycheckListProvider);
    var filterView = ref.watch(filterProvider);
    final accounts = ref.watch(accountListProvider);
    final cards = ref.watch(cardListProvider);
    final rules = ref.watch(ruleListProvider);
    return ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.transparent,
              Colors.transparent,
              Colors.purple
            ],
            stops: [0.0, 0.10, 0.93, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Column(children: [
          if (filterView.value == 'All')
            Expanded(
                child: ListView.builder(
              itemCount: providerList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return AllHomeView(getIndex: index);
              },
            ))
          else if (filterView.value == 'Paychecks' && paychecks.isEmpty)
            const DisplayDefaultPaycheck()
          else if (filterView.value == 'Paychecks' && paychecks.isNotEmpty)
            Expanded(
                child: ListView.builder(
              itemCount: paychecks.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return PaycheckToolListWidget(getIndex: index);
              },
            ))
          else if (filterView.value == 'Accounts' && accounts.isEmpty)
            const DisplayDefaultPaycheck()
          else if (filterView.value == 'Accounts' && accounts.isNotEmpty)
            Expanded(
                child: ListView.builder(
              itemCount: accounts.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return AccountToolListWidget(getIndex: index);
              },
            ))
          else if (filterView.value == 'Cards' && cards.isEmpty)
            const DisplayDefaultPaycheck()
          else if (filterView.value == 'Cards' && cards.isNotEmpty)
            Expanded(
                child: ListView.builder(
              itemCount: cards.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return CardToolListWidget(getIndex: index);
              },
            ))
          else if (filterView.value == 'Rules' && rules.isEmpty)
            const DisplayDefaultPaycheck()
          else if (filterView.value == 'Rules' && rules.isNotEmpty)
            Expanded(
                child: ListView.builder(
              itemCount: rules.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return RuleToolListWidget(getIndex: index);
              },
            ))
        ]));
  }
}
