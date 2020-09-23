import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 80,
        width: 100,
        padding: EdgeInsets.all(20),
        child: Text("Hello World"),
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/loading.gif"))),
      ),
    );
  }
}
