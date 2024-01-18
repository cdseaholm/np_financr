import 'package:flutter/material.dart';

ValueNotifier<String> frequencyNotifier = ValueNotifier<String>('No');

ValueNotifier<String> repeatUntilNotifier = ValueNotifier<String>('Until?');

ValueNotifier<List<String>> selectedDaysNotifier =
    ValueNotifier<List<String>>([]);

List<String> selectedRepeatingDaysList = [];

bool showDaysHint = false;
