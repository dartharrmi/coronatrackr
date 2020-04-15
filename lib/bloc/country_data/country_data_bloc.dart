import 'dart:developer';

import 'package:crownapp/bloc/country_data/country_data_event.dart';
import 'package:crownapp/bloc/country_data/country_data_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryDataBloc extends Bloc<CountryDataEvent, CountryDataState> {
  final DataRepository countryDataRepository;

  CountryDataBloc({@required this.countryDataRepository})
      : assert(countryDataRepository != null);

  @override
  CountryDataState get initialState => CountryDataEmpty();

  @override
  Stream<CountryDataState> mapEventToState(CountryDataEvent event) async* {
    yield CountryDataLoading();

    try {
      final countryData =
          await countryDataRepository.fetchCountryData(event.countryName);
      yield CountryDataAvailable(countryData: countryData);
    } catch (e) {
      print(e);
      yield CountryDataError();
    }
  }

  @override
  void onTransition(Transition<CountryDataEvent, CountryDataState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
  }

  @override
  void onEvent(CountryDataEvent event) {
    // TODO: implement onEvent
    super.onEvent(event);
  }
}
