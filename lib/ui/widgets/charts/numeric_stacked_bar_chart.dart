import 'package:crownapp/model/models.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/platform_utils.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedBarChart extends StatelessWidget {
  final List<CountryData> countryData;
  final String countryName;
  final String chartTitle;
  final String chartHeader;

  StackedBarChart({
    this.countryData,
    this.countryName,
    this.chartTitle,
    this.chartHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(250, 250, 250, 1),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  splashColor: Colors.grey.withOpacity(0.4),
                  onTap: () {
                    /*Feedback.forLongPress(context);
                    expandSample(context, list[position], model);*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            chartHeader,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            textScaleFactor: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontFamily: 'HeeboMedium',
                                fontSize: 16.0,
                                color: const Color.fromRGBO(51, 51, 51, 1),
                                letterSpacing: 0.2),
                          ),
                          Container(
                              child: Row(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              /*Container(
                                    height: 24,
                                    width: 24,
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 0, 5, 5),
                                      child: Image.asset(
                                          'images/fullscreen.png',
                                          fit: BoxFit.contain,
                                          height: 20,
                                          width: 20,
                                          color: model.backgroundColor),
                                    ),
                                  ),*/
                            ],
                          )),
                        ]),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: _buildChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart _buildChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: isCardView ? '' : chartTitle),
        legend: Legend(
            isVisible: isCardView ? false : true,
            overflowMode: LegendItemOverflowMode.wrap),
        primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.months,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            dateFormat: DateFormat.yMd(),
            interval: 1,
            majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            numberFormat: Style.numberFormatter,
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(color: Colors.transparent)),
        series: _getChartLineSeries(countryData),
        tooltipBehavior:
            TooltipBehavior(enable: true, header: '', canShowMarker: false),
      );

  List<StackedColumnSeries<StackedChartData, DateTime>> _getChartLineSeries(
      List<CountryData> data) {
    final stackedDataList = data
        .sublist(data.length - 31, data.length)
        .map((e) => StackedChartData(
            e.date, e.active, e.confirmed, e.recovered, e.deaths))
        .toList();

    return <StackedColumnSeries<StackedChartData, DateTime>>[
      StackedColumnSeries<StackedChartData, DateTime>(
        enableTooltip: true,
        dataSource: stackedDataList,
        xValueMapper: (StackedChartData sales, _) => sales.x,
        yValueMapper: (StackedChartData sales, _) => sales.y,
        animationDuration: 2500,
        name: Status.ACTIVE.toString(),
      ),
      StackedColumnSeries<StackedChartData, DateTime>(
        enableTooltip: true,
        dataSource: stackedDataList,
        xValueMapper: (StackedChartData sales, _) => sales.x,
        yValueMapper: (StackedChartData sales, _) => sales.yValue,
        animationDuration: 2500,
        name: Status.CONFIRMED.toString(),
      ),
      StackedColumnSeries<StackedChartData, DateTime>(
        enableTooltip: true,
        dataSource: stackedDataList,
        xValueMapper: (StackedChartData sales, _) => sales.x,
        yValueMapper: (StackedChartData sales, _) => sales.yValue2,
        animationDuration: 2500,
        name: Status.RECOVERED.toString(),
      ),
      StackedColumnSeries<StackedChartData, DateTime>(
        enableTooltip: true,
        dataSource: stackedDataList,
        xValueMapper: (StackedChartData sales, _) => sales.x,
        yValueMapper: (StackedChartData sales, _) => sales.yValue3,
        animationDuration: 2500,
        name: Status.DEATHS.toString(),
      ),
    ];
  }
}

class StackedChartData {
  StackedChartData(this.x, this.y, this.yValue, this.yValue2, this.yValue3);

  final DateTime x;
  final num y;
  final num yValue;
  final num yValue2;
  final num yValue3;
}
