import 'package:country_pickers/country.dart';
import 'package:crownapp/bloc/blocs.dart';
import 'package:crownapp/model/country_centers.dart';
import 'package:crownapp/model/models.dart';
import 'package:crownapp/ui/widgets/virus_details/virus_details.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountryReportPage extends StatelessWidget {
  final CovidCountry country;

  final circular = Radius.circular(15);

  CountryReportPage(this.country);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CountryDataBloc>(context)
        .add(CountryDataEvent(country.slug));

    return SlidingUpPanel(
        color: Color(0xFF040d3b),
        borderRadius: BorderRadius.only(
          topLeft: circular,
          topRight: circular,
        ),
        defaultPanelState: PanelState.OPEN,
        minHeight: 90.0,
        maxHeight: 245.0,
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
                countryCode: country.isoCode,
              );
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
              //return _getMap(countryCenterDetails[country.isoCode]);
              return Container();
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

  Widget _getMap(LatLng countryCenter) => Container(
        constraints: BoxConstraints.expand(),
        child: FlutterMap(
          options: MapOptions(
            center: countryCenter,
            zoom: 6.1,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              tileProvider: NonCachingNetworkTileProvider(),
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: countryCenter,
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
