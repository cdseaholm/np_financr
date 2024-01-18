import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/models/app_models/account_model.dart';

class SelectedAccount {
  final AccountModel model;

  SelectedAccount({required this.model});
}

final selectedAccountProvider = StateProvider<AccountModel>((ref) {
  return AccountModel(
    docID: '',
    accountTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});

final accountUpdateRadioProvider = StateProvider<AccountModel>((ref) {
  return AccountModel(
    docID: '',
    accountTitle: '',
    description: '',
    creationDate: '',
    amount: '',
  );
});

final goalFilterProvider = StateProvider<String>((ref) {
  return 'Accounts';
});
