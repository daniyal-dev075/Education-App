import 'package:flutter/cupertino.dart';

class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void resetIndex() {
    _currentIndex = 0; // 👈 always go back to Home tab
    notifyListeners();
  }
}
