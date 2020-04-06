import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class CountryNotifier with ChangeNotifier {
  String _selectedCountryCode;

  get selectedCountryCode => _selectedCountryCode;

  get defaultCountry => CountryPickerUtils.getCountryByIsoCode('CO').name;

  set selectedCountryCode(String newCountryCode) {
    _selectedCountryCode = newCountryCode;
    notifyListeners();
  }
}
