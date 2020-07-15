import 'package:country_pickers/utils/utils.dart';
import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/ui/widgets/charts/numeric_linear_chart.dart';
import 'package:crownapp/ui/widgets/charts/numeric_stacked_bar_chart.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/platform_utils.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/material.dart';

class CountryChartPage extends StatelessWidget {
  final List<CountryData> countryData;
  final String countryCode;

  CountryChartPage({this.countryData, this.countryCode});

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
          title: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Row(children: <Widget>[
                Hero(
                  tag: heroCountryFlag,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundImage: AssetImage(
                      CountryPickerUtils.getFlagImageAssetPath(countryCode),
                      package: country_icons_package,
                    ),
                  ),
                ),
                Container(
                  width: 5,
                ),
                Title(
                  color: Colors.white,
                  child: Hero(
                    tag: heroCountryName,
                    child: Text(
                      countryName,
                      style: Style.strongTitleTextStyle,
                    ),
                  ),
                ),
              ]),
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
                      chartHeader: Status.CONFIRMED.toString(),
                    ),
                    NumericLinearChart(
                      countryData: listOfDeaths,
                      countryName: countryName,
                      chartHeader: Status.DEATHS.toString(),
                    ),
                    NumericLinearChart(
                      countryData: listOfRecovered,
                      countryName: countryName,
                      chartHeader: Status.RECOVERED.toString(),
                    ),
                    StackedBarChart(
                      countryData: countryData,
                      countryName: countryName,
                      chartHeader: "Cumulative",
                    ),
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
