import 'package:crownapp/bloc/chart/country_chart_event.dart';
import 'package:crownapp/bloc/chart/country_chart_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryChartBloc extends Bloc<CountryChartEvent, CountryChartState> {
  final DataRepository countryDataRepository;

  CountryChartBloc({@required this.countryDataRepository})
      : assert(countryDataRepository != null);

  @override
  CountryChartState get initialState => CountryChartEmpty();

  @override
  Stream<CountryChartState> mapEventToState(CountryChartEvent event) async* {
    yield CountryChartLoading();

    try {
      final countryChart = await countryDataRepository.getChartDetails(
          event.countryName, event.status);
      yield CountryChartAvailable(countryChart: countryChart);
    } catch (e) {
      print(e);
      yield CountryChartError();
    }
  }
}
