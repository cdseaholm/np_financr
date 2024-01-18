import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_providers/profile_provider.dart';

class HomeDisplayNameWidget extends ConsumerWidget {
  const HomeDisplayNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUserData = ref.watch(userFieldsProvider);

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return currentUserData.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (credModel) {
              if (credModel == null) {
                return const Text("Your Finances");
              }

              String? displayName = credModel.displayName;
              return Text("$displayName's Finances");
            },
          );
        });
  }
}

class ProfileDisplayNameWidget extends ConsumerWidget {
  const ProfileDisplayNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUserData = ref.watch(userFieldsProvider);

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return currentUserData.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (credModel) {
              if (credModel == null) {
                return const Text("Profile Settings");
              }

              String? displayName = credModel.displayName;
              return Text("$displayName's Profile");
            },
          );
        });
  }
}
