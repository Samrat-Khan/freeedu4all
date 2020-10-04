import 'package:education_community/main.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const Route = "Setting_Page";
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List _settingsOptionsName = ["Change Theme", "Privacy", "About", "SignOut"];
  List<IconData> _settingsOptionsIcon = [
    Icons.wb_sunny,
    Icons.privacy_tip_sharp,
    Icons.info,
    Icons.logout
  ];

  changeTheme() {
    print("Theme");
  }

  readPrivacy() {
    print("Privacy");
  }

  readAbout() {
    print("About");
  }

  logOut() {
    googleSignIn.signOut().whenComplete(
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings"),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(_settingsOptionsIcon[index]),
                title: Text(_settingsOptionsName[index]),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  switch (index) {
                    case 0:
                      changeTheme();
                      break;
                    case 1:
                      readPrivacy();
                      break;
                    case 2:
                      readAbout();
                      break;
                    case 3:
                      logOut();
                      break;
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
