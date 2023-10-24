import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/order_stop.dart';
import 'package:fuodz/models/package_type.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/vendor.dart';

class PackageCheckout {
  double distance;
  double deliveryFee;
  double packageTypeFee;
  double subTotal;
  double discount;
  double tax;
  double taxRate;
  double total;
  PackageType packageType;
  Vendor vendor;
  DeliveryAddress pickupLocation;
  DeliveryAddress dropoffLocation;
  List<OrderStop> stopsLocation = [];
  List<OrderStop> allStops = [];
  Coupon coupon;
  String date;
  String time;
  //
  String recipientName;
  String recipientPhone;

  String weight;
  String length;
  String height;
  String width;
  bool payer = true;

  PaymentMethod paymentMethod;
  bool isScheduled;
  String deliverySlotDate;
  String deliverySlotTime;
  String token;

  //
  PackageCheckout({
    this.distance = 0.00,
    this.deliveryFee = 0.00,
    this.packageTypeFee = 0.00,
    this.subTotal = 0.00,
    this.discount = 0.00,
    this.tax = 0.00,
    this.taxRate = 0.00,
    this.total = 0.00,
    this.packageType,
    this.vendor,
    this.pickupLocation,
    this.dropoffLocation,
    this.stopsLocation,
    this.allStops,
    this.date,
    this.time,
    this.recipientName,
    this.recipientPhone,
    this.width,
    this.height,
    this.length,
    this.weight,
    this.paymentMethod,
    this.isScheduled = false,
    this.deliverySlotDate = "",
    this.deliverySlotTime = "",
    this.coupon,
    this.token,
  });

  //
  factory PackageCheckout.fromJson(Map<String, dynamic> json) =>
      PackageCheckout(
        distance: json["distance"] == null
            ? null
            : double.parse(json["distance"].toString()),
        deliveryFee: json["delivery_fee"] == null
            ? null
            : double.parse(json["delivery_fee"].toString()),
        packageTypeFee: json["package_type_fee"] == null
            ? null
            : double.parse(json["package_type_fee"].toString()),
        subTotal: json["sub_total"] == null
            ? null
            : double.parse(json["sub_total"].toString()),
        tax: json["tax"] == null ? null : double.parse(json["tax"].toString()),
        taxRate: json["tax_rate"] == null
            ? null
            : double.parse(json["tax_rate"].toString()),
        total: json["total"] == null
            ? null
            : double.parse(json["total"].toString()),
        discount: json["discount"] == null
            ? null
            : double.parse(json["discount"].toString()),
        token: json["token"],
      );

  PackageCheckout copyWith({
    PackageCheckout packageCheckout,
  }) {
    this.distance = packageCheckout.distance;
    this.deliveryFee = packageCheckout.deliveryFee;
    this.packageTypeFee = packageCheckout.packageTypeFee;
    this.subTotal = packageCheckout.subTotal;
    this.tax = packageCheckout.tax;
    this.taxRate = packageCheckout.taxRate;
    this.total = packageCheckout.total;
    this.discount = packageCheckout.discount;
    this.token = packageCheckout.token;
    return this;
  }

  Map<String, dynamic> toJson() => {
    "distance": distance == null ? null : distance,
    "delivery_fee": deliveryFee == null ? null : deliveryFee,
    "package_type_fee": packageTypeFee == null ? null : packageTypeFee,
    "sub_total": subTotal == null ? null : subTotal,
    "tax": tax == null ? null : tax,
    "tax_rate": taxRate,
    "total": total == null ? null : total,
    "discount": discount,
    "token": token,
  };
}