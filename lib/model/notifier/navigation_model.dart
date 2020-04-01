import 'package:flutter/material.dart';

/// Provider for updating the navigation page.
class NavigationModel with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
