import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crownapp/bloc/blocs.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:crownapp/ui/widgets/virus_details/virus_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountryReportPage extends StatelessWidget {
  final String countryName;

  final circular = Radius.circular(15);

  CountryReportPage(this.countryName);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CountryDataBloc>(context)
        .add(CountryDataEvent(countryName));

    return SlidingUpPanel(
        color: Color(0xFF040d3b),
        borderRadius: BorderRadius.only(
          topLeft: circular,
          topRight: circular,
        ),
        defaultPanelState: PanelState.OPEN,
        minHeight: 90.0,
        maxHeight: 200.0,
        parallaxEnabled: true,
        panel: BlocBuilder<CountryDataBloc, CountryDataState>(
          builder: (context, state) {
            if (state is CountryDataError) {
              return _getError();
            } else if (state is CountryDataLoading) {
              return _getPanelProgressBar();
            } else if (state is CountryDataAvailable) {
              return VirusDetails(
                countryData: state.countryData,
              );
              /*final countryCardContainer = Container(
                child: TimeSeriesRangeAnnotationChart.withSampleData(),
                height: 165.0,
                margin: new EdgeInsets.only(
                  left: 47.5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF333366),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    )
                  ],
                ),
              );

              final chart = Container(
                  height: 165.0,
                constraints: BoxConstraints.expand(),
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: countryCardContainer
              );

              return Container(
                constraints: BoxConstraints.expand(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(child: _getPanelDetails(state.countryData)),
                    Expanded(child: chart),
                    Expanded(child: chart),
                    Expanded(child: chart),
                  ],
                ),
              );*/
            } else {
              return Container();
            }
          },
        ),
        body: BlocBuilder<CountryDataBloc, CountryDataState>(
          builder: (context, state) {
            if (state is CountryDataError) {
              return _getError();
            }
            if (state is CountryDataLoading) {
              return _getMapProgressBar();
            }
            if (state is CountryDataAvailable) {
              final lengthConfirmed = state.countryData[0].details.length - 1;
              final latestConfirmedReport =
                  state.countryData[0].details[lengthConfirmed];

              final lat = latestConfirmedReport.latitude;
              final lon = latestConfirmedReport.longitude;

              return _getMap(lat, lon);
            }
            return Container();
          },
        ));
  }

  Widget _getError() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/anims/virus_error.gif",
              height: 85,
              width: 85,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'The virus mutated and we couldn\'t decode its RNA =(',
              style: Style.commonTextStyle,
            ),
          ],
        ),
      );

//region Panel
  Widget _getPanelProgressBar() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/anims/virus_loader.gif",
              height: 85,
              width: 85,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Decoding RNA of the virus',
              style: Style.commonTextStyle,
            ),
          ],
        ),
      );

//endregion

//region Map
  Widget _getMapProgressBar() => Container(
        constraints: BoxConstraints.expand(),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _getMap(double lat, double lon) => Container(
        constraints: BoxConstraints.expand(),
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(lat, lon),
            zoom: 6.1,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              tileProvider: CachedNetworkTileProvider(),
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(lat, lon),
                  builder: (ctx) => Container(
                    child: FlutterLogo(
                      size: 5.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
//endregion
}

// Chart
class TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesRangeAnnotationChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesRangeAnnotationChart.withSampleData() {
    return new TimeSeriesRangeAnnotationChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList, animate: animate, behaviors: [
      new charts.RangeAnnotation([
        new charts.RangeAnnotationSegment(new DateTime(2017, 10, 4),
            new DateTime(2017, 10, 15), charts.RangeAnnotationAxisType.domain),
      ]),
    ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
