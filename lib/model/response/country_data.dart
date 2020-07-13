class CountryData {
  String country;
  String countryCode;
  double latitude;
  double longitude;
  int confirmed;
  int deaths;
  int recovered;
  int active;
  DateTime date;

  CountryData(
      {this.country,
      this.countryCode,
      this.latitude,
      this.longitude,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.date});

  factory CountryData.fromJson(dynamic json) {
    return CountryData(
        country: json["Country"],
        countryCode: json["CountryCode"],
        latitude: double.parse(json['Lat'].toString()),
        longitude: double.parse(json['Lon'].toString()),
        confirmed: int.parse(json["Confirmed"].toString()),
        deaths: int.parse(json["Deaths"].toString()),
        recovered: int.parse(json["Recovered"].toString()),
        active: int.parse(json["Active"].toString()),
        date: DateTime.parse(json['Date'].toString()));
  }
}