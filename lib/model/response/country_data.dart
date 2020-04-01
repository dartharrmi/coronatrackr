class CountryData {
  String name;
  List<CountryDetails> details;

  CountryData({this.name, this.details});
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
        latitude: json['Lat'].toDouble(),
        longitude: json['Lon'].toDouble(),
        date: DateTime.parse(json['Date']),
        cases: json['Cases'],
        status: json['Status']);
  }
}
