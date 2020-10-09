import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  String currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}
