import 'package:country_pickers/country_pickers.dart';
import 'package:crownapp/model/models.dart';
import 'package:crownapp/ui/text_style.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/crown_app_icons.dart';
import 'package:flutter/material.dart';

class VirusDetails extends StatelessWidget {
  final String _country_icons_package = "country_pickers";
  final List<CountryData> countryData;

  VirusDetails({this.countryData});

  @override
  Widget build(BuildContext context) {
    final country = CountryUtils.getCountryByName(countryData[0].name);

    // Confirmed =|
    final lengthConfirmed = countryData[0].details.length - 1;
    final latestConfirmedReport = countryData[0].details[lengthConfirmed];

    // Deaths =(
    final deathsConfirmed = countryData[1].details.length - 1;
    final latestDeathReport = countryData[1].details[deathsConfirmed];

    // Recovered =)
    final recoveredConfirmed = countryData[2].details.length - 1;
    final latestRecoveredReport = countryData[2].details[recoveredConfirmed];

    // Country Details
    final virusDetails = new Container(
      margin: new EdgeInsets.fromLTRB(
        30.0,
        16.0,
        16.0,
        7.5,
      ),
      constraints: new BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 26.0),
            child: Text(
              country.name,
              style: Style.strongTitleTextStyle,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _statDetail(
                value: '${latestConfirmedReport.cases} \nConfirmed',
                image: CrownApp.iconfinder_emoji_emoticon_35_3638429,
              ),
              _statDetail(
                value: '${latestDeathReport.cases} \nDeaths',
                image: CrownApp.iconfinder_disease_29_5766041,
              ),
              _statDetail(
                value: '${latestRecoveredReport.cases} \nRecovered',
                image: CrownApp
                    .iconfinder_recovered_immune_strong_healthy_revive_5969421,
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 9.0),
              child: Text(
                'View more details',
                style: Style.hyperlink,
              ),
            ),
            onTap: () => {},
          )
        ],
      ),
    );

    return Container(
      height: 180.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          _getCardDecoration(virusDetails),
          _getCountryIcon(country.isoCode),
        ],
      ),
    );
  }

  Widget _statDetail({String value, IconData image}) => Column(
        children: <Widget>[
          new Icon(
            image,
            size: 36.0,
            color: Colors.white,
          ),
          new SizedBox(
            height: 3.0,
          ),
          new Text(
            value,
            textAlign: TextAlign.center,
            style: Style.commonTextStyle,
          ),
        ],
      );

  Widget _getCardDecoration(Widget child) => Container(
        constraints: BoxConstraints.expand(),
        child: child,
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

  Widget _getCountryIcon(String countryIsoCode) => Container(
        padding: EdgeInsets.only(top: 10.0),
        height: 95.0,
        width: 95.0,
        child: Center(
          child: CircleAvatar(
            radius: 42.0,
            backgroundImage: AssetImage(
              CountryPickerUtils.getFlagImageAssetPath(countryIsoCode),
              package: _country_icons_package,
            ),
          ),
        ),
      );
}
