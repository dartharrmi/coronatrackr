import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:flutter/material.dart';

class CountryNotifier with ChangeNotifier {
  CovidCountry _selectedCountry;

  get selectedCountry => _selectedCountry;

  get defaultCountry => CountryPickerUtils.getCountryByIsoCode('CO');

  set selectedCountry(CovidCountry newCountry) {
    _selectedCountry = newCountry;
    notifyListeners();
  }
}
