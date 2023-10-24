// To parse this JSON data, do
//
//     final orderStatus = orderStatusFromJson(jsonString);

import 'dart:convert';

OrderStatus orderStatusFromJson(String str) =>
    OrderStatus.fromJson(json.decode(str));

String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  OrderStatus({
    this.id,
    this.name,
    this.reason,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.passed = true,
  });

  int id;
  String name;
  dynamic reason;
  String modelType;
  int modelId;
  DateTime createdAt;
  DateTime updatedAt;
  bool passed;

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      reason: json["reason"],
      modelType: json["model_type"] == null ? null : json["model_type"],
      modelId: json["model_id"] == null ? null : json["model_id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "reason": reason,
        "passed": passed,
        "model_type": modelType == null ? null : modelType,
        "model_id": modelId == null ? null : modelId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
