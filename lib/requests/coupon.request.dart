import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class CouponRequest extends HttpService {
  //
  Future<List<Coupon>> fetchCoupons({
    int page = 1,
    bool byLocation = false,
    Map<String, dynamic> params,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...(params != null ? params : {}),
      "page": "$page",
      "latitude": LocationService?.currenctAddress?.coordinates?.latitude,
      "longitude": LocationService?.currenctAddress?.coordinates?.longitude,
      /*"latitude": byLocation
          ?LocationService?.currenctAddress?.coordinates?.latitude
          : null,
      "longitude": byLocation
          ? LocationService?.currenctAddress?.coordinates?.longitude
          : null,*/
    };

    debugPrint("queryParametersdsfdf ==> ${queryParameters}");

    //
    final apiResult = await get(
      Api.coupons,
      queryParameters: queryParameters,
    );
    debugPrint("queryParametersdsfdf ==> ${apiResult}");
    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Coupon.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message;
  }

  Future<Coupon> fetchCoupon(int id) async {
    String apiUrl = "${Api.coupons}/details/${id}"+"?latitude=${LocationService?.currenctAddress?.coordinates?.latitude}&longitude=${LocationService?.currenctAddress?.coordinates?.longitude}";
    debugPrint("apiUrlsdsdsd ==> ${apiUrl}");

    final apiResult = await get(apiUrl);
    //final apiResult = await get("${Api.coupons}/details/${id}");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      log("apiResponsesdsd ==> ${jsonEncode(apiResponse.body)}");
      return Coupon.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }
}
