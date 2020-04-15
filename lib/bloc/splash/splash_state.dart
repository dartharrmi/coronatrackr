import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:flutter/foundation.dart';

abstract class CountryListState {
  const CountryListState();
}

class CountryListEmpty extends CountryListState {}

class CountryListLoading extends CountryListState {}

class CountryListAvailable extends CountryListState {
  final List<CovidCountry> countryList;

  const CountryListAvailable({@required this.countryList})
      : assert(countryList != null);
}

class CountryListError extends CountryListState {}
