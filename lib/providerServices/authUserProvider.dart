import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _user, _email;
  String get user => _user;
  getUser(String currentUser) {
    _user = currentUser;
    notifyListeners();
  }

  String get email => _email;
  getEmail(String currentEmail) {
    _email = currentEmail;
    notifyListeners();
  }
}
