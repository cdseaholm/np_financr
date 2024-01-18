import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/providers/main_function_providers/account_providers/selected_account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/selected_rule_providers.dart';
import 'package:np_financr/data/models/app_models/paycheck_model.dart';
import '../../../../../data/models/app_models/account_model.dart';
import '../../../../../data/models/app_models/rule_model.dart';
import 'selected_category_providers.dart';
import 'service_provider.dart';
import 'paycheck_providers.dart';

class ProvidersClear {
  void clearEditpaycheck(WidgetRef ref) {
    ref
        .read(paycheckUpdateStateProvider.notifier)
        .update((state) => PaycheckModel(
              docID: '',
              paycheckTitle: '',
              description: '',
              datepaycheck: '',
              ruleID: '',
              ruleName: '',
              amount: '',
              selectedAccount: '',
              creationDate: '',
            ));
    ref.read(selectedPaycheckProvider.notifier).update((state) => PaycheckModel(
          paycheckTitle: '',
          description: '',
          datepaycheck: '',
          ruleID: '',
          ruleName: '',
          amount: '',
          selectedAccount: '',
          creationDate: '',
        ));
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(repeatShownProvider.notifier).update((state) => 'No');
    ref.read(stopDateProvider.notifier).update((state) => 'Until?');
    ref.read(ruleOptions.notifier).update((state) => []);
    ref.read(accountOptions.notifier).update((state) => []);
  }

  void clearRuleProvidersCancel(WidgetRef ref) {
    ref.read(selectedPaycheckProvider.notifier).update((state) => PaycheckModel(
          paycheckTitle: '',
          description: '',
          datepaycheck: '',
          ruleID: '',
          ruleName: '',
          amount: '',
          selectedAccount: '',
          creationDate: '',
        ));
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');
    ref.read(accountOptions.notifier).update((state) => []);
    ref.read(ruleOptions.notifier).update((state) => []);
    ref.read(stopDateProvider.notifier).update((state) => 'Until?');

    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }

  void newPaycheckProviderClearCreate(TextEditingController title,
      TextEditingController description, WidgetRef ref) {
    title.clear();
    description.clear();

    ref.read(selectedPaycheckProvider.notifier).update((state) {
      return PaycheckModel(
        paycheckTitle: '',
        description: '',
        datepaycheck: '',
        ruleID: '',
        ruleName: '',
        amount: '',
        selectedAccount: '',
        creationDate: '',
      );
    });
    ref.read(selectedAccountProvider.notifier).update((state) => AccountModel(
          docID: '',
          accountTitle: '',
          description: '',
          creationDate: '',
          amount: '',
        ));
    ref.read(selectedRuleProvider.notifier).update(
        (state) => RuleModel(ruleID: '', ruleTitle: '', creationDate: ''));
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');

    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }

  void monthlyUpdateProviderClearCreate(
      TextEditingController title, WidgetRef ref) {
    title.clear();

    ref.read(selectedPaycheckProvider.notifier).update((state) {
      return PaycheckModel(
        paycheckTitle: '',
        description: '',
        datepaycheck: '',
        ruleID: '',
        ruleName: '',
        amount: '',
        selectedAccount: '',
        creationDate: '',
      );
    });
    ref.read(selectedAccountProvider.notifier).update((state) => AccountModel(
          docID: '',
          accountTitle: '',
          description: '',
          creationDate: '',
          amount: '',
        ));
    ref.read(selectedRuleProvider.notifier).update(
        (state) => RuleModel(ruleID: '', ruleTitle: '', creationDate: ''));
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');

    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }
}
