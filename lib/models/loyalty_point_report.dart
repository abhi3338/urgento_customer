class LoyaltyPointReport {
  LoyaltyPointReport({
    this.id,
    this.points,
    this.amount,
    this.orderId,
    this.loyaltyPointId,
    this.isCredit,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.formattedDate,
    this.formattedUpdatedDate,
  });

  int id;
  double points;
  double amount;
  int orderId;
  int loyaltyPointId;
  bool isCredit;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String formattedDate;
  String formattedUpdatedDate;

  factory LoyaltyPointReport.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointReport(
        id: json["id"],
        points: json["points"].toDouble(),
        amount: double.parse(json["amount"].toString()),
        orderId: json["order_id"],
        loyaltyPointId: json["loyalty_point_id"],
        isCredit: json["is_credit"] == null
            ? false
            : (["1", 1].contains(json["is_credit"])),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        formattedDate: json["formatted_date"],
        formattedUpdatedDate: json["formatted_updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "points": points,
        "amount": amount,
        "order_id": orderId,
        "loyalty_point_id": loyaltyPointId,
        "is_credit": isCredit ? 1 : 0,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "formatted_date": formattedDate,
        "formatted_updated_date": formattedUpdatedDate,
      };
}
