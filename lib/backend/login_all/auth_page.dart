import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_financr/backend/providers/main_function_providers/account_providers/account_providers.dart';
import 'package:np_financr/backend/providers/main_function_providers/rule_provider.dart';
import 'package:np_financr/backend/services/main_function_services/goal_services.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_bills.dart';
import 'package:np_financr/backend/providers/main_function_providers/providers_monthly_model.dart';
import 'package:np_financr/backend/finances_main/paycheck(main)/provider/financeproviders/service_provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../frontend/view/logged_in_homepage.dart';
import '../../frontend/view/logged_out_homepage.dart';
import '../providers/main_function_providers/card_provider.dart';
import '../../frontend/user_auth_general/forgotpassword.dart';
import '../../frontend/user_auth_general/user_regist_screen.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ref.read(fetchAccounts);
            ref.read(fetchPaychecks);
            ref.read(fetchRules);
            ref.read(fetchGoals);
            ref.read(fetchCards);
            ref.read(fetchBillDetails);
            ref.read(fetchMonthlyUpdates);
            return const LoggedInHomePage();
          } else {
            return const LoggedOutHomePage();
          }
        },
      ),
    );
  }
}

class LoginService {
  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoggedInHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        if (email.trim().isEmpty) {
          showErrorMessage(context, 'Email cannot be empty');
        } else if (password.trim().isEmpty) {
          showErrorMessage(context, 'Password cannot be empty');
        } else if (e.code == 'user-not-found') {
          wrongEmailMessage(context);
        } else if (e.code == 'wrong-password') {
          wrongPasswordMessage(context);
        } else if (e.code == 'user-disabled') {
          showErrorMessage(context, 'User disabled');
        } else if (e.code == 'invalid-email') {
          showErrorMessage(context, 'Invalid email');
        } else {
          showErrorMessage(context, 'Unknown error occurred');
        }
      }
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: HexColor("#456B4C"),
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void wrongEmailMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The Email was Incorrect',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Click here for Signup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 40),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

  void wrongPasswordMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The Password was Incorrect',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPassword(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password? Click here',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 40),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }
}
