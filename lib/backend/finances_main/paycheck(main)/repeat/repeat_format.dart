import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/financeproviders/service_provider.dart';
import 'repeat_notifiers.dart';

String repeatFormat(List<String> days) {
  if (days.length > 3 && days.length < 7) {
    return "${days.length} Days a week";
  } else if (days.length == 7) {
    return 'Daily';
  } else if (days.length < 4 && days.length > 1) {
    return days.map((day) => day.substring(0, 3)).join(', ');
  }

  return 'No';
}

updateRepeatProviders(String time, String stop, WidgetRef ref) async {
  final days = selectedRepeatingDaysList;
  final frequency = frequencyNotifier.value;
  ref.read(stopDateProvider.notifier).update((state) => time);

  if (stop == 'Until?') {
    if (days.isNotEmpty && frequency == 'No') {
      ref
          .read(repeatShownProvider.notifier)
          .update((state) => repeatFormat(days));
    } else if (days.isEmpty && frequency != 'No') {
      ref.read(repeatShownProvider.notifier).update((state) => frequency);
    }
  } else if (stop != 'Until?') {
    if ((days.isNotEmpty && frequency == 'No')) {
      ref
          .read(repeatShownProvider.notifier)
          .update((state) => ('${repeatFormat(days)} until $stop'));
    } else if ((days.isEmpty && frequency != 'No')) {
      ref
          .read(repeatShownProvider.notifier)
          .update((state) => ('$frequency until $stop'));
    }
  } else {
    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }
}
