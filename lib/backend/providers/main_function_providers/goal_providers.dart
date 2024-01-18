import 'package:hooks_riverpod/hooks_riverpod.dart';

final colorProvider = StateProvider<String>((ref) {
  return '';
});

final goalTypeProvider = StateProvider<bool>((ref) {
  return true;
});
