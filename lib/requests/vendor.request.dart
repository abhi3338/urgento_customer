import 'package:flutter/material.dart';
import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/models/order_stop.dart';
import 'package:fuodz/models/review.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class VendorRequest extends HttpService {
  //
  Future<List<Vendor>> vendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map params,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...(params != null ? params : {}),
      "page": "$page",
      "latitude": byLocation
          ? LocationService?.currenctAddress?.coordinates?.latitude
          : null,
      "longitude": byLocation
          ? LocationService?.currenctAddress?.coordinates?.longitude
          : null,
    };

    //
    final apiResult = await get(
      Api.vendors,
      queryParameters: queryParameters,
    );

    print("queryParameters ==> $queryParameters");

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message;
  }

  //
  Future<List<Vendor>> topVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map params,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = [];
      vendors = apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      return vendors;
    }

    throw apiResponse.message;
  }

  Future<List<Vendor>> nearbyVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map params,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message;
  }

  Future<Vendor> vendorDetails(int id, {Map<String, String> params}) async {
    //
    final apiResult = await get(
      "${Api.vendors}/$id",
      queryParameters: params,
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Vendor.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }

  Future<List<Vendor>> fetchParcelVendors({
    int packageTypeId,
    @required int vendorTypeId,
    List<OrderStop> stops,
  }) async {
    final apiResult = await post(
      Api.packageVendors,
      {
        "vendor_type_id": vendorTypeId,
        "package_type_id": "$packageTypeId",
        "locations": stops.map(
              (stop) {
            return {
              "lat": stop.deliveryAddress.latitude,
              "long": stop.deliveryAddress.longitude,
              "city": stop.deliveryAddress.city,
              "state": stop.deliveryAddress.state,
              "country": stop.deliveryAddress.country,
            };
          },
        ).toList(),
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = (apiResponse.body['vendors'] as List)
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
      return vendors;
    }

    throw apiResponse.message;
  }

  //
  Future<ApiResponse> rateVendor({
    int rating,
    String review,
    int orderId,
    int vendorId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "vendor_id": vendorId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> rateDriver({
    int rating,
    String review,
    int orderId,
    int driverId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "driver_id": driverId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<Review>> getReviews({int page, int vendorId}) async {
    final apiResult = await get(
      Api.vendorReviews,
      queryParameters: {
        "vendor_id": vendorId,
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Review> reviews = apiResponse.data.map(
        (jsonObject) {
          return Review.fromJson(jsonObject);
        },
      ).toList();

      return reviews;
    }

    throw apiResponse.message;
  }
}
