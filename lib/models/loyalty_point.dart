class LoyaltyPoint {
  LoyaltyPoint({
    this.points,
    this.updatedAt,
  });

  double points;
  DateTime updatedAt;

  factory LoyaltyPoint.fromJson(Map<String, dynamic> json) => LoyaltyPoint(
        points: json["points"] == null
            ? null
            : double.parse(json["points"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "points": points,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
