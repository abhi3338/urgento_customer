// To parse this JSON data, do
//
//     final OrderService = OrderServiceFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/service.dart';

OrderService OrderServiceFromJson(String str) =>
    OrderService.fromJson(json.decode(str));

String OrderServiceToJson(OrderService data) => json.encode(data.toJson());

class OrderService {
  OrderService({
    this.id,
    this.hours,
    this.price,
    this.orderId,
    this.serviceId,
    this.service,
  });

  int id;
  int hours;
  double price;
  int orderId;
  int serviceId;
  Service service;

  factory OrderService.fromJson(Map<String, dynamic> json) {
    return OrderService(
      id: json["id"] == null ? null : json["id"],
      hours: json["hours"] == null ? null : int.parse(json["hours"].toString()),
      price:
          json["price"] == null ? null : double.parse(json["price"].toString()),
      orderId: json["order_id"] == null
          ? null
          : int.parse(json["order_id"].toString()),
      serviceId: json["service_id"] == null
          ? null
          : int.parse(json["service_id"].toString()),
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "hours": hours,
        "order_id": orderId,
        "service_id": serviceId,
        "service": service.toJson(),
      };
}
