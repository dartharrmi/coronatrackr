class CovidCountry {
  String country;
  String slug;
  String iso2;

  CovidCountry(this.country, this.slug, this.iso2);

  factory CovidCountry.fromJson(dynamic map) => CovidCountry(
        map['Country'],
        map['Slug'],
        map['ISO2'],
      );
}
