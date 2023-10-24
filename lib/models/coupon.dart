import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/view_models/cart.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

Coupon couponFromJson(String str) => Coupon.fromJson(json.decode(str));

String couponToJson(Coupon data) => json.encode(data.toJson());

class Coupon {
  Coupon({
    this.id,
    this.code,
    this.description,
    this.discount,
    this.min_order_amount,
    this.max_coupon_amount,
    this.percentage,
    this.expiresOn,
    this.times,
    this.useLeft,
    this.expired,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.formattedExpiresOn,
    this.products,
    this.vendors,
    this.vendorTypeId,
    //
    this.color,
    this.photo,
  });

  int id;
  String code;
  String description;
  double discount;
  double min_order_amount;
  double max_coupon_amount;
  int percentage;
  DateTime expiresOn;
  dynamic times;
  int useLeft;
  bool expired;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String formattedExpiresOn;
  List<Product> products;
  List<Vendor> vendors;
  int vendorTypeId;
  String color;
  String photo;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"] == null ? null : json["id"],
        vendorTypeId:
            json["vendor_type_id"] == null ? null : json["vendor_type_id"],
        code: json["code"] == null ? null : json["code"],
        description: json["description"] == null ? null : json["description"],
        color: json["color"],
        photo: json["photo"],
        discount: double.parse(json["discount"].toString()) ?? null,
        min_order_amount: json["min_order_amount"] != null
            ? double.parse(json["min_order_amount"].toString())
            : null,
        max_coupon_amount: json["max_coupon_amount"] != null
            ? double.parse(json["max_coupon_amount"].toString())
            : null,
        percentage: json["percentage"] == null ? null : json["percentage"],
        expiresOn: json["expires_on"] == null
            ? null
            : DateTime.parse(json["expires_on"]),
        times: json["times"],
        expired: json["expired"],
        useLeft: int.parse(json["use_left"].toString()),
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        formattedExpiresOn: json["formatted_expires_on"] == null
            ? null
            : json["formatted_expires_on"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        vendors: json["vendors"] == null
            ? null
            : List<Vendor>.from(json["vendors"].map((x) => Vendor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "vendor_type_id": vendorTypeId,
        "color": color,
        "photo": photo,
        "code": code == null ? null : code,
        "description": description == null ? null : description,
        "discount": discount == null ? null : discount,
        "min_order_amount": min_order_amount,
        "max_coupon_amount": max_coupon_amount,
        "percentage": percentage == null ? null : percentage,
        "expires_on": expiresOn == null
            ? null
            : "${expiresOn.year.toString().padLeft(4, '0')}-${expiresOn.month.toString().padLeft(2, '0')}-${expiresOn.day.toString().padLeft(2, '0')}",
        "times": times,
        "expired": expired,
        "use_left": useLeft,
        "is_active": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "formatted_expires_on":
            formattedExpiresOn == null ? null : formattedExpiresOn,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
        "vendors": vendors == null
            ? null
            : List<dynamic>.from(vendors.map((x) => x.toJson())),
      };

  //
  double validateDiscount(double amount, double discount,{TextEditingController couponTEC}) {
    //check if order total is within allowed order mount
    if (this.min_order_amount != null &&
        amount < (this.min_order_amount ?? 0)) {
      applyCouponIndex = 5000;
      couponTEC.text = "";
      if(couponTEC.text != ""){
        toastSuccessful("Order amount is less than coupon minimum allowed order");
      }
      throw "Order amount is less than coupon minimum allowed order".tr();
    }

    if (this.max_coupon_amount != null && discount > (this.max_coupon_amount)) {
      return this.max_coupon_amount;
    } else {
      return discount;
    }
  }

  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
