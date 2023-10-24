// To parse this JSON data, do
//
//     final taxiOrderLocationHistory = taxiOrderLocationHistoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TaxiOrderLocationHistory taxiOrderLocationHistoryFromJson(String str) => TaxiOrderLocationHistory.fromJson(json.decode(str));

String taxiOrderLocationHistoryToJson(TaxiOrderLocationHistory data) => json.encode(data.toJson());

class TaxiOrderLocationHistory {
    TaxiOrderLocationHistory({
        @required this.latitude,
        @required this.longitude,
        @required this.address,
        @required this.name,
    });

    double latitude;
    double longitude;
    String address;
    String name;

    factory TaxiOrderLocationHistory.fromJson(Map<String, dynamic> json) => TaxiOrderLocationHistory(
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        address: json["address"] == null ? null : json["address"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "address": address == null ? null : address,
        "name": name == null ? null : name,
    };
}
