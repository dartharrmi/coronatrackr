import 'package:crownapp/utils/pair.dart';
import 'package:flutter/material.dart';

class StatNotifier with ChangeNotifier {
  Pair<DateTime, int> _selectedDate;

  get selectedDate => _selectedDate;

  set selectedDate(Pair<DateTime, int> newSelectedDate) {
    _selectedDate = newSelectedDate;
    notifyListeners();
  }
}
