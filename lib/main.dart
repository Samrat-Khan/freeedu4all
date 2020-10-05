import 'package:education_community/providerServices/darkTheme.dart';
import 'package:education_community/routes/routeGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      child: MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => DarkToLightTheme()),
      ],
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  bool _value;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      if (sharedPreferences.getBool("Dark") == null) {
        _value = false;
        Provider.of<DarkToLightTheme>(context, listen: false)
            .changeTheme(_value);
      } else {
        _value = sharedPreferences.getBool("Dark");
        Provider.of<DarkToLightTheme>(context, listen: false)
            .changeTheme(_value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<DarkToLightTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData.isDark ? ThemeData.dark() : ThemeData.light(),
      initialRoute: "/LoginPage",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
