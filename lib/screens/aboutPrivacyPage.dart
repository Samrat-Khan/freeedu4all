import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';

class AboutPrivacyPage extends StatelessWidget {
  final String text;
  AboutPrivacyPage({this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          text,
          style: kSettingTitle,
        ),
      ),
      body: SingleChildScrollView(),
    );
  }
}
