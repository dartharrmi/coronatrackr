import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crownapp/model/response/country_data.dart';
import 'package:flutter/material.dart';

class CountryChartPage extends StatelessWidget {
  final List<CountryData> countryData;

  CountryChartPage({this.countryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Title(
            color: Colors.white,
            child: Text('Details'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48, bottom: 12),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 32.5,
            ),
            SizedBox(
              height: 500,
              child: _getReport(countryData[0].details,
                  id: countryData[0].details[0].status),
            ),
            SizedBox(
              height: 500,
              child: _getReport(countryData[1].details,
                  id: countryData[1].details[0].status),
            ),
            SizedBox(
              height: 500,
              child: _getReport(countryData[2].details,
                  id: countryData[2].details[0].status),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff8585a3),
    );
  }

  Widget _getReport(List<CountryDetails> data, {String id}) {
    var timeSeriesCases = data
        .map((currentData) =>
            _TimeSeriesCases(currentData.date, currentData.cases))
        .toList();
    var series = [
      new charts.Series<_TimeSeriesCases, DateTime>(
        id: id,
        displayName: id,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF333366)),
        domainFn: (_TimeSeriesCases sales, _) => sales.time,
        measureFn: (_TimeSeriesCases sales, _) => sales.cases,
        data: timeSeriesCases,
      )
    ];

    final countryCardContainer = Container(
      child: _TimeSeriesRangeAnnotationChart(
        series,
        data[0].date,
        data[data.length - 1].date,
        data[0].status,
        "Tiempo",
        "Muertes",
        animate: true,
      ),
      height: 165.0,
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
        margin: EdgeInsets.only(top: 16, left: 10, right: 10),
        child: countryCardContainer);

    /*final entryDetail = Row(
      children: <Widget>[
        Text(
          'Cases on: ',
          textAlign: TextAlign.center,
          style: Style.commonTextStyle,
        ),
      ],
    )*/

    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: chart),
          //entryDetail
        ],
      ),
    );
  }
}

// Chart
class _TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final DateTime start;
  final DateTime end;
  final String chartName;
  final String chartYTitle;
  final String chartXTitle;
  final bool animate;

  _TimeSeriesRangeAnnotationChart(this.seriesList, this.start, this.end,
      this.chartName, this.chartXTitle, this.chartYTitle,
      {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      behaviors: [
        charts.PanAndZoomBehavior(),
        charts.ChartTitle(chartName,
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec:
                charts.TextStyleSpec(color: charts.MaterialPalette.white)),
        charts.ChartTitle(chartXTitle,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec:
                charts.TextStyleSpec(color: charts.MaterialPalette.white)),
        charts.ChartTitle(chartYTitle,
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec:
                charts.TextStyleSpec(color: charts.MaterialPalette.white)),
        charts.RangeAnnotation(
          [
            charts.RangeAnnotationSegment(
                start, end, charts.RangeAnnotationAxisType.domain),
          ],
        ),
      ],
      domainAxis: charts.DateTimeAxisSpec(
        viewport: charts.DateTimeExtents(start: start, end: end),
        showAxisLine: true,
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          updatedListener: _onSelection,
        )
      ],
    );
  }

  _onSelection(charts.SelectionModel selectionModel) {
    final selectedDatum = selectionModel.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }
  }
}

/// Sample time series data type.
class _TimeSeriesCases {
  final DateTime time;
  final int cases;

  _TimeSeriesCases(this.time, this.cases);
}
