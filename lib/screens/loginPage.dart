import 'package:education_community/screens/HomePage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsLoggedIn();
  }

  UserService userService = UserService();
  checkIsLoggedIn() async {
    isLoggedIn = await googleSignIn.isSignedIn();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handelSignInAccount(account);
    }).onError((error) {
      print("The error is $error");
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      //  circularProgressIndicatorX();
      handelSignInAccount(account);
    });
  }

  handelSignInAccount(GoogleSignInAccount account) {
    if (account != null) {
      userService.signInWithGoogle();
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == true ? loggedInHomepage() : firstSignInPage();
  }

  loggedInHomepage() {
    return Homepage();
  }

  Widget firstSignInPage() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/14.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Sign In with",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "images/google.png",
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ),
              onTap: () {
                try {
                  UserService userService = UserService();
                  userService.signInWithGoogle().then((result) {
                    if (result != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return Homepage();
                          },
                        ),
                      );
                    }
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
