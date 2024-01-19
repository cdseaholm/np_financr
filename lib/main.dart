import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_financr/backend/login_all/auth_page.dart';
import 'package:np_financr/data/models/firebase/firebase_options.dart';

import 'backend/finances_main/finance_git_trial/data/model/add_date.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<AddData>('data');

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'NewProgress-Financr',
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(176, 5, 53, 20),
      ),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw ('widget is null');
      },
    );
  }
}

enum PreviousPage {
  newPaycheck,
  editPaycheck,
  manager,
  ruleCreate,
  accountWidget,
  cardWidget,
  addCardWidget,
  editMonthlyUpdate,
  home,
  updaterAllWidget,
  previousMonthUpdates,
  updater,
  billCreate,
}
