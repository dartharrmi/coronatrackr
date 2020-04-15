import 'package:country_pickers/country.dart';

class CovidCountry extends Country {
  String slug;

  CovidCountry(isoCode, iso3Code, phoneCode, name, this.slug)
      : super(
            isoCode: isoCode,
            iso3Code: iso3Code,
            phoneCode: phoneCode,
            name: name);

  factory CovidCountry.fromMap(Map<String, String> map) => CovidCountry(
        map['name'],
        map['isoCode'],
        map['iso3Code'],
        map['phoneCode'],
        map['slug'],
      );
}
