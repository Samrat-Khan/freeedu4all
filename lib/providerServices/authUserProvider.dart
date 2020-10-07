import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _user;
  String get user => _user;
  getUser(String currentUser) {
    _user = currentUser;
    notifyListeners();
  }
}
