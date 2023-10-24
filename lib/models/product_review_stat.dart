// To parse this JSON data, do
//
//     final productReviewStat = productReviewStatFromJson(jsonString);

import 'dart:convert';
import 'package:supercharged/supercharged.dart';

ProductReviewStat productReviewStatFromJson(String str) => ProductReviewStat.fromJson(json.decode(str));

String productReviewStatToJson(ProductReviewStat data) => json.encode(data.toJson());

class ProductReviewStat {
    ProductReviewStat({
        this.count,
        this.percentage,
        this.rate,
    });

    int count;
    double percentage;
    double rate;

    factory ProductReviewStat.fromJson(Map<String, dynamic> json) => ProductReviewStat(
        count: json["count"],
        percentage: json["percentage"].toString().toDouble(),
        rate: json["rate"].toString().toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "percentage": percentage,
        "rate": rate,
    };
}
