// To parse this JSON data, do
//
//     final fee = feeFromJson(jsonString);

import 'dart:convert';

Fee feeFromJson(String str) => Fee.fromJson(json.decode(str));

String feeToJson(Fee data) => json.encode(data.toJson());

class Fee {
  Fee({
    this.id,
    this.name,
    this.value,
    this.percentage,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  int id;
  String name;
  double value;
  int percentage;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Pivot pivot;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        id: json["id"],
        name: json["name"],
        value: double.parse(json["value"].toString()),
        percentage: json["percentage"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "percentage": percentage,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot.toJson(),
      };

  double getRate(double subTotal) {
    return (value / 100) * subTotal;
  }

  bool get isPercentage {
    return percentage == 1;
  }
}

class Pivot {
  Pivot({
    this.vendorId,
    this.feeId,
  });

  int vendorId;
  int feeId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        vendorId: json["vendor_id"],
        feeId: json["fee_id"],
      );

  Map<String, dynamic> toJson() => {
        "vendor_id": vendorId,
        "fee_id": feeId,
      };
}
