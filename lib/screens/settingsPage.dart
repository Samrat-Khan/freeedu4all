import 'package:education_community/providerServices/darkTheme.dart';
import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<DarkToLightTheme>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings"),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: index != 0
                    ? Icon(_settingsOptionsIcon[index])
                    : Icon(themeProvider.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny),
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
