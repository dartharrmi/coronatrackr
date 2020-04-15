import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

class NetworkManager {
  final _client = new http.Client();
  final _baseUrl = "https://api.covid19api.com/";
  final _getConfirmedByCountry = "country/%s/status/confirmed";
  final _getDeathsByCountry = "country/%s/status/deaths";
  final _getRecoveredByCountry = "country/%s/status/recovered";
  final _getAffectedCountries = "countries";

  Future<List<CovidCountry>> getAffectedCountries() async {
    print('Looking affected countries');
    var response = await _client.get('$_baseUrl$_getAffectedCountries');

    try {
      if (response.statusCode == 200) {
        print('Countries retrieved successfuly');
        print('Parsing response');

        var rawData = json.decode(response.body);
        print('Response:\n $rawData');
        final listOfCountries = List<CovidCountry>.from(
            rawData.map((item) => CovidCountry.fromMap(item)));
        print('Parsing data finished');

        return listOfCountries;
      } else {
        throw new Exception('Error fetching data :(');
      }
    } catch (e) {
      print(e);
      return List<CovidCountry>();
    }
  }

  Future<CountryData> getConfirmedByCountry(String countryName) async {
    print('Looking confirmed for $countryName');
    var responseConfirmed = await _client
        .get(sprintf('$_baseUrl$_getConfirmedByCountry', [countryName]));

    try {
      if (responseConfirmed.statusCode == 200) {
        print('Response received successfuly');
        print('Parsing data');
        var rawData = json.decode(responseConfirmed.body);
        print('$rawData');
        final details = List<CountryDetails>.from(
            rawData.map((item) => CountryDetails.fromJson(item)));
        final countryName = (rawData as List).first['Country'];
        CountryData countryData = CountryData(
          name: countryName,
          details: details,
        );
        print('Parsing data finished');

        return countryData;
      } else {
        throw new Exception('Error fetching data :(');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<CountryData> getDeathsByCountry(String countryName) async {
    print('Looking deaths for $countryName');

    var responseConfirmed = await _client
        .get(sprintf('$_baseUrl$_getDeathsByCountry', [countryName]));

    try {
      if (responseConfirmed.statusCode == 200) {
        print('Response received successfuly');
        print('Parsing data');
        var rawData = json.decode(responseConfirmed.body);
        final details = List<CountryDetails>.from(
            rawData.map((item) => CountryDetails.fromJson(item)));
        final countryName = (rawData as List).first['Country'];
        CountryData countryData = CountryData(
          name: countryName,
          details: details,
        );
        print('Parsing data finished');

        return countryData;
      } else {
        throw new Exception('Error fetching data :(');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<CountryData> getRecoveredByCountry(String countryName) async {
    print('Looking recovered for $countryName');

    var responseConfirmed = await _client
        .get(sprintf('$_baseUrl$_getRecoveredByCountry', [countryName]));

    try {
      if (responseConfirmed.statusCode == 200) {
        var rawData = json.decode(responseConfirmed.body);
        final details = List<CountryDetails>.from(
            rawData.map((item) => CountryDetails.fromJson(item)));
        final countryName = (rawData as List).first['Country'];
        CountryData countryData = CountryData(
          name: countryName,
          details: details,
        );

        return countryData;
      } else {
        throw new Exception('Error fetching data :(');
      }
    } catch (e) {
      print(e);
    }
  }
}
