// To parse this JSON data, do
//
//     final searchData = searchDataFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/tag.dart';

SearchData searchDataFromJson(String str) => SearchData.fromJson(json.decode(str));

String searchDataToJson(SearchData data) => json.encode(data.toJson());

class SearchData {
    SearchData({
        this.priceRange,
        this.tags,
    });

    List<double> priceRange;
    List<Tag> tags;

    factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        priceRange: List<double>.from(json["price_range"].map((x) => double.parse(x.toString()) )),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
       
    );

    Map<String, dynamic> toJson() => {
        "price_range": List<dynamic>.from(priceRange.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    };
}



