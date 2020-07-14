import 'package:country_pickers/countries.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class Status {
  final _value;

  const Status._internal(this._value);

  toString() => '$_value';

  static const CONFIRMED = const Status._internal('Confirmed');
  static const DEATHS = const Status._internal('Deaths');
  static const RECOVERED = const Status._internal('Recovered');

  static String getStatusName(Status status, String countrySlug) =>
      '${status._value}-$countrySlug';
}

class CountryUtils {
  static Country getCountryByName(String name) {
    try {
      return countryList.firstWhere(
        (country) => country.name == name,
      );
    } catch (error) {
      throw Exception("Country not found!");
    }
  }

  static Widget getCountryFlag(Country country) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage(
          CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
          package: "country_pickers",
        ),
        height: 92.0,
        width: 92.0,
      ),
    );
  }
}
