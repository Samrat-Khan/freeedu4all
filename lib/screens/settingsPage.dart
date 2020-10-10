import 'package:education_community/providerServices/darkTheme.dart';
import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editProfilePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List _settingsOptionsName = [
    "Edit Profile",
    "Change Theme",
    "Privacy",
    "About",
    "SignOut"
  ];
  List<IconData> _settingsOptionsIcon = [
    Icons.edit_rounded,
    Icons.wb_sunny,
    Icons.privacy_tip_sharp,
    Icons.info,
    Icons.logout
  ];
  bool isSwitch = false;
  EmailAuth _emailAuth = EmailAuth();
  changeTheme() {
    setState(() {
      isSwitch = !isSwitch;
      Provider.of<DarkToLightTheme>(context, listen: false)
          .changeTheme(isSwitch);
    });
  }

  readPrivacy() {
    print("Privacy");
  }

  readAbout() {
    print("About");
  }

  logOut() async {
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
    var themeProvider = Provider.of<DarkToLightTheme>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Settings"),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: index != 1
                    ? Icon(_settingsOptionsIcon[index])
                    : Icon(themeProvider.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny),
                title: Text(_settingsOptionsName[index]),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  switch (index) {
                    case 0:
                      return editProfile();
                    case 1:
                      return changeTheme();

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
    );
  }
}
