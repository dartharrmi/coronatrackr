import 'package:country_pickers/country_pickers.dart';
import 'package:crownapp/bloc/blocs.dart';
import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/ui/text_style.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/crown_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountryReport extends StatelessWidget {
  final String countryName;

  final circular = Radius.circular(15);

  CountryReport(this.countryName);

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
            }

            if (state is CountryDataLoading) {
              return _getPanelProgressBar();
            }

            if (state is CountryDataAvailable) {
              return _getPanelDetails(state.countryData);
            }

            return Container();
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

  Widget _getPanelDetails(List<CountryData> countryData) {
    final country = CountryUtils.getCountryByName(countryData[0].name);

    // Confirmed =|
    final lengthConfirmed = countryData[0].details.length - 1;
    final latestConfirmedReport = countryData[0].details[lengthConfirmed];

    // Deaths =(
    final deathsConfirmed = countryData[1].details.length - 1;
    final latestDeathReport = countryData[1].details[deathsConfirmed];

    // Recovere =)
    final recoveredConfirmed = countryData[2].details.length - 1;
    final latestrecoveredReport = countryData[2].details[recoveredConfirmed];

    // Country Details
    final countryCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
        30.0,
        16.0,
        16.0,
        16.0,
      ),
      constraints: new BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 4.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 26.0),
            child: Text(
              country.name,
              style: Style.strongTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
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
                value: '${latestrecoveredReport.cases} \nRecovered',
                image: CrownApp
                    .iconfinder_recovered_immune_strong_healthy_revive_5969421,
              ),
            ],
          ),
        ],
      ),
    );

    // Flag
    final countryCardIcon = Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 95.0,
      width: 95.0,
      child: Center(
        child: CircleAvatar(
          radius: 42.0,
          backgroundImage: AssetImage(
            CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
            package: "country_pickers",
          ),
        ),
      ),
    );

    // Card
    final countryCardContainer = Container(
      child: countryCardContent,
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

    return Container(
      height: 124.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          countryCardContainer,
          countryCardIcon,
        ],
      ),
    );
  }

  Widget _statDetail({String value, IconData image}) {
    return Column(
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
  }

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
