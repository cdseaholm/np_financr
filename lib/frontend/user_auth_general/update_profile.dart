// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../backend/widgets/constants/constants.dart';
import '../../backend/widgets/textfield_widget.dart';
import '../../backend/login_all/auth_provider.dart';
import 'forgotpassword.dart';
import '../../backend/providers/auth_providers/profile_provider.dart';

class UpdateProfileModel extends ConsumerStatefulWidget {
  const UpdateProfileModel({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfileModelState();
}

class _UpdateProfileModelState extends ConsumerState<UpdateProfileModel> {
  String? chosenValue;
  bool showCustomUsernameField = false;
  final customUsernameController = TextEditingController();

  @override
  void dispose() {
    customUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userFieldsProvider).when(
        error: (error, stackTrace) => Text(stackTrace.toString()),
        loading: () => const CircularProgressIndicator(),
        data: (credModel) {
          final usernameOptions = [
            credModel!.firstName,
            credModel.fullName,
            credModel.email,
            credModel.lastName,
            credModel.customUsername,
          ].where((value) => value != null).toList();

          if (credModel.customUsername != null) {
            usernameOptions.add("Change Username");
          } else {
            usernameOptions.add("Add Custom Username");
          }

          debugPrint('usernameOptions: $usernameOptions');

          final dropdownItems = usernameOptions.map((value) {
            return DropdownMenuItem<String?>(
              value: value,
              child: Text(
                "Change to: ${value!}",
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList();

          return Container(
              padding: const EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Update Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Divider(
                      thickness: 1.2,
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black87)),
                            child: DropdownButton<String?>(
                              isExpanded: false,
                              focusColor: Colors.white,
                              value: chosenValue,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              items: dropdownItems,
                              hint: const Text(
                                "Change Username",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String? value) {
                                print('Selected value: $value');
                                setState(() {
                                  chosenValue = value;
                                  if (credModel.customUsername != null) {
                                    showCustomUsernameField =
                                        value == 'Change Username';
                                  } else {
                                    showCustomUsernameField =
                                        value == 'Add Custom Username';
                                  }
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: showCustomUsernameField,
                            child: TextFieldWidget(
                              maxLine: 1,
                              hintText: 'Create Your Own Custom Username',
                              txtController: customUsernameController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Update Email',
                          style: AppStyle.headingOne,
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ForgotPassword()),
                              );
                            },
                            child: const Text('Change Password',
                                style: AppStyle.headingOne),
                          ),
                        ]),
                    const Gap(12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Update Other inforamtion',
                          style: AppStyle.headingOne,
                        ),
                      ],
                    ),
                    const Gap(12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Feedback Form',
                          style: AppStyle.headingOne,
                        ),
                      ],
                    ),
                    const Gap(12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Other Settings',
                          style: AppStyle.headingOne,
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade800,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: Builder(builder: (context) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () async {
                                final userID =
                                    ref.read(authStateProvider).maybeWhen(
                                          data: (user) => user?.uid,
                                          orElse: () => null,
                                        );

                                if (userID != null && chosenValue != null) {
                                  final profileService =
                                      ref.read(profileServiceProvider);

                                  if (chosenValue == usernameOptions.last) {
                                    profileService.updateCustomUsername(userID,
                                        customUsernameController.text.trim());
                                  } else {
                                    profileService.updateDisplayName(
                                        userID, chosenValue!);
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Username updated successfully!'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to update username. Please try again.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Save'),
                            );
                          }),
                        ),
                      ],
                    )
                  ]));
        });
  }
}
