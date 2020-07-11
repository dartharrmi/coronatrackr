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

/*class CountryData {
  String countryName;
  String countryCode;
  DateTime lastUpdate;
  HashMap<Status, CountryDetails> details;

  CountryData({this.countryName, this.countryCode, this.lastUpdate, this.details}) {
    // details.removeWhere((element) => element.cases == 0);
  }
}

class CountryDetails {
  String province;
  double latitude;
  double longitude;
  DateTime date;
  int cases;
  String status;

  CountryDetails({
    this.province,
    this.latitude,
    this.longitude,
    this.date,
    this.cases,
    this.status,
  });

  factory CountryDetails.fromJson(dynamic json) {
    return CountryDetails(
        province: json['Province'],
        latitude: double.parse(json['Lat'].toString()),
        longitude: double.parse(json['Lon'].toString()),
        date: DateTime.parse(json['Date']),
        cases: json['Cases'],
        status: json['Status']);
  }
}*/
