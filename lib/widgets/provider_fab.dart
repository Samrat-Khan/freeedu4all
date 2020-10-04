import 'package:flutter/foundation.dart';

class ShowOrHide with ChangeNotifier {
  bool isVisible = true;
  void handelShowHide(bool visible) {
    this.isVisible = visible;
    notifyListeners();
  }
}
