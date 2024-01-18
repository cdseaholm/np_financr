import 'package:hooks_riverpod/hooks_riverpod.dart';

final displayNameRadioProvider = StateProvider<int>((ref) {
  return 0;
});

int selectedUsernameOptionIndex = 1;
