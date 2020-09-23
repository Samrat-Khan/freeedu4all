import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              children: [
                Text("widget.user.displayName"),
                IconButton(
                    icon: Icon(Icons.signal_cellular_4_bar_outlined),
                    onPressed: () {
                      UserService userService = UserService();
                      userService.signOutFromGoogle().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogInPage(),
                          ),
                        );
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
