import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class NetworkManager {
  final _client = new http.Client();

  final _baseUrl = "https://api.covid19api.com/";
  final _getAffectedCountries = "countries";
  final _getCountryData = "total/country/%s";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<CovidCountry>> getCountriesSlug() async {
    print('Looking affected countries');
    var response = await _client.get('$_baseUrl$_getAffectedCountries');

    try {
      if (response.statusCode == 200) {
        print('Countries retrieved successfully');
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
      return [];
    }
  }

  // @formatter:off
  Future<List<CountryData>> getCountryData(String countrySlug) async {
    print('Getting data for country identified with slug: $countrySlug');
    var responseData =
        await _client.get(sprintf('$_baseUrl$_getCountryData', [countrySlug]));

    try {
      // Confirmed
      if (responseData.statusCode == 200) {
        print('Response obtained');
        print('Parsing data');
        var rawData = json.decode(responseData.body);
        print('Response: $rawData');
        final listOfCountries = List<CountryData>.from(
            rawData.map((item) => CountryData.fromJson(item)));
        listOfCountries.removeWhere((element) => element.confirmed == 0);
        print('Finished parsing the data');
        return listOfCountries;
      }
    } catch (e) {
      print(e);
      return List<CountryData>();
    }
  }
// @formatter:on
}
