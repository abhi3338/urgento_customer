// To parse this JSON data, do
//
//     final flashSale = flashSaleFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/product.dart';

FlashSale flashSaleFromJson(String str) => FlashSale.fromJson(json.decode(str));

String flashSaleToJson(FlashSale data) => json.encode(data.toJson());

class FlashSale {
  FlashSale({
    this.id,
    this.name,
    this.vendorTypeId,
    this.expiresAt,
    this.items,
  });

  int id;
  String name;
  int vendorTypeId;
  DateTime expiresAt;
  List<Product> items;

  factory FlashSale.fromJson(Map<String, dynamic> json) => FlashSale(
        id: json["id"],
        name: json["name"],
        vendorTypeId: json["vendor_type_id"],
        expiresAt: DateTime.parse(json["expires_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "vendor_type_id": vendorTypeId,
        "expires_at": expiresAt.toIso8601String(),
      };

  Duration get countDownDuration {
    return expiresAt.difference(DateTime.now());
  }

  bool get isExpired {
    return expiresAt.difference(DateTime.now()).inSeconds <= 0;
  }
}
