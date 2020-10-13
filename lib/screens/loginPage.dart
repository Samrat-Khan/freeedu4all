import 'package:education_community/providerServices/authUserProvider.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/screens/bottomAppBar.dart';
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
  bool showPassword = true;
  TextEditingController _emailForExistUser = TextEditingController();
  TextEditingController _passwordForExistUser = TextEditingController();
  TextEditingController _emailForNewUser = TextEditingController();
  TextEditingController _passwordForNewUser = TextEditingController();
  final GlobalKey<FormState> _formKeyForNewUser = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForExistUser = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
    _passwordForExistUser.dispose();
    _emailForExistUser.dispose();
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
        key: _key,
        body: Stack(
          children: [
            Container(
              height: _height,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.black,
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
                controller: _emailForExistUser,
                validator: (val) => isEmailValid(val) ? null : "Invalid Email",
                keyboardType: TextInputType.emailAddress,
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
                controller: _passwordForExistUser,
                obscureText: showPassword,
                validator: (val) =>
                    isPasswordValid(val) ? null : "Check Your Password",
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: toggleVisibility,
                  ),
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
            child: Text(
              "log In",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => logIn(),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "Forgot Password ?",
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, "ForgotPassword"),
            ),
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
                controller: _emailForNewUser,
                validator: (val) => isEmailValid(val) ? null : "Invalid Email",
                keyboardType: TextInputType.emailAddress,
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
                controller: _passwordForNewUser,
                validator: (val) =>
                    isPasswordValid(val) ? null : "Check Your Password",
                obscureText: showPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: toggleVisibility,
                  ),
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
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => signUp(),
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
  toggleVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  logIn() async {
    try {
      if (_formKeyForExistUser.currentState.validate()) {
        setState(() {
          _inAsyncCall = true;
        });
        dynamic user = await _emailAuth.signInWithEmail(
            email: _emailForExistUser.text,
            password: _passwordForExistUser.text);

        if (user ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          _passwordForExistUser.clear();
          final snackbar =
              SnackBar(content: Text("Please Check Your Email Or Password"));
          _key.currentState.showSnackBar(snackbar);
          setState(() {
            _inAsyncCall = false;
          });
        } else {
          bool userExist = await _userExist.checkIfUserAlreadyExist(user.uid);
          if (!userExist) {
            Navigator.pushNamed(context, "AddNewUserDataPage",
                arguments: LoginToNewUser(user));
            setState(() {
              _inAsyncCall = false;
            });
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavigationAppBar()),
                (route) => false);
            setState(() {
              _inAsyncCall = false;
            });
          }
        }
      }
    } catch (e) {
      final snackBar =
          SnackBar(content: Text("Please Check Your Email Or Password"));
      _key.currentState.showSnackBar(snackBar);
      setState(() {
        _inAsyncCall = false;
      });
    }
  }

  signUp() async {
    try {
      setState(() {
        _inAsyncCall = true;
      });
      if (_formKeyForNewUser.currentState.validate()) {
        dynamic user = await _emailAuth.signUpWithEmail(
            email: _emailForNewUser.text, password: _passwordForNewUser.text);

        if (user ==
            "The email has already been registered. Please login or reset your password.") {
          final snackBar = SnackBar(
              content: Text(
                  "The email has already been registered. Please login or reset your password."));
          _key.currentState.showSnackBar(snackBar);
          setState(
            () {
              _inAsyncCall = false;
            },
          );
        } else {
          await _emailAuth.verifyEmail();
          Navigator.pushNamed(context, "AddNewUserDataPage",
              arguments: LoginToNewUser(user));
          setState(() {
            _inAsyncCall = false;
          });
        }
      }
    } catch (e) {
      final snackBar = SnackBar(
          content: Text(
              "The email has already been registered. Please login or reset your password."));
      _key.currentState.showSnackBar(snackBar);
      setState(() {
        _inAsyncCall = false;
      });
    }
  }

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
          Navigator.pushReplacementNamed(context, "BottomAppBar");
          setState(() {
            _inAsyncCall = false;
          });
        } else {
          Navigator.pushReplacementNamed(context, "BottomAppBar");
          setState(() {
            _inAsyncCall = false;
          });
        }
      }
    } catch (e) {}
  }
}

// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(),
          Container(
            height: _height * 0.4,
            width: _width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                        hintText: "example@mail.com",
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
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => doPasswordReset(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  EmailAuth _emailAuth = EmailAuth();
  doPasswordReset(BuildContext context) async {
    try {
      await _emailAuth.forgotPassword(email: _controller.text).whenComplete(() {
        final snackBar =
            SnackBar(content: Text("Check Your Email, we've send a link"));
        _key.currentState.showSnackBar(snackBar);
        Future.delayed(Duration(seconds: 3))
            .then((value) => Navigator.of(context).pop());
      });
    } catch (e) {
      final snackBar = SnackBar(
          content: Text("An Unexpected error occurs, please try again later"));
      _key.currentState.showSnackBar(snackBar);
    }
  }
}
