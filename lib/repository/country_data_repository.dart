import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:crownapp/network/network_manager.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final NetworkManager _networkManager = NetworkManager();

  Future<List<CovidCountry>> getAffectedCountries() async {
    return _networkManager.getAffectedCountries();
  }

  Future<CountryData> getCountryData(String countrySlug) async =>
      _networkManager.getCountryData(countrySlug);

  Future<List<CountryDetails>> getChartDetails(
      String countrySlug, Status status) async {
    List<CountryDetails> details;
    final prefs = await SharedPreferences.getInstance();
    final savedJson =
        prefs.getString(Status.getStatusName(Status.CONFIRMED, countrySlug));

    if (savedJson.isNotEmpty) {
      details = List<CountryDetails>.from(
          json.decode(savedJson).map((item) => CountryDetails.fromJson(item)));
      details.removeWhere((element) => element.cases == 0);
    }

    return details;
  }
}
