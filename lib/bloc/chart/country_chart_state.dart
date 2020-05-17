import 'package:crownapp/model/response/country_data.dart';
import 'package:flutter/foundation.dart';

abstract class CountryChartState {
  const CountryChartState();
}

class CountryChartEmpty extends CountryChartState {}

class CountryChartLoading extends CountryChartState {}

class CountryChartAvailable extends CountryChartState {
  final List<CountryDetails> countryChart;

  const CountryChartAvailable({@required this.countryChart})
      : assert(countryChart != null);
}

class CountryChartError extends CountryChartState {}
