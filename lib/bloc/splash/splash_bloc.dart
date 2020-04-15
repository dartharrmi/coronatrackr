import 'package:crownapp/bloc/splash/splash_event.dart';
import 'package:crownapp/bloc/splash/splash_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<CountryListEvent, CountryListState> {
  final DataRepository countryDataRepository;

  SplashBloc({@required this.countryDataRepository})
      : assert(countryDataRepository != null);

  @override
  CountryListState get initialState => CountryListEmpty();

  @override
  Stream<CountryListState> mapEventToState(CountryListEvent event) async* {
    yield CountryListLoading();

    try {
      final countryList = await countryDataRepository.getAffectedCountries();
      yield CountryListAvailable(countryList: countryList);
    } catch (e) {
      print(e);
      yield CountryListError();
    }
  }
}
