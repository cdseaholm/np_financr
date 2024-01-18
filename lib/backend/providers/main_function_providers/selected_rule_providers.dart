import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/app_models/rule_model.dart';

class SelectedRule {
  final RuleModel model;

  SelectedRule({required this.model});
}

final selectedRuleProvider = StateProvider<RuleModel>((ref) {
  return RuleModel(
    ruleTitle: '',
    creationDate: '',
  );
});

final ruleUpdateRadioProvider = StateProvider<RuleModel>((ref) {
  return RuleModel(
    ruleTitle: '',
    creationDate: '',
  );
});

final isGoodProvider = StateProvider<bool>((ref) {
  return false;
});
