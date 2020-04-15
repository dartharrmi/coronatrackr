import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:crownapp/bloc/country_data/country_data_bloc.dart';
import 'package:crownapp/model/notifier/country_notifier.dart';
import 'package:crownapp/model/notifier/navigation_model.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:crownapp/ui/pages/country_report/country_report_page.dart';
import 'package:crownapp/ui/widgets/bottom_bar/notched_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationModel>(context);
    final selectedCountryProvider = Provider.of<CountryNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Title(
            color: Colors.white,
            child: Text(this.title),
          ),
        ),
      ),
      backgroundColor: Color(0xff8585a3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Color(0xff474775),
        elevation: 5.0,
        heroTag: 'fab',
        onPressed: () {
          _openCountryPickerDialog(context, selectedCountryProvider);
        },
      ),
      body: IndexedStack(
        children: <Widget>[
          Consumer<CountryNotifier>(builder: (context, notifier, child) {
            return BlocProvider(
              create: (context) => CountryDataBloc(
                countryDataRepository: DataRepository(),
              ),
              child: CountryReportPage(
                notifier.selectedCountryCode ?? notifier.defaultCountry,
              ),
            );
          }),
          Container(
            child: Center(
              child: Text('This page $navigationProvider.currentIndex'),
            ),
          )
        ],
        index: navigationProvider.currentIndex,
      ),
      bottomNavigationBar: NotchedNavigationBar(
        selectedIndex: navigationProvider.currentIndex,
        color: Colors.grey,
        selectedColor: Colors.white,
        backgroundColor: Color(0xFF605C94),
        navigationItems: [
          NavigationItem(icon: Icons.menu, label: 'Country'),
          NavigationItem(icon: Icons.layers, label: 'News'),
        ],
      ),
    );
  }

  Widget _getCurrentPage(
      {BuildContext context, CountryNotifier notifier, int index}) {
    switch (index) {
      case 0:
        {
          return Consumer<CountryNotifier>(builder: (context, notifier, child) {
            return BlocProvider(
              create: (context) => CountryDataBloc(
                countryDataRepository: DataRepository(),
              ),
              child: CountryReportPage(
                notifier.selectedCountryCode ?? notifier.defaultCountry,
              ),
            );
          });
        }
      default:
        {
          return Container(
            child: Center(
              child: Text('This page $index'),
            ),
          );
        }
    }
  }

  void _openCountryPickerDialog(
          BuildContext context, CountryNotifier notified) =>
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Color(0xFF333366),
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Choose your country'),
            onValuePicked: (Country country) {
              notified.selectedCountryCode = country.name;
            },
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );
}
