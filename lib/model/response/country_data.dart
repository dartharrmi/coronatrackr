class CountryData {
  String name;
  List<CountryDetails> details;

  CountryData({this.name, this.details}) {
    details.removeWhere((element) => element.cases == 0);
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
}
