import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';

import 'editProfilePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List _settingsOptionsName = [
    "Edit Profile",
    "Draft Posts",
    "Privacy",
    "About",
    "Delete Account",
    "SignOut"
  ];
  List<IconData> _settingsOptionsIcon = [
    Icons.edit_rounded,
    Icons.article_rounded,
    Icons.privacy_tip_sharp,
    Icons.info,
    Icons.delete_forever_rounded,
    Icons.logout
  ];

  draftPost() {}
  deleteAccount() {}

  readPrivacy() {
    print("Privacy");
  }

  readAbout() {
    print("About");
  }

  logOut() async {
    EmailAuth _emailAuth = EmailAuth();
    await _emailAuth.signOut().whenComplete(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
          (route) => false);
    });
  }

  editProfile() {
    Navigator.pushNamed(
      context,
      "EditProfilePage",
      arguments: EditProfilePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Settings",
            style: kSettingTitle,
          ),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  _settingsOptionsIcon[index],
                  color: Colors.black,
                ),
                title: Text(
                  _settingsOptionsName[index],
                  style: kSettingMenu,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                ),
                onTap: () {
                  switch (index) {
                    case 0:
                      return editProfile();
                    case 1:
                      return draftPost();
                    case 2:
                      return readPrivacy();
                    case 2:
                      return readAbout();
                    case 4:
                      return deleteAccount();
                    case 5:
                      return logOut();
                  }
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: _settingsOptionsName.length),
      ),
    );
  }
}
