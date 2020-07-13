import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/ui/widgets/linear_chart.dart';
import 'package:flutter/material.dart';

class CountryChartPage extends StatelessWidget {
  final List<CountryData> countryData;

  CountryChartPage({this.countryData});

  @override
  Widget build(BuildContext context) {
    final countryName = countryData[0].country;
    final listOfConfirmed =
        countryData.map((e) => NumericChartData(e.date, e.confirmed)).toList();
    final listOfDeaths =
        countryData.map((e) => NumericChartData(e.date, e.deaths)).toList();
    final listOfRecovered =
        countryData.map((e) => NumericChartData(e.date, e.recovered)).toList();

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
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromRGBO(0, 116, 227, 1),
          child: CustomScrollView(
            controller: ScrollController(),
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NumericLinearChart(
                      countryData: listOfConfirmed,
                      countryName: countryName,
                    ),
                    NumericLinearChart(
                      countryData: listOfDeaths,
                      countryName: countryName,
                    ),
                    NumericLinearChart(
                      countryData: listOfRecovered,
                      countryName: countryName,
                    ),
                    NumericLinearChart(
                      countryData: listOfConfirmed,
                      countryName: countryName,
                    )
                  ],
                ),
              )
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
            }));
  }
}
