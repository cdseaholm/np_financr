import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../data/models/app_models/paycheck_model.dart';

class SelectedPaycheck {
  final PaycheckModel model;

  SelectedPaycheck({required this.model});
}

final selectedPaycheckProvider = StateProvider<PaycheckModel>((ref) {
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

final categoryUpdateRadioProvider = StateProvider<PaycheckModel>((ref) {
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
