// To parse this JSON data, do
//
//     final OrderFee = feeFromJson(jsonString);

import 'dart:convert';

import 'package:supercharged/supercharged.dart';

OrderFee feeFromJson(String str) => OrderFee.fromJson(json.decode(str));

String feeToJson(OrderFee data) => json.encode(data.toJson());

class OrderFee {
  OrderFee({
    this.id,
    this.name,
    this.amount,
  });

  int id;
  String name;
  double amount;

  factory OrderFee.fromJson(Map<String, dynamic> json) {
    return OrderFee(
      id: json["id"],
      name: json["name"] == null ? "" : json["name"],
      amount: json["amount"] == null ? 0 : json["amount"].toString().toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
  };
}