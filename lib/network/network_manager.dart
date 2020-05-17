import 'dart:collection';
import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class NetworkManager {
  final _client = new http.Client();
  final _baseUrl = "https://api.covid19api.com/";
  final _getConfirmedByCountry = "country/%s/status/confirmed";
  final _getDeathsByCountry = "country/%s/status/deaths";
  final _getRecoveredByCountry = "country/%s/status/recovered";
  final _getAffectedCountries = "countries";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  /*Future<CountryData> getConfirmedByCountry(String countryName) async {
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
          countryName: countryName,
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
          countryName: countryName,
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
          countryName: countryName,
          details: details,
        );

        return countryData;
      } else {
        throw new Exception('Error fetching data :(');
      }
    } catch (e) {
      print(e);
    }
  }*/

  // @formatter:off
  Future<CountryData> getCountryData(String countrySlug) async {
    SharedPreferences prefs = await _prefs;
    CountryData countryData = CountryData();
    HashMap<Status, CountryDetails> details = new HashMap<Status, CountryDetails>();

    print('Looking confirmed cases for $countrySlug');
    var responseConfirmed = await _client
        .get(sprintf('$_baseUrl$_getConfirmedByCountry', [countrySlug]));

    var responseDeaths = await _client
        .get(sprintf('$_baseUrl$_getDeathsByCountry', [countrySlug]));

    var responseRecovered = await _client
        .get(sprintf('$_baseUrl$_getRecoveredByCountry', [countrySlug]));

    CountryDetails latestConfirmed;
    CountryDetails latestDeaths;
    CountryDetails latestRecovered;
    try {
      // Confirmed
      if (responseConfirmed.statusCode == 200) {
        print('Response received successfuly');
        print('Parsing data');
        var rawData = json.decode(responseConfirmed.body);
        print('Response: $rawData');
        print('Caching confirmed to local storage.');
        latestConfirmed = CountryDetails.fromJson((rawData as List).last);
        details[Status.CONFIRMED] = latestConfirmed;

        bool saved = await prefs.setString('${Status.getStatusName(Status.CONFIRMED, countrySlug)}', responseConfirmed.body);
        print('Were confirmed saved to local storage: $saved');
      }

      // Deaths
      if (responseDeaths.statusCode == 200) {
        print('Response received successfuly');
        print('Parsing data');
        var rawData = json.decode(responseDeaths.body);
        print('Caching deaths to local storage.');
        latestDeaths = CountryDetails.fromJson((rawData as List).last);
        details[Status.DEATHS] = latestDeaths;

        bool saved = await prefs.setString('${Status.getStatusName(Status.DEATHS, countrySlug)}', responseDeaths.body);
        print('Were deaths saved to local storage: $saved');
      }

      // Recovered
      if (responseRecovered.statusCode == 200) {
        print('Response received successfuly');
        print('Parsing data');
        var rawData = json.decode(responseRecovered.body);
        print('Caching recovered to local storage.');
        latestRecovered = CountryDetails.fromJson((rawData as List).last);
        details[Status.RECOVERED] = latestRecovered;

        bool saved = await prefs.setString('${Status.getStatusName(Status.RECOVERED, countrySlug)}', responseRecovered.body);
        print('Were recovered saved to local storage: $saved');
      }

      countryData.lastUpdate = latestConfirmed.date;
      countryData.details = details;
      countryData.countryName = countrySlug;

      return countryData;
    } catch (e) {
      print(e);
      return null;
    }
  }
// @formatter:on
}
