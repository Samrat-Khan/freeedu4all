import 'package:education_community/providerServices/authUserProvider.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isLoggedIn = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKeyForNewUser = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForExistUser = GlobalKey<FormState>();
  String email, password;
  bool isEmailValid(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isPasswordValid(password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  bool crossFadeSwipe = true;
  signInOrUp(bool value) {
    if (value) {
      setState(() {
        crossFadeSwipe = true;
      });
    } else {
      setState(() {
        crossFadeSwipe = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _password.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Homepage() : firstSignInPage();
  }

  Widget firstSignInPage() {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: _height,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            Center(
              child: Container(
                height: _height * 0.6,
                width: _width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: AnimatedCrossFade(
                  firstCurve: Curves.easeIn,
                  secondCurve: Curves.easeOutSine,
                  sizeCurve: Curves.easeInCubic,
                  duration: const Duration(milliseconds: 700),
                  firstChild: formForExistUser(),
                  secondChild: formForNewUser(),
                  crossFadeState: crossFadeSwipe
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ),
          ],
        ),
      ),
      inAsyncCall: _inAsyncCall,
    );
  }

  Form formForExistUser() {
    return Form(
      key: _formKeyForExistUser,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                controller: _email,
                validator: (val) => isEmailValid(val) ? null : "Invalid Email",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.yellowAccent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                controller: _password,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) =>
                    isPasswordValid(val) ? null : "Check Your Password",
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.yellowAccent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("log In"),
            onPressed: () async {
              if (_formKeyForExistUser.currentState.validate()) {
                setState(() {
                  _inAsyncCall = true;
                });
                User user = await _emailAuth.signInWithEmail(
                    email: _email.text, password: _password.text);
                bool userExist =
                    await _userExist.checkIfUserAlreadyExist(user.uid);
                if (!userExist) {
                  Navigator.pushNamed(context, "AddNewUserDataPage",
                      arguments: LoginToNewUser(user));
                  setState(() {
                    _inAsyncCall = false;
                  });
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                      (route) => false);
                  setState(() {
                    _inAsyncCall = false;
                  });
                }
              }
            },
          ),
          SizedBox(height: 5),
          Text(
            "Or",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: ClipRRect(
                  child: Image.asset(
                    "images/google.png",
                    width: 30,
                    height: 30,
                  ),
                ),
                onTap: () {
                  // callFirebaseGAuth(context);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "Don't have and account? ",
              style: TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        signInOrUp(false);
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form formForNewUser() {
    return Form(
      key: _formKeyForNewUser,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                controller: _email,
                validator: (val) => isEmailValid(val) ? null : "Invalid Email",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.yellowAccent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                controller: _password,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) =>
                    isPasswordValid(val) ? null : "Check Your Password",
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Password",
                  helperMaxLines: 4,
                  helperText:
                      "Password.length must be 8 \nPassword ust contains 1 Upper Case \nPassword must contains at least 1 Number \nand 1 Special Character",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.yellowAccent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("Sign Up"),
            onPressed: () async {
              setState(() {
                _inAsyncCall = true;
              });
              if (_formKeyForNewUser.currentState.validate()) {
                User user = await _emailAuth.signUpWithEmail(
                    email: _email.text, password: _password.text);
                await _emailAuth.verifyEmail();
                Navigator.pushNamed(context, "AddNewUserDataPage",
                    arguments: LoginToNewUser(user));
                setState(() {
                  _inAsyncCall = false;
                });
              }
            },
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Sign In",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        signInOrUp(true);
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  EmailAuth _emailAuth = EmailAuth();
  CheckUserExist _userExist = CheckUserExist();
  bool _inAsyncCall = false;
  getCurrentUser() async {
    try {
      setState(() {
        _inAsyncCall = true;
      });
      User user = await _emailAuth.getCurrentUser();
      if (user == null) {
        setState(() {
          _inAsyncCall = false;
        });
      } else {
        bool isEmailVerify = await _emailAuth.isEmailVerify();
        Provider.of<UserProvider>(context, listen: false).getUser(user.uid);
        if (!isEmailVerify) {
          await _emailAuth.verifyEmail();
          Navigator.pushReplacementNamed(context, "Homepage");
          setState(() {
            _inAsyncCall = false;
          });
        } else {
          Navigator.pushReplacementNamed(context, "Homepage");
          setState(() {
            _inAsyncCall = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
