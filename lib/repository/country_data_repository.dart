import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:crownapp/network/network_manager.dart';

class DataRepository {
  final NetworkManager _networkManager = NetworkManager();

  Future<List<CountryData>> fetchCountryData(String countryName) async {
    final confirmed = await _networkManager.getConfirmedByCountry(countryName);
    final deaths = await _networkManager.getDeathsByCountry(countryName);
    final recovered = await _networkManager.getRecoveredByCountry(countryName);

    return List()
      ..add(confirmed)..add(deaths)..add(recovered);
  }

  Future<List<CovidCountry>> getAffectedCountries() async {
    return _networkManager.getAffectedCountries();
  }
}
