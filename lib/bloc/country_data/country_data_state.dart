import 'package:crownapp/model/response/country_data.dart';
import 'package:flutter/foundation.dart';

abstract class CountryDataState {
  const CountryDataState();
}

class CountryDataEmpty extends CountryDataState {}

class CountryDataLoading extends CountryDataState {}

class CountryDataAvailable extends CountryDataState {
  final CountryData countryData;

  const CountryDataAvailable({@required this.countryData})
      : assert(countryData != null);
}

class CountryDataError extends CountryDataState {}
