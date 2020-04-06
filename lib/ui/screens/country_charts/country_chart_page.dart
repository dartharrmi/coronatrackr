import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crownapp/model/notifier/stat_notifier.dart';
import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/utils/pair.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountryChartPage extends StatelessWidget {
  final List<CountryData> countryData;

  CountryChartPage({this.countryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Center(
          child: Title(
            color: Colors.white,
            child: Text('Details'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 12),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 550,
              child: _getReport(countryData[0].details,
                  id: countryData[0].details[0].status),
            ),
            SizedBox(
              height: 550,
              child: _getReport(countryData[1].details,
                  id: countryData[1].details[0].status),
            ),
            SizedBox(
              height: 550,
              child: _getReport(countryData[2].details,
                  id: countryData[2].details[0].status),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff8585a3),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        backgroundColor: Color(0xff474775),
        elevation: 5.0,
        heroTag: 'fab',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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

    return ChangeNotifierProvider(
      create: (_) => StatNotifier(),
      child: _ChartCard(
          series, data[0].date, data[data.length - 1].date, data[0].status),
    );
  }
}

// Card
class _ChartCard extends StatelessWidget {
  final List<charts.Series> seriesList;
  final DateTime startDate;
  final DateTime endDate;
  final String chartTitle;

  _ChartCard(this.seriesList, this.startDate, this.endDate, this.chartTitle);

  @override
  Widget build(BuildContext context) {
    final entryDetail = Consumer<StatNotifier>(
      builder: (context, notifier, child) {
        if (notifier.selectedDate != null) {
          return Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Cases on ${DateFormat("dd-MM-yyyy").format(notifier.selectedDate.item1)}: ${notifier.selectedDate.item2}',
                  textAlign: TextAlign.center,
                  style: Style.commonTextStyle,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: _TimeSeriesRangeAnnotationChart(
              seriesList,
              startDate,
              endDate,
              chartTitle,
              "Tiempo",
              "Muertes",
              animate: true,
            ),
          ),
          entryDetail
        ],
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
      margin: EdgeInsets.only(top: 16, left: 10, right: 10),
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
    final statSelected = Provider.of<StatNotifier>(context);

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
          updatedListener: (selectionModel) =>
              _onSelection(selectionModel, statSelected),
        )
      ],
    );
  }

  _onSelection(charts.SelectionModel selectionModel, StatNotifier notifier) {
    final selectedDatum = selectionModel.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      notifier.selectedDate =
          Pair(selectedDatum.first.datum.time, selectedDatum.first.datum.cases);
    }
  }
}

/// Sample time series data type.
class _TimeSeriesCases {
  final DateTime time;
  final int cases;

  _TimeSeriesCases(this.time, this.cases);
}
