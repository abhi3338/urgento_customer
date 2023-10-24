// To parse this JSON data, do
//
//     final walletTransaction = walletTransactionFromJson(jsonString);

import 'dart:convert';
import 'package:supercharged/supercharged.dart';

WalletTransaction walletTransactionFromJson(String str) =>
    WalletTransaction.fromJson(json.decode(str));

String walletTransactionToJson(WalletTransaction data) =>
    json.encode(data.toJson());

class WalletTransaction {
  WalletTransaction({
    this.id,
    this.amount,
    this.reason,
    this.ref,
    this.sessionId,
    this.walletId,
    this.paymentMethodId,
    this.status,
    this.isCredit,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.formattedDate,
    this.formattedUpdatedDate,
    this.photo,
  });

  int id;
  double amount;
  String reason;
  String ref;
  String sessionId;
  int walletId;
  String paymentMethodId;
  String status;
  int isCredit;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String formattedDate;
  String formattedUpdatedDate;
  String photo;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: json["id"] == null ? null : json["id"],
        amount: json["amount"].toString().toDouble(),
        reason: json["reason"] == null ? null : json["reason"],
        ref: json["ref"] == null ? null : json["ref"],
        sessionId: json["session_id"] == null ? null : json["session_id"],
        walletId: json["wallet_id"] == null ? null : json["wallet_id"],
        paymentMethodId: json["payment_method_id"] == null
            ? null
            : json["payment_method_id"],
        status: json["status"] == null ? null : json["status"],
        isCredit: json["is_credit"] == null ? null : json["is_credit"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        formattedDate:
            json["formatted_date"] == null ? null : json["formatted_date"],
        formattedUpdatedDate: json["formatted_updated_date"] == null
            ? null
            : json["formatted_updated_date"],
        photo: json["photo"] == null ? null : json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "amount": amount == null ? null : amount,
        "reason": reason == null ? null : reason,
        "ref": ref == null ? null : ref,
        "session_id": sessionId == null ? null : sessionId,
        "wallet_id": walletId == null ? null : walletId,
        "payment_method_id": paymentMethodId == null ? null : paymentMethodId,
        "status": status == null ? null : status,
        "is_credit": isCredit == null ? null : isCredit,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "formatted_date": formattedDate == null ? null : formattedDate,
        "formatted_updated_date":
            formattedUpdatedDate == null ? null : formattedUpdatedDate,
        "photo": photo == null ? null : photo,
      };
}
