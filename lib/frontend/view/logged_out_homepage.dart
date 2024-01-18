import 'package:flutter/material.dart';
import 'package:np_financr/frontend/view/calendarpage.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../user_auth_general/login_screen.dart';
import '../user_auth_general/user_regist_screen.dart';
import '../../backend/widgets/botnavbar_widget.dart';
import 'statisticspage.dart';
import 'monthly_main.dart';
import 'goalspage.dart';

class LoggedOutHomePage extends StatefulWidget {
  const LoggedOutHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoggedOutHomePage> createState() => _LoggedOutHomePageState();
}

class _LoggedOutHomePageState extends State<LoggedOutHomePage> {
  late int _currentIndex;
  late ValueChanged<int> onTappedbar;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose the _pageController when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          _loggedOutHomeUI(context),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: const [
                    Center(
                      child: Text(
                        'Home Page',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    Calendar(),
                    Stats(),
                    UpdatePageWidget(),
                    Goals(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentIndex,
          onTappedbar: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          }),
    );
  }
}

Widget _loggedOutHomeUI(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 9,
    decoration: BoxDecoration(
      color: HexColor("#456B4C"),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Column(
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
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Tasker',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
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
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
