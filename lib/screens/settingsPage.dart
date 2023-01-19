import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'editProfilePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String currentUserId;
  bool _inAsyncCall = false;
  List _settingsOptionsName = [
    "Edit Profile",
    "Draft Blog",
    "Privacy",
    "About",
    "SignOut"
  ];
  List<IconData> _settingsOptionsIcon = [
    Icons.edit_rounded,
    Icons.article_rounded,
    Icons.privacy_tip_sharp,
    Icons.info,
    Icons.logout
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  draftPost() {
    Navigator.pushNamed(context, "DraftPost");
  }

  readPrivacy() {
    Navigator.pushNamed(context, "AboutPrivacyPage",
        arguments: SettingToReadPrivacy(text: "Privacy"));
  }

  readAbout() {
    Navigator.pushNamed(context, "AboutPrivacyPage",
        arguments: SettingToReadPrivacy(text: "About"));
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
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: SafeArea(
        child: Scaffold(
          key: _key,
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
                      case 3:
                        return readAbout();

                      case 4:
                        return logOut();
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _settingsOptionsName.length),
        ),
      ),
    );
  }
}
