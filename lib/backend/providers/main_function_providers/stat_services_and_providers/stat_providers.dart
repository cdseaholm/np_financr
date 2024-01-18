import 'package:flutter_riverpod/flutter_riverpod.dart';

final statDropDownButtonState = StateProvider<String>((ref) {
  return 'Bar';
});

final statFilterButtonState = StateProvider<String>((ref) {
  return 'Accounts';
});
