import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoalBars extends ConsumerStatefulWidget {
  const GoalBars({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalBarsState();
}

class _GoalBarsState extends ConsumerState<GoalBars> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 2.3,
    );
  }
}
