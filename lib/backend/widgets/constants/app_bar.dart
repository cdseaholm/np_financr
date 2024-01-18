import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../../frontend/view/logged_out_homepage.dart';
import '../../../frontend/user_auth_general/login_screen.dart';
import '../../../frontend/user_auth_general/profile_page.dart';
import '../../../frontend/user_auth_general/user_regist_screen.dart';
import '../display_name_widget.dart';

class AppBarCreated {
  AppBar buildAppBar(BuildContext context, String titleText) {
    final user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      return AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          backgroundColor: const Color.fromARGB(255, 76, 119, 85),
          elevation: 0,
          title: const ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        radius: 20,
                        child: Text(
                          'NP',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Gamer',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              title: Center(
                child: HomeDisplayNameWidget(),
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.bell),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.settings),
                    onSelected: (String value) {},
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: MaterialButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            ),
                            child: const Text('Profile'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          child: MaterialButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoggedOutHomePage()),
                              );
                            },
                            child: const Text('Logout'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        )
                      ];
                    },
                  ),
                ],
              ),
            ),
          ]);
    }
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                titleText,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const Gap(10),
          Flexible(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: Card(
                color: HexColor("c8dbc5"),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16.5, 8, 16.5, 8),
                  child: Text(
                    "Login",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: Card(
                color: HexColor("#c8dbc5"),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Register",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      leading: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


    /*LoggedOutExampleBeginning: 

    Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        decoration: const BoxDecoration(),
        child: Scaffold(
          appBar:
          */

    