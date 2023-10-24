// To parse this JSON data, do
//
//     final productReview = productReviewFromJson(jsonString);

import 'dart:convert';

import 'package:fuodz/models/user.dart';

ProductReview productReviewFromJson(String str) => ProductReview.fromJson(json.decode(str));

String productReviewToJson(ProductReview data) => json.encode(data.toJson());

class ProductReview {
    ProductReview({
        this.id,
        this.productId,
        this.orderId,
        this.userId,
        this.rating,
        this.review,
        this.createdAt,
        this.updatedAt,
        this.formattedDate,
        this.formattedUpdatedDate,
        this.photo,
        this.user,
    });

    int id;
    int productId;
    int orderId;
    int userId;
    int rating;
    String review;
    DateTime createdAt;
    DateTime updatedAt;
    String formattedDate;
    String formattedUpdatedDate;
    String photo;
    User user;

    factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        id: json["id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        userId: json["user_id"],
        rating: json["rating"],
        review: json["review"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        formattedDate: json["formatted_date"],
        formattedUpdatedDate: json["formatted_updated_date"],
        photo: json["photo"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "order_id": orderId,
        "user_id": userId,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "formatted_updated_date": formattedUpdatedDate,
        "photo": photo,
        "user": user.toJson(),
    };
}
