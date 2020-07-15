import 'package:country_pickers/country_pickers.dart';
import 'package:crownapp/bloc/chart/country_chart_bloc.dart';
import 'package:crownapp/model/models.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:crownapp/ui/screens/country_charts/country_chart_page.dart';
import 'package:crownapp/utils/crown_app_icons.dart';
import 'package:crownapp/utils/platform_utils.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VirusDetails extends StatelessWidget {
  final List<CountryData> countryData;
  final String countryCode;

  VirusDetails({this.countryData, this.countryCode});

  @override
  Widget build(BuildContext context) {
    final latestReport = countryData[countryData.length - 1];
    final latestUpdate = latestReport.date;
    final latestActive = latestReport.active;
    final latestConfirmed = latestReport.confirmed;
    final latestDeaths = latestReport.deaths;
    final latestRecovered = latestReport.recovered;

    // Country Details
    final virusDetails = Container(
      margin: EdgeInsets.fromLTRB(
        30.0,
        16.0,
        16.0,
        7.5,
      ),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 26.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: heroCountryName,
                    child: Text(
                      latestReport.country,
                      style: Style.strongTitleTextStyle,
                    ),
                  ),
                  Text(
                    'Active cases: ${Style.numberFormatter.format(latestActive)}',
                    style: Style.subtitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _statDetail(
                value:
                    '${Style.numberFormatter.format(latestConfirmed)} \nConfirmed',
                image: CrownApp.ic_font_mask,
              ),
              _statDetail(
                value: '${Style.numberFormatter.format(latestDeaths)} \nDeaths',
                image: CrownApp.ic_font_death,
              ),
              _statDetail(
                value:
                    '${Style.numberFormatter.format(latestRecovered)} \nRecovered',
                image: CrownApp.ic_font_recovered,
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Text(
              'Last update: ${DateFormat("dd-MM-yyyy").format(latestUpdate)}',
              style: Style.commonTextStyle,
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Text(
                'View more details',
                style: Style.hyperlink,
              ),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => CountryChartBloc(
                      countryDataRepository: DataRepository(),
                    ),
                    child: CountryChartPage(
                      countryData: countryData,
                      countryCode: countryCode,
                    ),
                  ),
                ),
              )
            },
          )
        ],
      ),
    );

    return Container(
      height: 300.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          _getCardDecoration(virusDetails),
          _getCountryIcon(countryCode),
        ],
      ),
    );
  }

  Widget _statDetail({String value, IconData image}) => Column(
        children: <Widget>[
          Icon(
            image,
            size: 36.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Style.commonTextStyle,
          ),
        ],
      );

  Widget _getCardDecoration(Widget child) => Container(
        constraints: BoxConstraints.expand(),
        child: child,
        margin: EdgeInsets.only(
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

  Widget _getCountryIcon(String countryIsoCode) => Container(
        padding: EdgeInsets.only(top: 10.0),
        height: 95.0,
        width: 95.0,
        child: Center(
          child: Hero(
            tag: heroCountryFlag,
            child: CircleAvatar(
              radius: 42.0,
              backgroundImage: AssetImage(
                CountryPickerUtils.getFlagImageAssetPath(countryIsoCode),
                package: country_icons_package,
              ),
            ),
          ),
        ),
      );
}
