import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class CountryNotifier with ChangeNotifier {
  Country _selectedCountry;

  get selectedCountry => _selectedCountry;

  get defaultCountry => CountryPickerUtils.getCountryByIsoCode('CO');

  set selectedCountry(Country newCountry) {
    _selectedCountry = newCountry;
    notifyListeners();
  }
}
