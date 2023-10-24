import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/checkout.dart';
import 'package:fuodz/models/package_checkout.dart';
import 'package:fuodz/models/payment_method.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/constants/app_file_limit.dart';
import 'package:fuodz/utils/utils.dart';

class CheckoutRequest extends HttpService {
  //
  Future<List<PaymentMethod>> getPaymentOptions() async {
    final apiResult = await get(Api.paymentMethods);

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return PaymentMethod.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> newOrder(
      CheckOut checkout, {
        String note = "",
        String tip = "",
        List<Map> fees,
      }) async {
    Map singleorder = {
      "tip": tip,
      "note": note,
      "coupon_code": checkout.coupon?.code ?? "",
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "products": checkout.cartItems,
      "vendor_id": checkout.cartItems.first.product.vendorId,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "payment_method_id": checkout.paymentMethod.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "fees": fees,
      "total": checkout.total,
    };
    log("singleorder req===>>>>>${singleorder}");
    final apiResult = await post(
      Api.orders,
      {
        "tip": tip,
        "note": note,
        "coupon_code": checkout.coupon?.code ?? "",
        "pickup_date": checkout.deliverySlotDate,
        "pickup_time": checkout.deliverySlotTime,
        "products": checkout.cartItems,
        "vendor_id": checkout.cartItems.first.product.vendorId,
        "delivery_address_id": checkout.deliveryAddress?.id,
        "payment_method_id": checkout.paymentMethod.id,
        "sub_total": checkout.subTotal,
        "discount": checkout.discount,
        "delivery_fee": checkout.deliveryFee,
        "tax": checkout.tax,
        "fees": fees,
        "total": checkout.total,
      },
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> newMultipleVendorOrder(
      CheckOut checkout, {
        String note = "",
        String tip = "",
        @required Map payload,
      }) async {
    Map data = {
      ...payload,
      "tip": tip,
      "note": note,
      "coupon_code": checkout.coupon?.code ?? "",
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "payment_method_id": checkout.paymentMethod.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "total": checkout.total,
    };
    print("payload====>>>>>${payload}");
    log("payload full body====>>>>>${data}");
    final apiResult = await post(
      Api.orders,
      {
        ...payload,
        "tip": tip,
        "note": note,
        "coupon_code": checkout.coupon?.code ?? "",
        "pickup_date": checkout.deliverySlotDate,
        "pickup_time": checkout.deliverySlotTime,
        "delivery_address_id": checkout.deliveryAddress?.id,
        "payment_method_id": checkout.paymentMethod.id,
        "sub_total": checkout.subTotal,
        "discount": checkout.discount,
        "delivery_fee": checkout.deliveryFee,
        "tax": checkout.tax,
        "total": checkout.total,
      },
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> newPackageOrder(
      PackageCheckout packageCheckout, {
        String note,
      }) async {
    //fees
    List<Map> feesObjects = [];
    for (var fee in packageCheckout.vendor.fees) {
      double calFee = 0;
      String feeName = fee.name;
      if (fee.isPercentage) {
        calFee = fee.getRate(packageCheckout.subTotal);
        feeName = "$feeName (${fee.value}%)";
      } else {
        calFee = fee.value;
      }

      //
      feesObjects.add({
        "id": fee.id,
        "name": feeName,
        "amount": calFee,
      });
      //
    }

    final apiResult = await post(
      Api.orders,
      {
        "type": "package",
        "note": note,
        "coupon_code": packageCheckout.coupon?.code ?? "",
        "package_type_id": packageCheckout.packageType.id,
        "vendor_id": packageCheckout.vendor.id,
        "pickup_date": packageCheckout.date,
        "pickup_time": packageCheckout.time,
        "stops": packageCheckout.allStops != null
            ? packageCheckout.allStops.map((e) {
          return e.toJson();
        }).toList()
            : [],
        "recipient_name": packageCheckout.recipientName,
        "recipient_phone": packageCheckout.recipientPhone,
        "weight": packageCheckout.weight,
        "width": packageCheckout.width,
        "length": packageCheckout.length,
        "height": packageCheckout.height,
        "payment_method_id": packageCheckout.paymentMethod.id,
        "sub_total":
        (packageCheckout.subTotal - packageCheckout.deliveryFee) ?? 0.00,
        "discount": packageCheckout.discount,
        "delivery_fee": packageCheckout.deliveryFee,
        "tax": packageCheckout.tax,
        "tax_rate": packageCheckout.taxRate,
        "token": packageCheckout.token,
        "payer": packageCheckout.payer,
        "fees": feesObjects,
        "total": packageCheckout.total,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> newServiceOrder(
      CheckOut checkout, {
        List<Map> fees,
        Service service,
        String note,
      }) async {
    //
    final params = {
      "type": "service",
      "note": note,
      "service_id": service.id,
      "vendor_id": service.vendor.id,
      "delivery_address_id": checkout.deliveryAddress?.id,
      "pickup_date": checkout.deliverySlotDate,
      "pickup_time": checkout.deliverySlotTime,
      "hours": service.selectedQty,
      "service_price":
      service.showDiscount ? service.discountPrice : service.price,
      "payment_method_id": checkout.paymentMethod.id,
      "sub_total": checkout.subTotal,
      "discount": checkout.discount,
      "delivery_fee": checkout.deliveryFee,
      "tax": checkout.tax,
      "total": checkout.total,
      "coupon_code": checkout.coupon?.code ?? "",
      "fees": fees,
    };
    //
    final apiResult = await post(
      Api.orders,
      params,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> newPrescriptionOrder(
      CheckOut checkout,
      Vendor vendor, {
        @required File photo,
        String note = "",
        @required int payment_method_id,
        @required String status
      }) async {
    final apiResult = await postWithFiles(
      Api.orders,
      {
        "type": vendor.vendorType.slug,
        "note": note,
        "pickup_date": checkout.deliverySlotDate,
        "pickup_time": checkout.deliverySlotTime,
        "vendor_id": vendor.id,
        "delivery_address_id": checkout.deliveryAddress?.id,
        "sub_total": checkout.subTotal,
        "discount": checkout.discount,
        "delivery_fee": checkout.deliveryFee,
        "tax": checkout.tax,
        "total": checkout.total,
        "payment_method_id" : payment_method_id,
        "status" : status,
        "photo": await MultipartFile.fromFile(
          photo.path,
        ),
      },
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<double> orderSummary({int deliveryAddressId, int vendorId}) async {
    final params = {
      "vendor_id": "${vendorId}",
      "delivery_address_id": "${deliveryAddressId}",
    };

    //
    final apiResult = await get(
      Api.generalOrderSummary,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return PackageCheckout.fromJson(apiResponse.body).deliveryFee;
    }

    throw apiResponse.message;
  }
}
